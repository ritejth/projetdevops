pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'mon-api-nestjs'
        DOCKER_TAG = 'latest'
        DOCKERHUB_USER = 'ritejth'
    }

    stages {
        stage('Checkout') {
            steps {
                echo '📥 Récupération du code source...'
                checkout scm
            }
        }

        stage('Build Image') {
            steps {
                echo '🐳 Construction de l\'image Docker...'
                bat "docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} ."
            }
        }

        stage('Push to DockerHub') {
            steps {
                echo '📤 Poussée de l\'image vers DockerHub...'
                withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', usernameVariable: 'USER', passwordVariable: 'PASSWORD')]) {
                    bat "docker login -u ${USER} -p ${PASSWORD}"
                    bat "docker tag ${DOCKER_IMAGE}:${DOCKER_TAG} ${DOCKERHUB_USER}/${DOCKER_IMAGE}:${DOCKER_TAG}"
                    bat "docker push ${DOCKERHUB_USER}/${DOCKER_IMAGE}:${DOCKER_TAG}"
                }
            }
        }

        stage('Deploy Container') {
            steps {
                echo '🚀 Déploiement du conteneur...'
                bat "docker run -d -p 3000:3000 ${DOCKERHUB_USER}/${DOCKER_IMAGE}:${DOCKER_TAG}"
            }
        }
    }

    post {
        success {
            echo '✅ Déploiement réussi!'
        }
        failure {
            echo '❌ Échec du déploiement.'
        }
    }
}
