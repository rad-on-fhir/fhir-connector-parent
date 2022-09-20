#!/bin/bash
set -ex
mvn clean package install

cd basic-fhir-connector
docker build -t srcblk/rad-on-fhir-basic-connector:latest .
cd ..

cd fhir-patient-linker
docker build -t srcblk/rad-on-fhir-patient-linker:latest .
cd ..