#! /bin/sh
TAG=quay.io/tombentley/kafka-internals:latest
if [ ! -e output ] 
then
  mkdir output
fi

IMAGE_TIME=.image

if [ ! -e $IMAGE_TIME ] || [ Dockerfile -nt $IMAGE_TIME ]
then 
  docker build --build-arg kafka_version=2.8.0 -t "$TAG" .
  touch $IMAGE_TIME
fi 

# single HTML
docker run --rm -v $(pwd)/output:/build/output:Z -v $(pwd)/src:/build/src:Z "$TAG" \
  asciidoctor -r asciidoctor-diagram -D output -R src src/master.adoc
# PDF
docker run --rm -v $(pwd)/output:/build/output:Z -v $(pwd)/src:/build/src:Z "$TAG" \
  asciidoctor-pdf -r asciidoctor-diagram -D output -R src \
  src/master.adoc
# Presentation
docker run --rm -v $(pwd)/output:/build/output:Z -v $(pwd)/src:/build/src:Z "$TAG" \
  asciidoctor-revealjs \
  -D output -R src \
  -a revealjsdir=https://cdn.jsdelivr.net/npm/reveal.js@3.9.2 src/pres_bootstrap.adoc
cp src/pres.css output/

# # epub
# docker run --rm -v $(pwd)/output:/build/output:Z -v $(pwd)/src:/build/src:Z "$TAG" \
#   asciidoctor-epub3 \
#     -D output \
#     -R src \
#     -a ebook-validate \
#     --verbose \
#     src/master-epub.adoc
