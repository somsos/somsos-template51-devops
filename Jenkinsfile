pipeline {
    agent any

    stages {
        stage('Note') {
            steps {
                sh '''
                    set -a
                    source .env
                    set +a

                    echo "I AM NOT USING THE Jenkins file"
                    echo "I USING JenkinsScript-build-and-deploy.sh"
                '''
            }
            
        }
    }
}