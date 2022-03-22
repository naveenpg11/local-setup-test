# SuperAwesome code test

Thanks for the oppurtunity to take up the code challenge.

## 1. Dockerise Demo App

##### Files used:
- `./app/Dockerfile` 
    - Used `openjdk:11-jre-slim` as base Image to build image (Instead of openjdk:11, better image size)
    - Created Non Root user called `sa-user`
    - Copied binary file and input feed into the working Directory
    - Exposed Port 8080 and Run Java application

### How to build and run
(to test if application is succesfully build and run)

```
docker build -t demo:latest .
docker run -d -p 8080:8080 demo:latest
```
### How to test if application is running

```
docker ps // (Fetch container_id)
docker logs {container_id}
```
(Docker image will run & errors when trying to connect to DynamoDB)
## 2. Terraform - DynamoDB Provisioning

In a typical modern software environment we need to make cloud infrastructure available before our applications will run successfully. In this challenge we need to create a DynamoDB table using `Terraform`.

##### Files used:
 -  `./terraform/terraform.tfvars` - We use terraform.tfvar to update input values as and when our requirement changes.
-  `./terraform/variables.tf` - Each input variable accepted by our `main` module is declared using a variable block
 -  `./terraform/main.tf` - This is the root module of our terraform block, DynamoDb resource creation is configured here
 -  `./terraform/output.tf` - Each output value exported by a module must be declared using an output block

### How to run 
###### Run Below commands to provision infrastructure
- Do changes in `terraform.tfvars` as per your requirement 
```
terraform init
terraform plan -out=outfile
terraform apply outfile
```

To validate the applied terraform code you can run the below command to query DynamoDB within localstack:

```shell
aws --profile sa-code-test --endpoint-url=http://localhost:4566 dynamodb list-tables
```
## 3. Jenkins : (Terraform - Plan and Apply)

##### Explanation - 
- After we run `./run.sh`, Local Env is Set, /app and /terraform is also mounted in /src
- navigate to `localhost:8081/blue` endpoint
- The current `sample-app-build-and-deploy` is the preconfigured job, which has dummy place holder for the pipeline stages
- Navigate to the setting for the job and modify the pipeline stages
    - Stage: `(IaaC Plan)`  Init terraform and plan the changes in a file called `outfile`
    - Stage: `(IaC Apply)`  Navigate to the folder and apply the changes using `outfile`
    - Save the pipeline steps
- Now Start the job to see the pipeline job creating the dependant DyanmoDb Resources using terraform. 

```
       stage('IaC Plan') {
            steps {
                sh 'cd /src/terraform && sed -i s/localhost/localstack/g providers.tf'
                sh 'cd /src/terraform && terraform init'
                sh 'cd /src/terraform && terraform plan -out=outfile'
            }
        }
        stage('IaC Apply') {
            steps {
                sh 'echo "Apply TF"'
                sh 'cd /src/terraform && terraform apply outfile'
            }
        } 
```

## 4. Jenkins : (Adding Build and deploy capability)

##### Explanation - 
- After completing challenge#3, we need to build and deploy the app
- Navigate to the setting for the job and add two more pipeline stages
    - Stage: `(Docker Build)` - Build and tags the docker image as `demoapp:latest` and also prints latest `sha` of the image
    - Stage: `(Docker Deploy)` - Runs the `sha` digest of the image in network `sa-code-test` and exposes the app in 8085
        - we used `docker images --no-trunc --quiet demoapp:latest` to get `SHA` of the image
- Container should be accessible from your local machine in browser via: http://localhost:8085/orders
- (Both the stage could have also put it in single command as well `docker run  --network sa-code-test --rm -p 8085:8080 -d $(docker build -q .)` )

```
        stage('Docker Build') {
            steps {
                
                sh 'echo "Building docker"'
                sh 'cd /src/app && docker build -q -t demoapp:latest . '
                sh 'echo "Docker image generated"'
            }
        }
        stage('Docker Deploy') {
            steps {
                
                sh 'echo "Deploying docker"'
                sh 'cd /src/app && docker run  --network sa-code-test --rm -p  :8080 -d $(docker images --no-trunc --quiet demoapp:latest) '
                sh 'echo "Docker deployed and endpoint is up"'
            }
        }
```


## Other changes

There were couple of change which has to be made in Jenkin's DockerFile to set up the local environment to work in Macbook M1.

1. To download and install `docker-ce-cli` in jenkins docker, deb [arch=amd64] has to be changed to `deb [arch=arm64]`
2. HashiCorp APT server currently has packages only for the amd64 arch, so i had to download zip and install terraform.
reference link : https://www.terraform.io/cli/install/apt#supported-architectures



