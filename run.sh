#!/bin/bash -e
source .env

AWS_PROFILE_NAME="sa-code-test"
DOCKER_NETWORK_NAME="sa-code-test"

if cat ~/.aws/credentials | grep -q "$AWS_PROFILE_NAME" ; then
    echo -e "\033[0;33m The $AWS_PROFILE_NAME aws cli profile already configured \033[0m"
else
    echo -e "\033[0;33m Configuring $AWS_PROFILE_NAME aws cli profile \033[0m"
if [ ! -d ~/.aws ]; then mkdir ~/.aws ; fi
cat << AWS_CREDENTIAL_EOF | tee -a ~/.aws/credentials
[$AWS_PROFILE_NAME]
aws_access_key_id=$AWS_ACCESS_KEY_ID
aws_secret_access_key=$AWS_SECRET_ACCESS_KEY
AWS_CREDENTIAL_EOF
cat << AWS_CONFIG_EOF | tee -a ~/.aws/config
[profile $AWS_PROFILE_NAME]
region=$DEFAULT_REGION
output=json
AWS_CONFIG_EOF
fi

echo -e "\033[0;33m Creating docker network: ${DOCKER_NETWORK_NAME}...\033[0m"

docker network inspect ${DOCKER_NETWORK_NAME} >/dev/null 2>&1 || \
docker network create --driver bridge ${DOCKER_NETWORK_NAME}

docker-compose down

docker-compose up --build -d

echo -e "\033[0;33m Waiting for Jenkins become available...\033[0m"
bash -c 'while [[ "$(curl -k -s -o /dev/null -w ''%{http_code}'' http://localhost:8081/login?from=/)" != "200" ]]; do sleep 3; done' || false
echo -e "\033[0;33m Jenkins available on http://localhost:8081/blue \033[0m"
echo -e "\033[0;33m username and passwordf is admin\033[0m"
echo -e "\033[0;33m Example command for aws cli usage with locastack\033[0m"
echo -e "\033[0;33m  aws --profile $AWS_PROFILE_NAME --endpoint-url=http://localhost:4566 dynamodb list-tables \033[0m"
echo -e "\033[0;33m or you can use awslocal link: https://github.com/localstack/awscli-local \033[0m"
