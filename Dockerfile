# Use AdoptOpenJDK 11 as the base image
FROM adoptopenjdk/openjdk11:latest

# Set the working directory inside the container
WORKDIR /app

# Copy the JAR file into the container
COPY database_service_project-0.0.4.jar /app/database_service.jar

# Expose port 8082 for the application
EXPOSE 8082

# Define the command to run the JAR file
ENTRYPOINT ["java", "-jar", "/app/database_service.jar"]
