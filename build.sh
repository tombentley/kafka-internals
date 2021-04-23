#! /bin/sh
TAG=quay.io/tombentley/kafka-internals:latest
mkdir output
docker build --build-arg kafka_version=2.8.0 -t "$TAG" .
docker run --rm -v $(pwd)/output:/build/output:Z -v $(pwd)/src:/build/src:Z "$TAG" \
  asciidoctor -r asciidoctor-diagram -D output -R src src/master.adoc