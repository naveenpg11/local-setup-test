# FROM openjdk:11
FROM openjdk:11-jre-slim

# Run as  Non root user
RUN adduser sa-user
USER sa-user

# Copy relevant binary and input files
WORKDIR /app
COPY bin /app
COPY testData.json /app

# Expose and set Entry point
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "localstack-demo-0.0.1-SNAPSHOT.jar", "--test.data.file.path=testData.json", "--amazon.dynamodb.endpoint=http://localstack:4566"]