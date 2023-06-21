#!/bin/bash
set -ex
mvn clean package install

cd basic-fhir-connector
docker build -t srcblk/rad-on-fhir-basic-connector:latest .
cd ..

cd fhir-patient-linker
docker build -t srcblk/rad-on-fhir-patient-linker:latest .
cd ..

cd pink-ui
docker build -t srcblk/ui-on-fhir:latest .
cd ..