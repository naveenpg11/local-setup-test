SuperAwesome local code test environment for platform engineers
====================================

Self contained coding exercise, where candidates will be able to run everything in their local environment without the need to create accounts or systems somewhere relying on purely open source stack.

# Before you Begin

We want you to complete as much as you can. If you cannot finish all of the challenges don't be disheartened! We still want to see how far you got! We designed this test to assess all levels of ability, we are not expecting every candidate to complete it.

### **Required software on your machine**:
 - [docker](https://docs.docker.com/get-docker/) desktop or docker engine & docker compose
 - [terraform](https://www.terraform.io/downloads.html) >= 1.0.0
 - aws cli = latest

# Code Challenges:

The numbered challenges below are ordered and designed to build on each other as you progress. Each challenge will enable you to complete the next if done in order. However, you are not required to do them in the set order if you find a different way to approach the test.

We have given you a pre-configured local environment running both DynamoDB (via localstack) & Jenkins with pre-configured jobs & runtime environment to complete the tasks below.

The first 2 challenges can be completed from your local machine with the aid of `docker desktop`, `localstack` & `terraform v1.0+`, challenges 3 & 4 will require the use of Jenkins.

Please refer to [The Help Section](#help) for how to access Jenkins & Terraform sections of this repo.

To begin the test, start the local environment:

```shell
./run.sh
```

>#### **Note**: Depending on your computers available resources this can take up to 10 minutes to fully start up.

## 1) Dockerise Demo App:
---

The first part of this test is to create a working Docker file that runs the demo app located in [./app/bin](./app/bin).

The skeleton Dockerfile is located [here](./app/Dockerfile)

>#### **NOTE**: The included binary is fully functioning to the below spec. Localstack is run in a containerised environment, be aware that access to it will need to be established over a docker network.

#### **What the app does**:
------------------

This is very simple spring boot application, it starts and runs on port 8080

The app will try to connect to local dynamoDB running with [localstack](https://github.com/localstack/localstack). Assuming default port and connection details http://localhost:4566

The app itself exposes REST API, and by calling http://localhost:8080/orders will scan the orders dynamoDB table and provide all persisted orders within.

The app requires a local JSON file to bootstrap the orders table and feed it with necessary state. Without that file in place the app will fail to start providing an error. The file can be found [here](./app/testData.json)

Same goes if the app won't be able to find dynamoDB table provisioned with 5 read capacity units and 7 write capacity units.

The table schema, that is needed is as follows:

#### **Table Schema**:
```
Table name: Orders

Read Capacity Units: 5
Write Capacity Units: 7

Partition Key:
name is: id
Type: string
```

But we will worry about it later.

#### **Input JSON Data**:
The input data file is provided as part of the app directory as [follows](./app/testData.json).

Below is an example of how to run the app:

```shell
java -jar localstack-demo-0.0.1-SNAPSHOT.jar --test.data.file.path=../testData.json --amazon.dynamodb.endpoint=http://localstack:4566
```

### What we want from you:
- A dockerfile that successfully builds
- Include JSON data to feed the app.
- A docker image that runs according to the above spec
    - Successfully start the app & receive errors connecting to DynamoDB as this is not available yet. It might have also failures with errors in case DynamoDb table wasn't created according to the schema. Or can't find the input file
    - The image should not run as root

### Success criteria:
- A docker image which runs the demo app running as a **non-root** user.
- Docker image that runs & errors when trying to connect to DynamoDB
- An explanation of the solution and how to run it in a doc.
    - Including scripts to help demonstrate the solution is perfectly acceptable.

## 2) Create DynamoDB Table using Terraform:
---

In a typical modern software environment we need to make cloud infrastructure available before our applications will run successfully. In this challenge we want you to create a DynamoDB table using `terraform`. This will run within the local environment using the pre-configured `localstack` instance you just started with `./run.sh`

If you are unfamiliar with Terraform, [here is a link](https://learn.hashicorp.com/tutorials/terraform/install-cli?in=terraform/aws-get-started#install-terraform) to their getting started guide & how to get the binary installed and running.

We need the code to be able to receive different parameters from a [variable file](https://www.terraform.io/docs/language/values/variables.html#variable-definitions-tfvars-files) in order to update values as and when our requirements change. These parameters are:

- Table Name
- Read capacity
- Write capacity
- The hash or partition key
    - Key type
    - Key name

The required schema for the table as outlined in challenge 1 is:
#### **Table Schema**:
```
Table name: Orders

Read Capacity Units: 5
Write Capacity Units: 7

Partition Key:
name is: id
Type: string
```

We have provided a skeleton directory containing TF code to get you started, this can be found in [./terraform](./terraform)

To validate the applied terraform code you can run the below command to query DynamoDB within localstack:

```shell
aws --profile sa-code-test --endpoint-url=http://localhost:4566 dynamodb list-tables
```
### What we want from you:
- Terraform code that meets the above spec.
- A successfully provisioned DynamoDB table driven from parameters defined above using Terraform

### Success criteria:
- Terraform code in the `./terraform` directory which provisions a DynamoDB to the above spec.
    - Should be run form your local machine.
    - Run this command to validate your changes: `aws --profile sa-code-test --endpoint-url=http://localhost:4566 dynamodb list-tables`
- An explanation of the solution and how to run it in a doc.
    - Including scripts to help demonstrate the solution is perfectly acceptable.

Refer to the [The Help Section](#help) if you get stuck.


## 3) Plan & Apply your TF Code with Jenkins:
---

>#### **BEFORE YOU BEGIN**: All code in `app` & `terraform` directories are available within Jenkins automatically under the paths: `/src/app` & `/src/terraform` and they will live update within Jenkins so you do not need to manage loading the code into Jenkins yourself.

<br /> Now you have a working containerised application & some IaC to spin up the dependencies, we now want you to add this to a continuous delivery pipeline.

The local environment you started at the very beginning of this code challenge has a pre-configured `Jenkins` instance with some skeleton jobs already setup.

See [The Help Section](#help) on how to access your Jenkins instance & manage it.

You will find all of your source code in the following directories:
- `/src/app` contains the `app` directory in this repo
- `/src/terraform` contains the `terraform` directory in this repo
>#### **IMPORTANT**: Before you proceed Jenkins will modify this file: [./terraform/providers.tf](./terraform/providers.tf) on disk to enable compatibility with localstack within the docker network environment. If you need to re-run TF locally revert `http://localstack:4566` to `http://localhost:4566` in the previously mentioned file.

### What we want from you:
- A Jenkins pipeline that successfully plans & applies your terraform code from challenge 1
- Include your changes in the following file when complete: [./jenkins/jobs/exported_config.xml](./jenkins/jobs/exported_config.xml)
    - This can be easily done by running: `./jenkins/jobs/export_job.sh`

### Success criteria:
- The pre-configured Jenkins Pipeline runs the Terraform code automatically before the app is built & deployed:
    - Jenkins should plan & output a plan file in the plan step.
    - Jenkins should apply the plan file in the apply step.
- An explanation of the solution and how to run it in a doc.
    - Your solution should be exported using the `./jenkins/jobs/export_job.sh` script & available in `./jenkins/jobs/exported_config.xml`.

## 4) Build & Run the Dockerised App using Jenkins:
---

Now the IaC is being deployed via a Jenkins pipeline, we now want to make sure our app is automatically built and run against our provisioned infrastructure.

Within the same pipeline used in challenge 3, complete the build & deploy steps so the container image is built and then run from Jenkins.

The app should be accessible from your local machine in a browser on port: 8080 by default. Feel free to bind it to a different port if needed.

We have bootstrapped Jenkins with a deploy step that can give you some pointers on where to start in the build step.

You will find all of your source code in the following directories within Jenkins:
- `/src/app` contains the `app` directory in this repo
- `/src/terraform` contains the `terraform` directory in this repo

See [The Help Section](#help) on how to access your Jenkins instance & manage it.

### What we want from you:
- The full Jenkins pipeline running successfully from start to finish.
- The demo app accessible from your local machine reading values from the provisioned DynamoDB table.
- The demo app uses the `sha` ID of the container each time the deploy step runs.
- Include your changes in the following file when complete: [./jenkins/jobs/exported_config.xml](./jenkins/jobs/exported_config.xml)
    - This can be easily done by running: `./jenkins/jobs/export_job.sh`

### Success criteria:
- The pre-configured Jenkins Pipeline runs the Docker Build code automatically before the app is deployed:
    - Jenkins build the docker file & tag it appropriately.
    - Jenkins should run the container using the latest `sha` digest of the image every time the deploy step is run.
    - The running container should be accessible from your local machine in browser via: http://localhost:8080/orders
- An explanation of the solution and how to run it in a doc.
    - Your solution should be exported using the `./jenkins/jobs/export_job.sh` script & available in `./jenkins/jobs/exported_config.xml`.

# Help
### Jenkins:

To access jenkins once the environment has started up, browse to: http://localhost:8081/blue to get started. If you need to login the credentials are: `admin:admin`

All configuration & data will persist in a named docker volume if you need to restart the Jenkins server.

If you corrupt your configuration, run: `docker volume rm sa-platform-engineer-code-test_jenkins-home` and re-run `./run.sh` to reset back to the bootstrap config.

Export jobs configs:
```shell
./jenkins/jobs/export_job.sh
```
This above script will drop the exported job into the current working directory

You will find all of your source code in the following directories within Jenkins:
- `/src/app` contains the `app` directory in this repo
- `/src/terraform` contains the `terraform` directory in this repo

### Terraform:

To get started with Terraform, you can find template code within the `./terraform` directory which will run against the local environment. The `providers.tf` file is pre-configured & does not need modification.

To validate your changes you deploy via Terraform run:

```shell
aws --profile sa-code-test --endpoint-url=http://localhost:4566 dynamodb list-tables
```
