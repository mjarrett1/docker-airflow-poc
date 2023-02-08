# Download base image ubuntu 22.04
FROM ubuntu:22.04

# LABEL about the custom image
LABEL maintainer="MJARRETT"
LABEL version="0.1"
LABEL description="POC dockerfile for airflow install."

# Disable Prompt During Packages Installation
ARG DEBIAN_FRONTEND=noninteractive

# Update and install needed packages.
RUN apt-get update && \
apt-get install -y python3 && \
apt-get install -y python3-pip && \
apt-get install -y nano && \
apt-get -y install postgresql && \
apt-get -y install libpq-dev

# Install needed python libraries.
# Install Psycopg2.
RUN pip3 install Psycopg2

# Copy the updated airflow.cfg file to the container.
COPY ./airflow.cfg root/airflow/airflow.cfg

# Run shell script to install airflow.
COPY ./airflow_setup.sh /airflow_setup.sh
RUN bash airflow_setup.sh