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
                git url: 'https://github.com/Madhu-123-bot/Petclinic-Gradle.git', 
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
                catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
                    sh './gradlew test'
                }
            }
            post {
                always {
                    junit '**/build/test-classes/test/*.xml'  // Adjust according to your test report location
                }
                failure {
                    echo "Tests failed. Please check the test results for details."
                }
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
                
                echo "Deploying application with Docker..."
                sh """
                docker run -d --name petclinic-app -p 8081:8080 ${DOCKER_IMAGE}
                """
            }
            post {
                always {
                    echo "Dockerize & Deploy stage completed."
                }
            }
        }
    }

    post {
        success {
            echo "Pipeline executed successfully! Application deployed."
        }
        failure {
            echo "Pipeline failed! Please check the logs for details."
        }
    }
}
