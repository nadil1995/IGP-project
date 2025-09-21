pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = 'mydockerhubcred'   // Jenkins credentials ID
        DOCKER_IMAGE = 'nadil95/xyztechnologies'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/nadil1995/IGP-project.git'
            }
        }

        stage('Compile, Test & Package') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Build & Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('', DOCKERHUB_CREDENTIALS) {
                        sh '''
                          WAR_FILE=$(ls target/*.war | head -n 1)
                          cp "$WAR_FILE" ROOT.war
                          docker build -t ${DOCKER_IMAGE}:${BUILD_NUMBER} .
                          docker tag ${DOCKER_IMAGE}:${BUILD_NUMBER} ${DOCKER_IMAGE}:latest
                          docker push ${DOCKER_IMAGE}:${BUILD_NUMBER}
                          docker push ${DOCKER_IMAGE}:latest
                        '''
                    }
                }
            }
        }

        stage('Deploy Container') {
            steps {
                sh '''
                  docker stop abcapp || true
                  docker rm abcapp || true
                  docker run -d --restart unless-stopped --name abcapp -p 8081:8080 ${DOCKER_IMAGE}:${BUILD_NUMBER}
                '''
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh '''
                  kubectl apply -f k8s/deployment.yaml
                  kubectl apply -f k8s/service.yaml
                  kubectl get pods
                  kubectl get svc
                '''
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: '**/target/*.war', fingerprint: true
        }
        success {
            echo "✅ Build #${BUILD_NUMBER} succeeded and deployed."
        }
        failure {
            echo "❌ Build #${BUILD_NUMBER} failed."
        }
    }
}
