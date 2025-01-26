pipeline {
    agent any

    environment {
        GRADLE_HOME = '/usr'    // Gradle installation path
        JAVA_HOME = '/usr/lib/jvm/java-17-openjdk-amd64'   // Java installation path
        DOCKER_IMAGE = 'spring-petclinic:latest' // Docker image name
    }

    stages {
        stage('Checkout') {
            steps {
                echo "Checking out code from GitHub..."
                git url: 'https://github.com/Madhu-123-bot/spring-petclinic-new.git', 
                    branch: 'main', 
                    credentialsId: 'github-credentials'  // Replace with your Jenkins credential ID
            }
        }

        stage('Build') {
            steps {
                echo "Building the application with Gradle..."
                sh './gradlew clean build'
            }
        }

        stage('Test') {
            steps {
                echo "Running tests..."
                sh './gradlew test'
            }
        }

        stage('Dockerize & Deploy') {
            steps {
                script {
                    echo "Building Docker image..."
                    sh """
                    docker build -t ${DOCKER_IMAGE} .
                    """
                    
                    echo "Stopping and removing old container (if exists)..."
                    sh """
                    docker rm -f petclinic-app || true
                    """
                    
                    echo "Deploying application with Docker..."
                    sh """
                    docker run -d --name petclinic-app -p 8080:80 ${DOCKER_IMAGE}
                    """
                }
            }
        }
    }

    post {
        success {
            echo "Pipeline executed successfully! Application deployed."
        }
        failure {
            echo "Pipeline failed! Please check the logs."
        }
    }
}
