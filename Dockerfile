FROM python:3.6.8-slim-stretch

RUN apt-get update \
  && apt-get install -y zip make \
  && pip install awscli