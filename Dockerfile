FROM alpine:3.12
RUN mkdir -p /build/output && chmod ugo=rwx /build/output
WORKDIR /build
ARG kafka_version
RUN apk add --no-cache git; \
    git clone -b ${kafka_version} https://github.com/apache/kafka.git kafka-sources; 

# Now we need to bootstrap a whole build env because ruby gem compiles native gems
# Install the actual ruby stuff we want plus pygments.rb requires python3 to run pygments...
ENV BUILD_PACKAGES bash curl curl-dev ruby-dev build-base
ENV RUBY_PACKAGES \
  ruby \
  libffi-dev zlib-dev
RUN apk --no-cache add $BUILD_PACKAGES $RUBY_PACKAGES python3 \
  && gem install asciidoctor asciidoctor-diagram asciidoctor-revealjs pygments.rb json --no-doc

# Smcat is a node js app, so let's install all the popular scripting languages and be done
RUN apk --update --no-cache add nodejs nodejs-npm \
  && npm install --global state-machine-cat 

# Install seqdiag
RUN apk --no-cache add python3 py3-pip  py3-pillow ttf-inconsolata \
  && pip install seqdiag