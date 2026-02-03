def gv

pipeline {
    agent any
    tools {
        maven 'maven-3.9'
    }
    stages {
        stage('increment version') {
            steps {
                script {
                    echo 'incrementing app version ...'
                    sh 'mvn build-helper:parse-version versions:set \
                        -DnewVersion=\\\${parsedVersion.majorVersion}.\\\${parsedVersion.minorVersion}.\\\${parsedVersion.nextIncrementalVersion} \
                        versions:commit'
                    def matcher = readFile('pom.xml') =~ '<version>(.+)</version>' // matches version from pom.xml
                    def version = matcher[0][1] // we need two first elements of version
                    env.IMAGE_NAME = "$version-$BUILD_NUMBER"
                }
            }
        }
        stage('build app') {
            steps {
                script {
                    echo 'building the application...'
                    sh 'mvn clean package' // clean deletes target folder before building the app
                }
            }
        }
        stage('build image') {
            steps {
                script {
                    echo "building the docker image..."
                    withCredentials([usernamePassword(credentialsId: 'dockerhub-repo', passwordVariable: 'PASS', usernameVariable: 'USER')]){
                        sh "docker build -t elpek87/demo-app:${IMAGE_NAME} ."
                        sh 'echo $PASS | docker login -u $USER --password-stdin'
                        sh "docker push elpek87/demo-app:${IMAGE_NAME}"
                    }
                }
            }
        }
        stage('deploy') {
            steps {
                script {
                    echo 'deploying docker image...'
                }
            }
        }

        stage('commit version update') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'github-repository', passwordVariable: 'PASS', usernameVariable: 'USER')]){
                    sh 'git config user.email "jenkins@example.com"'
                    sh 'git config user.name "Jenkins"'

                    sh 'git status'
                    sh 'git branch'
                    sh 'git config --list'

                    sh "git remote set-url origin https://${USER}:${PASS}@github.com/elpek87/twwn-devops-bootcamp-java-maven-app.git"
                    sh 'git add .'
                    sh 'git commit -m "CI: Version Bump"'
                    sh 'git push origin HEAD:jenkins-jobs'
                    }
                }
            }
        }
   }
}
