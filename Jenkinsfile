pipeline {
  agent any
  environment {
    ANSIBLE_SERVER = "138.68.94.71"
  }
  stages {
    stage("copy files to ansible server") {
      steps {
        script {
          echo "copying all neccessary files to ansible control node"
          sshagent(['ansible-server-key']) {
            sh "scp -o StrictHostKeyChecking=no ansible/* root@$192.168.0.78:/root"

            withCredentials([sshUserPrivateKey(credentialsId: 'ec2-server-key', keyFileVariable: 'keyfile', usernameVariable: 'user')]) {
              sh 'scp $keyfile root@$192.168.0.78:/root/ssh-key.pem'
            }
          }
        }
      }
    }
