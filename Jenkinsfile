/*
see https://www.jenkins.io/doc/book/pipeline/jenkinsfile/#creating-a-jenkinsfile
    https://jenkins.io/doc/book/pipeline/syntax/
*/

// define variables
def variable_example = "def var jenkins pipeline"

pipeline {
    agent any

    environment {
        BRANCH = "${env.GIT_BRANCH}"
        DOCKER_NETWORK = "lambda_net"
        DOCKER_NETWORK_ALIAS = 'lambda'

        LAMBDA_FUNCTION = "devops-lambda-pipeline"
        TEST_BUILD_IMAGE = "devops_lambda/test"
        TEST_LOCAL_IMAGE = ""
        
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

        stage("Verify") {
            steps {
                echo "${testLocalImage}"
            }
        }

        // stage("Test") {
        //     steps {
        //         script {
        //             sh "docker network create --driver bridge ${DOCKER_NETWORK} || true"
        //             "${TEST_LOCAL_IMAGE}".withRun("-p 8080:8080 --network-alias ${DOCKER_NETWORK_ALIAS} --net ${DOCKER_NETWORK} --name lambda_test") {c ->
        //                 sh 'sleep 5'
        //                 sh 'docker ps'
        //                 sh """
        //                 docker exec -i lambda_test \
        //                     curl -l "http://0.0.0.0:8080/2015-03-31/functions/function/invocations" \
        //                     -H \"Accept:application/json\" \
        //                     -d '{"jenkins": "Jenkins test by devops"}'
        //                 """
        //             }
        //         }
        //         sh "docker network rm ${DOCKER_NETWORK}"
        //     }
        // }

        // run aws-cli by "withAWS" plugin
        // stage("Connect AWS") {
        //     steps {
        //         withAWS(credentials: 'ae9f2475-e03d-463e-8f98-dc8ff7e0b44f') {
        //             sh 'aws s3 ls'
        //         }
        //     }
        // }

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