# FROM openjdk:11
FROM openjdk:11-jre-slim
# Run as  Non root user
RUN adduser sa-user
USER sa-user
# Copy relevant binary and input files
WORKDIR /app
COPY bin /app
COPY testData.json /app/testData.json
# Expose and set Entry point
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/app/localstack-demo-0.0.1-SNAPSHOT.jar", "--test.data.file.path=testData.json", "--amazon.dynamodb.endpoint=http://localstack:4566"]


#Ignore other pieces
# FROM openjdk:11-jdk-slim as builder

# # Compile application
# WORKDIR /app
# COPY . .

# FROM openjdk:11-jre-slim

# # Add application
# COPY --from=builder /app/bin/localstack-demo-0.0.1-SNAPSHOT.jar ./app.jar
# COPY --from=builder /app/testData.json ./testData.json

# ENTRYPOINT ["java", "-jar", "app.jar", "test.data.file.path", "testData.json", "amazon.dynamodb.endpoint", "http://localstack:4566"]