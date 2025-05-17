pipeline {
  agent any
  environment {
    NODE2_IP = '172.19.124.223'
    NODE3_IP = '172.19.124.224'
    SSH_USER = 'administrator'
    SSH_PASS = credentials('ssh-password-id')  // Jenkins credentials ID for the password
  }
  stages {
    stage('Checkout') {
      steps {
        git url: 'https://github.com/Omarelshall1995/hyperv.git', branch: 'main'
      }
    }
    stage('Copy Scripts to Node2') {
      steps {
        sh """
          sshpass -p '${SSH_PASS}' scp -o StrictHostKeyChecking=no ./scripts/* ${SSH_USER}@${NODE2_IP}:/C:/Scripts/
        """
      }
    }
    stage('Copy Scripts to Node3') {
      steps {
        sh """
          sshpass -p '${SSH_PASS}' scp -o StrictHostKeyChecking=no ./scripts/* ${SSH_USER}@${NODE3_IP}:/C:/Scripts/
        """
      }
    }
    stage('Run SQL FCI Install on Node3') {
      steps {
        sh """
          sshpass -p '${SSH_PASS}' ssh -o StrictHostKeyChecking=no ${SSH_USER}@${NODE3_IP} powershell.exe -File C:/Scripts/install-sql-fci.ps1
        """
      }
    }
    stage('Add Node to Cluster on Node2') {
      steps {
        sh """
          sshpass -p '${SSH_PASS}' ssh -o StrictHostKeyChecking=no ${SSH_USER}@${NODE2_IP} powershell.exe -File C:/Scripts/add-node.ps1
        """
      }
    }
  }
}
