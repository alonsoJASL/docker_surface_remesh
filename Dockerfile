FROM ubuntu:18.04

LABEL maintainer="jsolislemus <j.solislemus@kcl.ac.uk>"

SHELL [ "/bin/bash", "-c"]

RUN apt-get update --fix-missing && \
    apt-get install -y wget bzip2 curl git libgfortran4 libxt6 libgl1-mesa-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir /data && mkdir /code

RUN git clone https://github.com/alonsoJASL/imatools.git /code/imatools && \
    git clone https://github.com/samcoveney/quLATi.git /code/quLATi
