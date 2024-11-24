FROM adoptopenjdk/openjdk11:latest

EXPOSE 8080

WORKDIR /app

COPY database_service_project-0.0.4.jar /app/database_service.jar

ENTRYPOINT ["java", "-jar", "/app/database_service.jar"]
