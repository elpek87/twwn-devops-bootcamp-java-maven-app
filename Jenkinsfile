pipeline {   
    agent any
    tools {
        maven 'maven-3.9'
    }

    stages {
        stage("build jar") {
            steps {
                script {
                    echo "building the application..."
                    dir('demo-projects/module-8/java-maven-app') {
                    sh 'mvn package'
                    }
                }
            }
        }

        stage("build image") {
            steps {
                script {
                    echo "building the docker image..."
                    withCredentials([usernamePassword(credentialsId: 'docker-hub-repo', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
                        sh 'cd demo-projects/module-8/java-maven-app'
                        sh 'docker build -t java-maven-app:2.0 .'
                        sh 'echo $PASS | docker login -u $USER --password-stdin'
                        sh 'docker push elpek87/demo-app:jma-2.0'
                    }
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
