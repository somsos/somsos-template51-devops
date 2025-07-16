pipeline {
    agent any

    stages {
        stage('1. Build back') {
            steps {
                sh '''
                    set -a
                    source .env
                    set +a

                    echo "Building $NAME_BACK:$VERSION"

                    #docker compose build back

                    #docker compose build front
                '''
            }
            
        }
        stage('1. Build back') {
            steps {
                sh '''
                    set -a
                    source .env
                    set +a

                    cd ./frontDep

                    echo "Building $NAME_FRONT:$VERSION"

                    #docker compose build --tag $NAME_BACK:$VERSION
                '''
            }
            
        }
    }
}