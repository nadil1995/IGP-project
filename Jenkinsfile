pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/nadil1995/IGP-project.git'
            }
        }

        stage('Compile & Test & Package') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('Build & Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('', 'mydockerhubcred') {
                        sh 'cp target/XYZtechnologies-1.0.war ROOT.war'
                        sh 'docker build -t nadil95/xyztechnologies:${BUILD_NUMBER} .'
                        sh 'docker tag nadil95/xyztechnologies:${BUILD_NUMBER} nadil95/xyztechnologies:latest'
                        sh 'docker push nadil95/xyztechnologies:${BUILD_NUMBER}'
                        sh 'docker push nadil95/xyztechnologies:latest'
                    }
                }
            }
        }

        stage('Deploy Container') {
            steps {
                sh '''
                  docker stop abcapp || true
                  docker rm abcapp || true
                  docker run -d --restart unless-stopped --name abcapp -p 8081:8080 nadil95/xyztechnologies:${BUILD_NUMBER}
                '''
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh 'kubectl apply -f k8s/deployment.yaml'
                sh 'kubectl apply -f k8s/service.yaml'
                sh 'kubectl get pods'
                sh 'kubectl get svc'
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: '**/target/*.war', fingerprint: true
        }
    }
}
