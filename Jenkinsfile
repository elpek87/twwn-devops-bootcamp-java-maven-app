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
        stage("init") {
            steps {
                script {
                    gv = load "script.groovy"
                }
            }
        }

        stage("build jar") {
            steps {
                script {
                    buildJar()
                    }
                }
            }

        stage("build image") {
            steps {
                script {
                    buildImage 'elpek87/demo-app:jma-3.0'
		    dockerLogin()
		    dockerPush 'elpek87/demo-app:jma-3.0'
                    }
                }
            }

        stage("deploy") {
            steps {
                script {
                    gv.deployApp()
                }
            }
        }
    }
}

