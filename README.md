# CICD deployment using Jenkins pipeline to AWS Lambda function

Its README files are written in both, English and Korean. If you'd like to read in Korean, visit [README_ko.md](./README_ko.md).

Jenkins supports for both Declarative and Scripted pipeline syntax. Scripted syntax allows you to write with programmatic flexibly, Declarative Syntax has been support lately with visually concise and aims for easy maintenance.

Due the purpose of this repo is to create and run the pipeline using Jenkins. Issues that I've faced related to Jenkins or Syntax, and advanced features will be managed by Github [issue page](https://github.com/HaeyoonJo/devops-handson-jenkins-pipeline-py/issues).


# Project description

Dockerized python app is executed in a Lambda function, and CICD pipeline is implemented through configured Jenkinsfile along with the simple branch strategy for testing and deployments.

In the attached architecture image below, you can estimate of what resources is being executes and deploys in each stages by looking at it. 

> Image should be updated following new Jenkinsfile

<img src="./images/jenkins_pipeline.png" width="1000">