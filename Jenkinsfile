/*
see https://www.jenkins.io/doc/book/pipeline/jenkinsfile/#creating-a-jenkinsfile
    https://jenkins.io/doc/book/pipeline/syntax/
*/
pipeline {
    agent any

    environment {
        BRANCH = "${env.GIT_BRANCH}"
        DOCKER_NETWORK = "lambda_net"
        DOCKER_NETWORK_ALIAS = 'lambda'
        LAMBDA_FUNCTION = "devops-lambda-pipeline"
        TEST_BUILD_IMAGE = "devops_lambda/test"
        TEST_LOCAL_IMAGE = ""
        MAP_PORT = 8080
    }

    stages {

        stage("Build") {
            steps {
                script {
                    testLocalImage = docker.build("${TEST_BUILD_IMAGE}:0.1")
                    sh 'docker images'
                }
            }
        }

        /*
            1. sh 'sleep SECOND': 
                use sleep when docker container launching takes too long
            
            2. Docker container connection refused
                check the issue by visiting https://github.com/HaeyoonJo/devops-handson-jenkins-pipeline-py/issues/1#issue-991363016
        */
        stage("Test") {
            steps {
                script {
                    sh "docker network create --driver bridge ${DOCKER_NETWORK} || true"
                    testLocalImage.withRun("-p ${MAP_PORT}:${MAP_PORT} --network-alias ${DOCKER_NETWORK_ALIAS} --net ${DOCKER_NETWORK} --name ${LAMBDA_FUNCTION}") {c ->
                        // sh 'sleep 5' 
                        sh 'docker ps'
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

        // see branch strategy by visiting https://www.jenkins.io/doc/tutorials/build-a-multibranch-pipeline-project/#add-deliver-and-deploy-stages-to-your-pipeline
        // https://www.jenkins.io/blog/2017/01/19/converting-conditional-to-pipeline/
        stage("Deploy Dev") {
            when {
                expression { "${BRANCH}" == 'origin/dev' }
            }
            steps {
                echo "check variables >> \n variable_example: ${variable_example}"
                retry(3) {
                    echo 'Deploying into dev..'
                }
            }
        }

        stage("Deploy Prod") {
            when {
                expression { "${BRANCH}" == 'origin/master' }
            }
            steps {
                retry(3) {
                    // sh './deploy/deployment_prod.sh'
                    echo 'Deploying into prod..'
                }
            }
        }
    }
}