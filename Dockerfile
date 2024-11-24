FROM adoptopenjdk/openjdk11
    
EXPOSE 8082
 
ENV APP_HOME /usr/src/app

COPY /var/jenkins_home/workspace/BoardGame/target/database_service_project-0.0.4.jar $APP_HOME/app.jar

WORKDIR $APP_HOME

CMD ["java", "-jar", "app.jar"]
