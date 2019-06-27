 pipeline {
    agent any

    environment {
      REGISTRY='omerha'
      IMAGE='python'
      TAG='3.6.8-lambda'
    }

    stages {
      stage('Pull docker image'){
        steps {
          script {
            sh("sudo docker pull $REGISTRY/$IMAGE:$TAG")
          }
        }
      }

      stage('Build Lambda'){
        steps {
          script {
            sh("sudo docker run -w /mnt -v `pwd`:/mnt $REGISTRY/$IMAGE:$TAG make docker_build")
          }
        }
      }

      stage('Deploy Lambda'){
        steps {
          script {
            sh("sudo docker run -w /mnt -v `pwd`:/mnt $REGISTRY/$IMAGE:$TAG make lambda_update")
          }
        }
      }

    }

    post {
      success {
        cleanWs()
      }
    }
 }