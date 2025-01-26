pipeline {
    agent any

    environment {
        MAVEN_HOME = '/usr/share/maven'  // Adjust according to your Maven installation path
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
                echo "Building the application with Maven..."
                sh 'mvn clean package -DskipTests'  // Build without running tests (you can remove '-DskipTests' if you want to run tests during build)
            }
        }

        stage('Test') {
            steps {
                echo "Running tests with Maven..."
                script {
                    catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
                        def testResult = sh(script: 'mvn test', returnStatus: true)
                        if (testResult != 0) {
                            echo "Tests failed, but continuing with the pipeline."
                        } else {
                            echo "Tests passed!"
                        }
                    }
                }
            }
            post {
                always {
                    echo "Test results have been logged."
                    junit '**/target/test-classes/test/*.xml'  // Adjust this path if needed, based on your Maven project structure
                }
                failure {
                    echo "Tests failed. Please check the test results."
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
