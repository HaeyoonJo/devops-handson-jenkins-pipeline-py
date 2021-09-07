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
        ENV_VARIABLE_EXAMPLE = "env var in jenkins pipeline"
    }

    stages {

        stage("Build") {
            steps { echo 'Building..' }
        }

        // run aws-cli by "withAWS" plugin
        stage("Connect AWS") {
            steps {
                withAWS(credentials: 'ae9f2475-e03d-463e-8f98-dc8ff7e0b44f') {
                    sh 'aws s3 ls'
                }
            }
        }

        // see branch strategy by visiting https://www.jenkins.io/doc/tutorials/build-a-multibranch-pipeline-project/#add-deliver-and-deploy-stages-to-your-pipeline
        // https://www.jenkins.io/blog/2017/01/19/converting-conditional-to-pipeline/
        stage("Deploy Dev") {
            when {
                expression { "${BRANCH}" == 'origin/dev' }
            }
            steps {
                echo "check variables >> \n variable_example: ${variable_example}, \n ENV_VARIABLE_EXAMPLE: ${ENV_VARIABLE_EXAMPLE}"
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