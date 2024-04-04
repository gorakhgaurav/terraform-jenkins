pipeline {
    agent any

    environment {
        registryCredential = 'docker-hub-credential'
        dockerImage = 'gorakhgaurav/e-commerce'
    }

    stages {
        stage('Cloning repository') {
            steps {
                git credentialsId: 'github-credential', url: 'https://github.com/gorakhgaurav/terraform-jenkins.git'
            }
        }

        stage('Build Docker image') {
            steps {
                script {
                    docker.build dockerImage, '-f .'
                }
            }
        }

        stage('Push Docker image') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', registryCredential) {
                        dockerImage.push()
                    }
                }
            }
        }
    }
}
