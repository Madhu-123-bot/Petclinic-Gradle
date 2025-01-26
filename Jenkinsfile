pipeline {
    agent any

    environment {
        GRADLE_HOME = '/usr'  // Update according to your installation path for Gradle
        JAVA_HOME = '/usr/lib/jvm/java-17-openjdk-amd64'  // Set Java Home path correctly
        DOCKER_IMAGE = 'spring-petclinic:latest'  // Update as per your Docker image name
    }

    stages {
        stage('Checkout') {
            steps {
                echo "Checking out code from GitHub..."
                git url: 'https://github.com/Madhu-123-bot/Petclinic-Gradle.git',
                    branch: 'main', 
                    credentialsId: 'github-credentials'  // Replace with your Jenkins credential ID
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
                echo "Building Docker image..."
                sh """
                docker build -t ${DOCKER_IMAGE} .
                """

                echo "Stopping and removing old container (if exists)..."
                sh """
                docker rm -f petclinic-app || true
                """

                echo "Deploying the application..."
                sh """
                docker run -d --name petclinic-app -p 8081:8080 ${DOCKER_IMAGE}
                """
            }
            post {
                always {
                    echo "Docker image built and application deployed."
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
