pipeline {
    agent { label 'docker-agent' }

    parameters {
        string(
            name: 'VERSION', 
            defaultValue: '0.0.0', 
            description: '''Given a version number MAJOR.MINOR.PATCH, increment the:
                        - MAJOR version when you make incompatible API changes
                        - MINOR version when you add functionality in a backward compatible manner
                        - PATCH version when you make backward compatible bug fixes
                        Additional labels for pre-release and build metadata are available as extensions to the MAJOR.MINOR.PATCH format.'''
        )
    }

    environment {
        REGISTRY_URL = 'localhost:5000'
        IMAGE_NAME = 'first-app'
    }

    stages {
        stage('Pull Code') {
            steps {
                git url: 'https://github.com/kaweel/workshop-cicd-go-2025.git', branch: 'master'
            }
        }

        stage('Build & Test') {
            steps {
                sh "docker build -t ${IMAGE_NAME}:${params.VERSION} -f Dockerfile ."
            }
        }

        stage('Tag Image') {
            steps {
                sh "docker tag ${IMAGE_NAME}:${params.VERSION} ${REGISTRY_URL}/${IMAGE_NAME}:${params.VERSION}"
            }
        }

        stage('Upload Image') {
            steps {
                sh "docker push ${REGISTRY_URL}/${IMAGE_NAME}:${params.VERSION}"
            }
        }

        stage('Deploy') {
            steps {
                sh '=== Deploy ==='
            }
        }
    }
}
