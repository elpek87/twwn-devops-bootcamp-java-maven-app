#!/usr/bin/env groovy

pipeline {
    agent any
    stages {
        stage('build app') {
            steps {
               script {
                   echo "building the application..."
               }
            }
        }
        stage('build image') {
            steps {
                script {
                    echo "building the docker image..."
                }
            }
        }
        stage('deploy') {
            steps {
                script {
                   echo 'deploying docker image...'
		   withKubeConfig([credentialsId: 'lke-credentials', serverUrl:'https://xxx.linodelke.net']) {
                   sh 'kubectl create deployment nginx-deployment --image=nginx'
		  }
                }
            }
        }
    }
}
