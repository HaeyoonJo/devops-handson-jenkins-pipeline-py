/*
see https://www.jenkins.io/doc/book/pipeline/jenkinsfile/#creating-a-jenkinsfile
    https://jenkins.io/doc/book/pipeline/syntax/

see branch strategy by visiting 
    https://www.jenkins.io/doc/tutorials/build-a-multibranch-pipeline-project/#add-deliver-and-deploy-stages-to-your-pipeline
    https://www.jenkins.io/blog/2017/01/19/converting-conditional-to-pipeline/

>>>>>>>
Take a look for HANDLING failure
https://www.jenkins.io/doc/book/pipeline/jenkinsfile/#handling-failure
>>>>>>>
*/
pipeline {
    agent any

    parameters {
        string(name: "account_id", description: "AWS accountID")
        string(name: "jenkins_credential", description: "Jenkins Credential")
        string(name: "ecr_repo_name", description: "ECR Repo name")
        string(name: "dockerhub_credential", description: "DockerHub Credential")
    }

    environment {
        BRANCH = "${env.GIT_BRANCH}"
        REGISTRY_ECR_REPO = "dkr.ecr.eu-west-1.amazonaws.com"
        REGISTRY = "orcahaeyoon/jenkins_repo"
        VERSION = "latest"
        VERSION_DEV = 0.1
        DOCKER_NETWORK = "lambda_net"
        DOCKER_NETWORK_ALIAS = "lambda"
        LAMBDA_FUNCTION = "devops-lambda-pipeline"
        TEST_BUILD_IMAGE = "devops_lambda/test"
        MAP_PORT = 8080
    }

    stages {

        stage("building mysql") {
            // agent {
            //     docker {
            //         image 'mysql'
            //         reuseNode true
            //         args "-e MYSQL_ROOT_PASSWORD=root"
            //     }
            // }
            steps {
                script {
                    docker.image('mysql:latest').withRun('-e "MYSQL_ROOT_PASSWORD=root"') { c ->
                        docker.image('mysql:5').inside("--link ${c.id}:db") {
                            sh 'mysql --default-authentication-plugin=mysql_native_password'
                        }
                    }
                }
            }
        }

        // stage('mysql test') {
        //     agent {
        //         docker {
        //             image 'mysql'
        //             reuseNode true
        //             args "-e MYSQL_ROOT_PASSWORD=root"
        //             command "--default-authentication-plugin=mysql_native_password"
        //         }
        //     }
        // }
    }

    // stages {

    //     stage("Build") {
    //         steps {
    //             script {
    //                 testLocalImage = docker.build("${TEST_BUILD_IMAGE}:${VERSION_DEV}")
    //             }
    //         }
    //     }

    //     /*
    //         Checkpoint
    //             1. sh 'sleep SECOND': 
    //                 use sleep when docker container launching takes too long
                
    //             2. Docker container connection refused
    //                 check the issue by visiting https://github.com/HaeyoonJo/devops-handson-jenkins-pipeline-py/issues/1
    //     */
    //     stage("RIE Test") {
    //         steps {
    //             script {
    //                 sh "docker network create --driver bridge ${DOCKER_NETWORK} || true"
    //                 testLocalImage.withRun("-p ${MAP_PORT}:${MAP_PORT} --network-alias ${DOCKER_NETWORK_ALIAS} --net ${DOCKER_NETWORK} --name ${LAMBDA_FUNCTION}") {c ->
    //                     // sh 'sleep 5'
    //                     sh "docker ps"
    //                     sh """
    //                     docker exec -i ${LAMBDA_FUNCTION} \
    //                         curl -l "http://0.0.0.0:${MAP_PORT}/2015-03-31/functions/function/invocations" \
    //                         -H \"Accept:application/json\" \
    //                         -d '{"jenkins": "Jenkins test by devops"}'
    //                     """
    //                 }
    //             }
    //             sh "docker network rm ${DOCKER_NETWORK}"
    //             sh "docker rmi ${TEST_BUILD_IMAGE}:${VERSION_DEV}"
    //         }
    //     }

    //     // Docker registry
    //     //    Github: https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-docker-registry
    //     //    Docker Hub: Currently in use
    //     stage("Deploy Image Registry") {
    //         when {
    //             expression { "${BRANCH}" == 'origin/dev' }
    //         }
    //         steps {
    //             script {
    //                 dockerHubImage = docker.build REGISTRY + ":$VERSION_DEV"
    //                 docker.withRegistry('', "${params.dockerhub_credential}") {
    //                     dockerHubImage.push()
    //                 }
    //                 sh "docker rmi ${REGISTRY}:${VERSION_DEV}"
    //             }
    //         }
    //     }

    //     stage("Login ECR") {
    //         when {
    //             expression { "${BRANCH}" == 'origin/master' }
    //         }
    //         steps {
    //             withAWS(credentials: "${params.jenkins_credential}") {
    //                 sh """
    //                     aws ecr get-login-password \
    //                         --region eu-west-1 \
    //                         | docker login \
    //                         --username AWS \
    //                         --password-stdin https://${params.account_id}.${REGISTRY_ECR_REPO}
    //                 """
    //             }
    //         }
    //     }

    //     stage("Deploy Image ECR") {
    //         when {
    //             expression { "${BRANCH}" == 'origin/master' }
    //         }
    //         steps {
    //             script {
    //                 docker.withRegistry("http://${params.account_id}.${REGISTRY_ECR_REPO}") {
    //                     def myImage = docker.build("${params.account_id}.${REGISTRY_ECR_REPO}/${params.ecr_repo_name}")
    //                     myImage.push ("${VERSION}")
    //                 }
    //                 sh "docker rmi ${params.account_id}.${REGISTRY_ECR_REPO}/${params.ecr_repo_name}:${VERSION}"
    //             }
    //         }
    //     }

    //     stage("Deploy Lambda") {
    //         when {
    //             expression { "${BRANCH}" == 'origin/master' }
    //         }
    //         steps {
    //             withAWS(credentials: "${params.jenkins_credential}") {
    //             sh """
    //             aws lambda update-function-code \
    //             --function-name ${LAMBDA_FUNCTION} \
    //             --image-uri ${params.account_id}.${REGISTRY_ECR_REPO}/${params.ecr_repo_name}:${VERSION}
    //             """
    //             }
    //         }
    //     }

    // }
}