pipeline {
    agent any

    parameters {
        string(name: "account_id", description: "AWS accountID")
        string(name: "jenkins_credential", description: "Jenkins Credential")
        string(name: "ecr_repo_name", description: "ECR Repo name")
        string(name: "dockerhub_credential", description: "DockerHub Credential")
    }

    stages {

        // docker run -p 3306:3306 --name mysql_80 -e MYSQL_ROOT_PASSWORD=password -d mysql:8 mysqld --default-authentication-plugin=mysql_native_password
        stage("running image") {
            steps {
                script {
                    docker.image('mysql:latest').run('-p 3306:3306 -e "MYSQL_ROOT_PASSWORD=root"', '--default-authentication-plugin=mysql_native_password') {c ->
                    // docker.image('mysql:latest').run('-p 3306:3306 -e "MYSQL_ROOT_PASSWORD=root"', '--default-authentication-plugin=mysql_native_password') {c ->
                        sh 'docker ps -a'
                    }
                }
            }
        }

    }
}