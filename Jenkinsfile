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
    }

    environment {
        BRANCH = "${env.GIT_BRANCH}"
        REGISTRY_ECR_REPO = "dkr.ecr.eu-west-1.amazonaws.com"
        REGISTRY_ECR_REPO_DEV = ""
        VERSION = "latest"
        VERSION_DEV = "0.1"
        DOCKER_NETWORK = "lambda_net"
        DOCKER_NETWORK_ALIAS = "lambda"
        LAMBDA_FUNCTION = "devops-lambda-pipeline"
        TEST_BUILD_IMAGE = "devops_lambda/test"
        MAP_PORT = 8080
    }

    stages {

        stage("Build") {
            steps {
                script {
                    testLocalImage = docker.build("${TEST_BUILD_IMAGE}:${VERSION_DEV}")
                    sh "docker images"
                }
            }
        }

        /*
            Checkpoint
                1. sh 'sleep SECOND': 
                    use sleep when docker container launching takes too long
                
                2. Docker container connection refused
                    check the issue by visiting https://github.com/HaeyoonJo/devops-handson-jenkins-pipeline-py/issues/1
        */
        stage("RIE Test") {
            steps {
                script {
                    sh "docker network create --driver bridge ${DOCKER_NETWORK} || true"
                    testLocalImage.withRun("-p ${MAP_PORT}:${MAP_PORT} --network-alias ${DOCKER_NETWORK_ALIAS} --net ${DOCKER_NETWORK} --name ${LAMBDA_FUNCTION}") {c ->
                        // sh 'sleep 5'
                        sh "docker ps"
                        sh """
                        docker exec -i ${LAMBDA_FUNCTION} \
                            curl -l "http://0.0.0.0:${MAP_PORT}/2015-03-31/functions/function/invocations" \
                            -H \"Accept:application/json\" \
                            -d '{"jenkins": "Jenkins test by devops"}'
                        """
                    }
                }
                sh "docker network rm ${DOCKER_NETWORK}"
            }
        }

        stage("Login ECR") {
            when {
                expression { "${BRANCH}" == 'origin/master' }
            }
            steps {
                withAWS(credentials: "${params.jenkins_credential}") {
                    sh """
                        aws ecr get-login-password \
                            --region eu-west-1 \
                            | docker login \
                            --username AWS \
                            --password-stdin https://${params.account_id}.${REGISTRY_ECR_REPO}
                    """
                }
            }
        }

        // Docker registry on github
        //    https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-docker-registry
        // dev:
        //  Push image into docker registry on Github
        stage("PushImageRegistry") {
            when {
                expression { "${BRANCH}" == 'origin/dev' }
            }
            steps {
                script {
                    // set docker registry on github
                    // docker.withRegistry() {
                    //     def myImage = docker.build()
                    //     myImage.push("${VERSION_DEV}")
                    // }

                    // test push docker Image into ECR
                    docker.withRegistry("http://${params.account_id}.${REGISTRY_ECR_REPO}") {
                        def myImage = docker.build("${params.account_id}.${REGISTRY_ECR_REPO}/${params.ecr_repo_name}")
                        myImage.push ("${VERSION}")
                }
            }
        }

        // Prod:
        //  Push image into ECR
        stage("PushImageECR") {
            when {
                expression { "${BRANCH}" == 'origin/master' }
            }
            steps {
                script {
                    docker.withRegistry("http://${params.account_id}.${REGISTRY_ECR_REPO}") {
                        def myImage = docker.build("${params.account_id}.${REGISTRY_ECR_REPO}/${params.ecr_repo_name}")
                        myImage.push ("${VERSION}")
                    }
                }
            }
        }

        // Prod:
        //  Deploy on Lambda
        stage("Deploy") {
            when {
                expression { "${BRANCH}" == 'origin/master' }
            }
            steps {
                withAWS(credentials: "${params.jenkins_credential}") {
                sh """
                aws lambda update-function-code \
                --function-name ${LAMBDA_FUNCTION} \
                --image-uri ${params.account_id}.${REGISTRY_ECR_REPO}/${params.ecr_repo_name}:${VERSION}
                """
                }
            }
        }

    }
}