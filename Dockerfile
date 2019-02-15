#Pull base image.
FROM ubuntu:16.04

#Install Node.js
RUN apt-get update
RUN apt-get install --yes sudo curl
RUN curl --silent --location https://deb.nodesource.com/setup_8.x | sudo bash -
RUN apt-get install --yes nodejs
RUN apt-get install --yes build-essential

