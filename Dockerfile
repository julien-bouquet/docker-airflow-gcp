# Version: 1.0.0
# Author: Julien Bouquet
# Description: basic container Airflow

FROM ubuntu:18.04
LABEL maintainer="JBouquet"

# Install requirement 
RUN apt-get update -yqq \
	&& apt-get upgrade -yqq \
	&& apt-get install curl lsb-release -yqq

# Install Python
RUN apt-get install python3-dev python3-pip python-pip build-essential -yqq
RUN cd /usr/local/bin \
  && ln -s /usr/bin/python3 python \
  && pip3 install --upgrade pip

# Install pGcloud
RUN export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)" && \
    echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    apt-get update -y && apt-get install google-cloud-sdk -y

# Install GCSFuse
RUN export GCSFUSE_REPO=gcsfuse-`lsb_release -c -s` && \
    echo "deb http://packages.cloud.google.com/apt $GCSFUSE_REPO main" | tee /etc/apt/sources.list.d/gcsfuse.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    apt-get update -y && apt-get install gcsfuse -y
    
# Airflow repository
WORKDIR /project

# Install Airflow
RUN pip install google-cloud-storage apache-beam[gcp]==2.2.0 apache-airflow[gcp_api]==1.9.0 paramiko

RUN export AIRFLOW_HOME=/project/airflow_home \
    && airflow version

# Activate unit test
RUN sed -i 's/unit_test_mode = False/unit_test_mode = True/g' /project/airflow_home/airflow.cfg

# Configuration Airflow
RUN sed -i 's/dags_are_paused_at_creation = False/dags_are_paused_at_creation = True/g' /project/airflow_home/unittests.cfg \
 && sed -i 's/load_examples = True/load_examples = False/g' /project/airflow_home/unittests.cfg

# Install connector mySQL
RUN apt-get install -y libmysqlclient-dev \
    && pip install mysqlclient

# Configuration with mariaDB
RUN sed -i 's/executor = SequentialExecutor/executor = LocalExecutor/g' /project/airflow_home/unittests.cfg \
 && sed -i 's/sql_alchemy_conn = sqlite:\/\/\/\/project\/airflow_home\/unittests.db/sql_alchemy_conn = mysql:\/\/airflow:airflow@itcorp-airflow_mariadb_1:3306\/airflow/g' /project/airflow_home/unittests.cfg

RUN ln -s /project/dags ${AIRFLOW_HOME}/dags
RUN ln -s /project/plugins ${AIRFLOW_HOME}/plugins

# Initialize database 
RUN airflow initdb

