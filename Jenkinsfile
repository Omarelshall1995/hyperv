pipeline {
  agent any
  environment {
    NODE2_IP = '172.19.124.223'
    NODE3_IP = '172.19.124.224'
    SSH_USER = 'administrator'
    SSH_PASS = credentials('ssh-password-id') // Your Jenkins secret text credential
  }
  stages {
    stage('Run SQL FCI Install on Node3') {
      steps {
        bat """
        plink.exe -pw %SSH_PASS% %SSH_USER%@%NODE3_IP% powershell -ExecutionPolicy Bypass -Command "C:\\Scripts\\install_fci.ps1"
        """
      }
    }
    stage('Add Node to Cluster on Node2') {
      steps {
        bat """
        plink.exe -pw %SSH_PASS% %SSH_USER%@%NODE2_IP% powershell -ExecutionPolicy Bypass -Command "C:\\Scripts\\add_node.ps1"
        """
      }
    }
  }
}
