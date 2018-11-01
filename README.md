# docker-airflow-gcp

[![Docker Build Status](https://img.shields.io/docker/build/julienbouquet/docker-airflow-gcp.svg)]()

[![Docker Hub](https://img.shields.io/badge/docker-ready-blue.svg)(https://hub.docker.com/r/julienbouquet/docker-airflow-gcp/)
[![Docker Pulls](https://img.shields.io/docker/pulls/julienbouquet/docker-airflow-gcp.svg)]()
[![Docker Stars](https://img.shields.io/docker/stars/julienbouquet/docker-airflow-gcp.svg)]()

This repository contains **Dockerfile** to instanciate an [apache-airflow](https://github.com/apache/incubator-airflow). This images is published on [Docker Hub](https://registry.hub.docker.com/).

## Informations

Based on ubuntu:18.04 official Image
Install Docker
Install Docker Compose

This images of airflow has been done for development.

## Usage

Launch docker-airflow-gcp.

```bash
     git clone https://github.com/julien-bouquet/docker-airflow-gcp.git
     cd docker-airflow-gcp
     docker-compose up
```

In `docker-compose.yml`, you need to change the repository of project. Currently ariflow is linked with this folder and not yout project. 

It's will be pull images docker-airflow-gcp and mariadb to works on your computer. 
Open a new console. and launch 

```bash
    docker exec -it docker exec -it docker-airflow-gcp_airflow_1 /bin/bash
```

Now you can use Airflow with a command like and test :

```bash
    airflow list_dags
    airflow test NAME_OF_DAGS NAME_OF_TAKS date +%Y%m%d
```

If you want a webserver of airflow, you can execute: 

```bash
    airflow webserver && airflow scheduler
```