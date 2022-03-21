# FROM openjdk:11
# FROM adoptopenjdk/openjdk11:alpine-jre
FROM openjdk:11-jre-slim


RUN adduser sa-user
USER sa-user


WORKDIR /app
COPY bin /app
COPY testData.json /app/testData.json

EXPOSE 8080
# RUN java -jar localstack-demo-0.0.1-SNAPSHOT.jar --test.data.file.path=testData.json --amazon.dynamodb.endpoint=http://localhost:4566
ENTRYPOINT ["java", "-jar", "localstack-demo-0.0.1-SNAPSHOT.jar", "test.data.file.path", "testData.json", "amazon.dynamodb.endpoint", "http://localstack:4566"]

# ENTRYPOINT [ "java", "-jar", "localstack-demo-0.0.1-SNAPSHOT.jar" ]



# FROM openjdk:11-jdk-slim as builder

# # Compile application
# WORKDIR /app
# COPY . .

# FROM openjdk:11-jre-slim

# # Add application
# COPY --from=builder /app/bin/localstack-demo-0.0.1-SNAPSHOT.jar ./app.jar
# COPY --from=builder /app/testData.json ./testData.json

# ENTRYPOINT ["java", "-jar", "app.jar", "test.data.file.path", "testData.json", "amazon.dynamodb.endpoint", "http://localstack:4566"]