# CICD deployment using Jenkins pipeline to AWS Lambda function

Its README files are written in both, English and Korean. If you'd like to read in Korean, visit [README_ko.md](./README_ko.md).

Jenkins supports for both Declarative and Scripted pipeline syntax. Scripted syntax allows you to write with programmatic flexibly, Declarative Syntax has been support lately with visually concise and aims for easy maintenance.

Due the purpose of this repo is to create and run the pipeline using Jenkins. Issues that I've faced related to Jenkins or Syntax, and advanced features will be managed by Github [issue page](https://github.com/HaeyoonJo/devops-handson-jenkins-pipeline-py/issues).


# Project description

Dockerized python app is executed in a Lambda function, and CICD pipeline is implemented through configured Jenkinsfile along with the simple branch strategy for testing and deployments.

In the attached architecture image below, you can estimate of what resources is being executes and deploys in each stages by looking at it. 

> Image should be updated following new Jenkinsfile

<img src="./images/jenkins_pipeline.png" width="1000">

### Jenkins Pipeline

1. Agent

- I specified `any` agent, so the Jenkins pipeline can be run in any available environment. You can take a look about Agent parameters by visiting Jenkins [Agent parameters](https://www.jenkins.io/doc/book/pipeline/syntax/#agent-parameters) docs.

2. Parameters

- the pipeline gets the parameters from Jenkins job that has configured in the Jenkins configuration, In order to keep the critical data such as credentials in security purpose. By that, I expect making easier to collaborate and reduce security issues that might be incur.

3. Environment

- Declared Constants variables to be used in the Jenkinsfile.

4. Build

- building docker image using `docker.build()` by [Docker pipeline](https://plugins.jenkins.io/docker-workflow/). You can also take a look other functions for pipeline script in the following [pipeline-syntax](https://opensource.triology.de/jenkins/pipeline-syntax/globals) page

5. RIE Test

- Python app is being generated as docker image and upload into Lambda function. In order for running test can be done by [RIE (Runtime Interface Emulator)](https://docs.aws.amazon.com/lambda/latest/dg/images-test.html), which AWS supports.