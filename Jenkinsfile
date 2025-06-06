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
        REGISTRY_URL = 'registry-image:5000'
        IMAGE_NAME = 'first-app'
        SONAR_HOST_URL = 'http://sonarqube-ce-image:9000'
        SONAR_TOKEN = credentials('sonar-token')
    }

    stages {
        stage('Pull Code') {
            steps {
                git url: 'https://github.com/kaweel/workshop-cicd-go-2025.git', branch: 'master'
            }
        }

        stage('Build & Test') {
            steps {
                sh """
                    set -e
                    docker rm -f tmp-container || true
                    docker build -t ${IMAGE_NAME}:${params.VERSION} -f Dockerfile .
                    docker create --name tmp-container ${IMAGE_NAME}:${params.VERSION}
                    docker cp tmp-container:/coverage.out coverage.out
                """
            }
        }

        stage('Code Analysis') {
            steps {
                sh """
                    sonar-scanner \
                    -Dsonar.projectKey=${IMAGE_NAME} \
                    -Dsonar.sources=. \
                    -Dsonar.go.coverage.reportPaths=coverage.out \
                    -Dsonar.host.url=${SONAR_HOST_URL} \
                    -Dsonar.login=${SONAR_TOKEN}
                """
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
                sh "echo '=== Deploy ==='"
            }
        }
    }
}
