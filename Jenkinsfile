pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = 'mydockerhubcred'
        DOCKER_IMAGE = 'nadil95/xyztechnologies'
    }

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
                script {
                   kubeconfig(caCertificate: 'LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURCakNDQWU2Z0F3SUJBZ0lCQVRBTkJna3Foa2lHOXcwQkFRc0ZBREFWTVJNd0VRWURWUVFERXdwdGFXNXAKYTNWaVpVTkJNQjRYRFRJMU1Ea3lNREU1TWpVek1sb1hEVE0xTURreE9URTVNalV6TWxvd0ZURVRNQkVHQTFVRQpBeE1LYldsdWFXdDFZbVZEUVRDQ0FTSXdEUVlKS29aSWh2Y05BUUVCQlFBRGdnRVBBRENDQVFvQ2dnRUJBSzQ4Cm5FODNYenk1ck5TdUV5eHprYmY0a2kranFUZng0YnFUSDR4ZU05S055dmJsVXNicFFnRThpaVVZTEdVUWNWOFQKeFc1TVpnSmNkRlBUTXVXSVhEOEpMN1l2OXpDeEpacDFNWUUrRGNRcXJWOXNlZU9YN1FGazNpTERhWUVPcE5kZQpiQzAvNElOMnovMW9JNmF0RGd1bDI5OXBrVHZoVllQSTBMeVVKOFJBM0VFbklRUEhVUmRTUWdMY1c5dXYxZWJVCkJoK3g2YWZuQUZPYUtsdzdyWGZQUzBkakYva2lyT0JjUlJQY1RaVGNRTlFFbnB5VjA4RzVUY1E3WmRNUHc1V3YKTlNLT0tvN3FXZUIyTm5TVWtFdkVlcXpCWGFCN3RaeWZKanE0aXlWQW5ORDM0QWUxWmdJUVdFQUVGWWVsc1VQbApab1VxY2UwMjdYaGhuSnZPTmswQ0F3RUFBYU5oTUY4d0RnWURWUjBQQVFIL0JBUURBZ0trTUIwR0ExVWRKUVFXCk1CUUdDQ3NHQVFVRkJ3TUNCZ2dyQmdFRkJRY0RBVEFQQmdOVkhSTUJBZjhFQlRBREFRSC9NQjBHQTFVZERnUVcKQkJSUGVhVjVxeThvMFZaMmJpWHF6TFRaTWJWUnR6QU5CZ2txaGtpRzl3MEJBUXNGQUFPQ0FRRUFQbnFnWFY1YgpOUUlWT08zYjdER00xR3BiUVlHYnA3Rzkvd2VWWVNNVE5CaEpEUnEyemNIblJmaTVxNmRIYzVBWFVkcGVBWktjCjNXUmNhRUsrZGM0NG5zMllGY3cxTGg2R29KN3lpRXNEQ2JnMzJvRmdDcnFLTHc0OWUrenIxRi9YVlV3aWdSS1MKdkg1R3hwbUNMc0Zjb1ZYVHI4VHZvME5Hbzc5R3RaM0taMDFUVklDNU43VWxpYWw2cHVCOE9CN2NsM1VVNXk0MQppT3A4MlNhQkNnck5CK2EweGFFUUJtZEM3MFJ1bUhHVkpuVUMxU0I3OW51azc5UFVOcUpDbGgwVnI4UlJRTDhhCkQ3WVpEL3R3Tk1RUm5zNFNhTDBJUnFhdVh0YldDYk1ZNTdlMXhqTWVRdXI1NFVadXlmT1hnNTZjNmo3VCtycUwKUVpCV0I1aTBvd3c2Qmc9PQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg==', credentialsId: 'kubeconfig1', serverUrl: 'https://192.168.49.2:8443') {
    // some block
}
                }
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
