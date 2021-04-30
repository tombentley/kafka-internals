FROM alpine:latest
RUN mkdir -p /build/output && chmod ugo=rwx /build/output
WORKDIR /build
ARG kafka_version
RUN apk add --no-cache git; \
    git clone -b ${kafka_version} https://github.com/apache/kafka.git kafka-sources; 

# Now we need to bootstrap a whole build env because ruby gem compiles native gems
ENV BUILD_PACKAGES bash curl curl-dev ruby-dev build-base
ENV RUBY_PACKAGES \
  ruby \
  libffi-dev zlib-dev
RUN apk --no-cache add $BUILD_PACKAGES $RUBY_PACKAGES
# Install the actual ruby stuff we want
RUN gem install asciidoctor asciidoctor-diagram asciidoctor-revealjs pygments.rb json --no-doc
# pygments.rb requires python3 to run pygments...
RUN apk --no-cache add python3
# and smcat is a node js app, so let's install all the popular scripting languages and be done
RUN apk --update --no-cache add nodejs nodejs-npm
RUN npm install --global state-machine-cat 

