pipeline {
    agent any
    tools {
        maven 'maven-3.9'
    }

    stages {
        stage("build jar") {
            steps {
                script {
                    dir('demo-projects/module-8/java-maven-app') {
                    echo "building the application..."
                    sh 'mvn package'
                    }
                }
            }
        }

        stage("build image") {
            steps {
                script {
                    echo "building the docker image..."
                    withCredentials([usernamePassword(credentialsId: 'dockerhub-repo', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
                        dir('demo-projects/module-8/java-maven-app') {
                        sh 'docker build -t demo-app:2.0 .'
                        sh 'echo $PASS | docker login -u $USER --password-stdin'
                        sh 'docker push elpek87/demo-app:jma-2.0'
                    }
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
