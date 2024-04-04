pipeline {
    agent any

    environment {
        registryCredential = 'docker-hub-credential'
        dockerImage = 'your-docker-hub-username/your-image-name'
    }

    stages {
        stage('Cloning repository') {
            steps {
                git credentialsId: 'github-credential', url: 'https://github.com/your/repository.git'
            }
        }

        stage('Build Docker image') {
            steps {
                script {
                    docker.build dockerImage, '-f path/to/Dockerfile .'
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
