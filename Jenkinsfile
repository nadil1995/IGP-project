pipeline {
    agent any

    environment {
        DOCKER_USER = 'nadil95'
        IMAGE_NAME  = 'xyzrepo'
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout the Git repository into the Jenkins workspace
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

        stage('Build WAR') {
            steps {
                sh 'mvn package'
            }
        }

        stage('Build Docker Image') {
            steps {
                dir("${WORKSPACE}") {
                    sh 'cp target/XYZtechnologies-1.0.war .'
                    sh "docker build -t ${DOCKER_USER}/${IMAGE_NAME}:${BUILD_NUMBER} ."
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                dir("${WORKSPACE}") {
                    withDockerRegistry([credentialsId: 'docker-hub-cred', url: '']) {
                        sh "docker push ${DOCKER_USER}/${IMAGE_NAME}:${BUILD_NUMBER}"
                    }
                }
            }
        }

        stage('Deploy via Ansible') {
            steps {
                dir("${WORKSPACE}") {
                    // Optional: upgrade ansible and install required collections on the Jenkins node
                            sh '''
                        # Create a virtual environment for Python packages
                        python3 -m venv venv
                        source venv/bin/activate

                        # Upgrade pip inside venv
                        pip install --upgrade pip

                        # Install ansible, docker python library, and collections
                        pip install ansible docker
                        ansible-galaxy collection install community.docker

                        # Run the playbook using the virtualenv python
                        ansible-playbook -i /var/lib/jenkins/ansible/inventory \
                        /var/lib/jenkins/ansible/deploy-docker.yml \
                        --extra-vars "build_number=${BUILD_NUMBER} docker_user=${DOCKER_USER} image_name=${IMAGE_NAME}"
                    '''

          
                }
            }
        }
    }
}
