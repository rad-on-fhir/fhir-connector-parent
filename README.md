# fhir-connector-base

This project should be used to develop the various fhir-connectors in one central place
with the various system implementations in the submodules.

### Build Docker Images

If all git submodules are up to date you can run the 
`./build-docker.sh` Script. It will build and create all Docker Images locally.


### Environment

for Pink.ui set the following Environments according to your needs: 

```
KEYCLOAK_URL=127.0.0.1:18080
KEYCLOAK_REALM=PINK
KEYCLOAK_CID=PINK.ui
KEYCLOAK_CSECRET="<your secret>"
KEYCLOAK_USESSL=false
KEYCLOAK_CALLBACK_HOST=http://your-external-ui
FHIR_URL=http://127.0.0.1:8080/fhir
FHIR_DATE_FORMAT=yyyy-MM-dd
KEYCLOAK_CALLBACK_HOST=http://<ip/domain>:<port>/
```