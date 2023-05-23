# Start with a base image containing Java runtime
FROM openjdk:8

# Make port 8080 available 
EXPOSE 8080 

COPY target/*.jar spring-boot-docker-maven.jar

# Run the jar file 
ENTRYPOINT ["java","-jar","spring-boot-docker-maven.jar"]
