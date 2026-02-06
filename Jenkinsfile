#!/usr/bin/env groovy

library identifier: 'jenkins-shared-library@main', retriever: modernSCM(
   [$class: 'GitSCMSource',
   remote: 'https://github.com/elpek87/twwn-devops-bootcamp-jenkins-shared-library.git',
   credentialsId: 'GitHub-token'])

pipeline {
    agent any
    tools {
        maven 'maven-3.9'
    }
    environment {
        IMAGE_NAME = 'elpek87/demo-app:java-maven-1.0'
    }
    stages {
        stage('build app') {
            steps {
                echo 'building application jar...'
                buildJar()
            }
        }
        stage('build image') {
            steps {
                script {
                    echo 'building the docker image...'
                    buildImage(env.IMAGE_NAME)
                    dockerLogin()
                    dockerPush(env.IMAGE_NAME)
                }
            }
        }
        stage("deploy") {
            steps {
                script {
                    echo 'deploying docker image to EC2...'
                    def dockerComposeCmd = "docker compose -f docker-compose up -d"
                    sshagent(['ec2-server-key']) {
                        sh "scp docker-compose.yml ec2-user@3.75.90.173:/home/ec2-user"
                        sh "ssh -o StrictHostKeyChecking=no ec2-user@3.75.90.173 ${dockerComposeCmd}"
                    }
                }
            }
        }
    }
}
