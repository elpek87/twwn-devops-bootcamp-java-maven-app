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

    stages {
        stage('increment version') {
            steps {
                script {
                    echo 'incrementing app version...'
                    sh 'mvn build-helper:parse-version versions:set \
                        -DnewVersion=\\\${parsedVersion.majorVersion}.\\\${parsedVersion.minorVersion}.\\\${parsedVersion.nextIncrementalVersion} \
                        versions:commit'
                    def matcher = readFile('pom.xml') =~ '<version>(.+)</version>'
                    def version = matcher[0][1]
                    env.IMAGE_NAME = "elpek87/demo-app:$version-$BUILD_NUMBER"
                }
            }
        }
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

        stage("provision server") {
           environment  {
                AWS_ACCESS_KEY_ID = credentials('jenkins_aws_access_key_id')
                AWS_SECRET_ACCESS_KEY = credentials('jenkins_aws_secret_access_key')
                TF_VAR_env_prefix = "test"
            }
           steps {
            script {
                dir('terraform') {
                    sh "terraform init -reconfigure -input=false"
                    sh "terraform apply --auto-approve"
                    env.EC2_PUBLIC_IP = sh(
                        script: "terraform output ec2_public_ip",
                        returnStdout: true
                    ).trim()
                }
            }
           }
        }

        stage("deploy") {
            environment {
                DOCKER_CREDS = credentials('dockerhub-repo')
            }
            steps {
                script {
                    echo "Waiting for EC2 server to initialize"
                    sleep(time: 90, unit: "SECONDS")

                    echo 'deploying docker image to EC2...'
                    echo "${env.EC2_PUBLIC_IP}"

                    def shellCmd = "bash ./server-cmds.sh ${IMAGE_NAME} ${DOCKER_CREDS_USR} ${DOCKER_CREDS_PSW}"
                    def ec2Instance = "ec2-user@${EC2_PUBLIC_IP}"
                    sshagent(['ec2-server-key']) {
                        sh "scp -o StrictHostKeyChecking=no server-cmds.sh ${ec2Instance}:/home/ec2-user"
                        sh "scp -o StrictHostKeyChecking=no docker-compose.yml ${ec2Instance}:/home/ec2-user"
                        sh "ssh -o StrictHostKeyChecking=no ${ec2Instance} ${shellCmd}"
                    }
                }
            }
        }
        stage('commit version update') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'GitHub-token', passwordVariable: 'PASS', usernameVariable: 'USER')]){
                    sh 'git config user.email "jenkins@example.com"'
                    sh 'git config user.name "Jenkins"'
                    sh "git remote set-url origin https://${USER}:${PASS}@github.com/elpek87/twwn-devops-bootcamp-java-maven-app.git"
                    sh 'git add .'
                    sh 'git commit -m "CI: Version Bump"'
                    sh 'git push origin HEAD:jenkinsfile-sshagent'
                    }
                }
            }
        }
    }
}
