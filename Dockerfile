FROM openjdk:17.0.2-slim
EXPOSE 80
ARG JAR=build/libs/spring-petclinic-3.4.0.jar
COPY $JAR /app.jar
ENTRYPOINT["java","-jar","/app.jar"]
