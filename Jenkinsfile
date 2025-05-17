pipeline {
  agent any

  environment {
    NODE2_IP = '172.19.124.223'
    NODE3_IP = '172.19.124.224'
    SSH_USER = 'administrator'
    SSH_PASS = credentials('ssh-password-id')  // Make sure this is secret text
  }

  stages {
    stage('Checkout') {
      steps {
        git url: 'https://github.com/Omarelshall1995/hyperv.git', branch: 'main'
      }
    }

    stage('Copy Scripts to Node2') {
      steps {
        bat """
        pscp.exe -pw %SSH_PASS% sql-install\\* %SSH_USER%@%NODE2_IP%:C:\\Scripts\\
        """
      }
    }

    stage('Copy Scripts to Node3') {
      steps {
        bat """
        pscp.exe -pw %SSH_PASS% sql-install\\* %SSH_USER%@%NODE3_IP%:C:\\Scripts\\
        """
      }
    }

    stage('Run SQL FCI Install on Node3') {
      steps {
        bat """
        plink.exe -pw %SSH_PASS% %SSH_USER%@%NODE3_IP% powershell -ExecutionPolicy Bypass -File C:\\Scripts\\install_fci.ps1
        """
      }
    }

    stage('Add Node to Cluster on Node2') {
      steps {
        bat """
        plink.exe -pw %SSH_PASS% %SSH_USER%@%NODE2_IP% powershell -ExecutionPolicy Bypass -File C:\\Scripts\\add_node.ps1
        """
      }
    }
  }
}
