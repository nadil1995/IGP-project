pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/nadil1995/IGP-project.git'
            }
        }

        stage('Compile') {
            steps {
                sh 'mvn compile'
            }
        }

        stage('Test') {
            steps {
                sh 'mvn test'
            }
        }

        stage('Package') {
            steps {
                sh 'mvn package'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'cp target/XYZtechnologies-1.0.war .'
                sh 'docker build -t xyztechnologies:${BUILD_NUMBER} .'
                sh 'docker tag xyztechnologies:${BUILD_NUMBER} nadil95/xyztechnologies:${BUILD_NUMBER}'
            }
        }

        stage('Push Docker Image') {
            steps {
                withDockerRegistry([credentialsId: "mydockerhubcred", url: ""]) {
                    sh 'docker push nadil95/xyztechnologies:${BUILD_NUMBER}'
                }
            }
        }

        stage('Deploy Container') {
            steps {
                sh 'docker stop abcapp || true'
                sh 'docker rm abcapp || true'
                sh 'docker run -d --name abcapp -p 8081:8080 nadil95/xyztechnologies:${BUILD_NUMBER}'
            }
        }
    }

    
            stage('Deploy to Kubernetes') {
    steps {
        sh 'export KUBECONFIG=/var/lib/jenkins/kubeconfig'
        sh 'sed -i "s|latest|${BUILD_NUMBER}|g" deployment.yaml'
        sh 'kubectl apply -f deployment.yaml'
        sh 'kubectl apply -f service.yaml'
        sh 'kubectl get pods'
        sh 'kubectl get services'
    }
}
          

    post {
        always {
            archiveArtifacts artifacts: '**/target/*.war', fingerprint: true
        }
    }
}
