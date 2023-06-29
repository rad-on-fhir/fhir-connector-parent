#!/bin/bash
set -ex
echo "update project"
git pull
echo "Update all git submodules"
git submodule update --init --recursive

#!/bin/bash

# Prüfen, ob unbestätigte Änderungen vorhanden sind
if git diff-index --quiet HEAD --; then
  echo "All changes are committed - building docker images"
else
  git status
  echo "There are changed files - abort"
  exit 1
fi

# Fortsetzung des Skripts ...


docker build -t srcblk/rad-on-fhir-basic-connector:latest . --target connector-run
docker build -t srcblk/rad-on-fhir-patient-linker:latest  . --target linker-run

cd pink-ui
docker build -t srcblk/ui-on-fhir:latest .
cd ..