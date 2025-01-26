pipeline {
    agent any

    environment {
        GRADLE_HOME = '/usr'
        JAVA_HOME = '/usr/lib/jvm/java-17-openjdk-amd64'
        DOCKER_IMAGE = 'spring-petclinic:latest'
        CONTAINER_NAME = 'petclinic-app'
    }

    triggers {
        githubPush()
    }

    stages {
        stage('Checkout') {
            steps {
                echo "Checking out code from GitHub..."
                git url: 'https://github.com/Madhu-123-bot/Petclinic-Gradle.git',
                    branch: 'main', 
                    credentialsId: 'github-credentials'
            }
        }

        stage('Build') {
            steps {
                echo "Building the application with Gradle (skipping tests)..."
                sh './gradlew clean build -x test'
            }
        }

        stage('Dockerize & Deploy') {
            steps {
                echo "Stopping the existing container (if running)..."
                sh """
                docker stop ${CONTAINER_NAME} || true
                """

                echo "Removing the old container (if exists)..."
                sh """
                docker rm -f ${CONTAINER_NAME} || true
                """

                echo "Removing the old image (if exists)..."
                sh """
                docker rmi ${DOCKER_IMAGE} || true
                """

                echo "Building the new Docker image..."
                sh """
                docker build -t ${DOCKER_IMAGE} .
                """

                echo "Running the new container..."
                sh """
                docker run -d --name ${CONTAINER_NAME} -p 8081:8080 ${DOCKER_IMAGE}
                """
            }
            post {
                always {
                    echo "Docker image built and new container deployed."
                }
            }
        }
    }

    post {
        success {
            echo "Pipeline executed successfully! The application is deployed."
        }
        failure {
            echo "Pipeline failed. Please check the logs for errors."
        }
    }
}
