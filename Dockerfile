FROM eclipse-temurin:17.0.7_7-jdk-jammy@sha256:b44dfb46bc455a4996762a65c97a5e1d0f8c71ad5139482003a1b34877518b72 as connector-basic-image
RUN addgroup --system spring && adduser --system spring --ingroup spring
RUN mkdir /rof  && mkdir /rof/config && chown spring:spring /rof -R

FROM connector-basic-image as connector-maven
RUN apt update && apt -y install maven
WORKDIR /build
RUN mkdir /build/abstract-fhir-connector && mkdir /build/basic-fhir-connector && mkdir /build/fhir-patient-linker
COPY "abstract-fhir-connector/pom.xml" "./abstract-fhir-connector/"
COPY "basic-fhir-connector/pom.xml" "./basic-fhir-connector/"
COPY "fhir-patient-linker/pom.xml" "./fhir-patient-linker/"
COPY pom.xml ./
RUN mvn verify compile --fail-never

FROM connector-maven as connector-build
COPY "abstract-fhir-connector/src" "./abstract-fhir-connector/src"
COPY "basic-fhir-connector/src" "./basic-fhir-connector/src"
COPY "fhir-patient-linker/src" "./fhir-patient-linker/src"
RUN mvn install -DskipTests=true
RUN chown spring:spring /build -R

FROM connector-basic-image as connector-run
WORKDIR /rof
USER spring
COPY --from=connector-build /build/basic-fhir-connector/target/*.jar connector.jar
EXPOSE 8080 33000
VOLUME /rof/config
ENTRYPOINT ["java","-jar","/rof/connector.jar"]

FROM connector-basic-image as linker-run
WORKDIR /rof
USER spring
COPY --from=connector-build /build/fhir-patient-linker/target/*.jar linker.jar
EXPOSE 8080
VOLUME /rof/config
ENTRYPOINT ["java","-jar","/rof/linker.jar"]