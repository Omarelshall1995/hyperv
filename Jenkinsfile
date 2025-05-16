pipeline {
  agent any

  environment {
    NODE2 = '172.19.124.223'
    NODE3 = '172.19.124.224'
    SSH_USER = 'lab\\administrator'  // Windows style user, adjust if needed
  }

  stages {
    stage('Clone Repo') {
      steps {
        git branch: 'main', url: 'https://github.com/Omarelshall1995/hyperv.git'
      }
    }

    stage('Terraform Init') {
      steps {
        dir('C:/hyperv-sql-cluster') {
          powershell 'terraform init'
        }
      }
    }

    stage('Copy Scripts to Node2') {
      steps {
        powershell """
          scp -o StrictHostKeyChecking=no -r sql-install ${env.SSH_USER}@${env.NODE2}:C:\\Users\\Administrator\\
        """
      }
    }

    stage('Copy Scripts to Node3') {
      steps {
        powershell """
          scp -o StrictHostKeyChecking=no -r sql-install ${env.SSH_USER}@${env.NODE3}:C:\\Users\\Administrator\\
        """
      }
    }

    stage('Run SQL FCI Install on Node3') {
      steps {
        powershell """
          ssh -o StrictHostKeyChecking=no ${env.SSH_USER}@${env.NODE3} powershell.exe -ExecutionPolicy Bypass -File C:\\Users\\Administrator\\sql-install\\install_fci.ps1
        """
      }
    }

    stage('Add Node to Cluster on Node2') {
      steps {
        powershell """
          ssh -o StrictHostKeyChecking=no ${env.SSH_USER}@${env.NODE2} powershell.exe -ExecutionPolicy Bypass -File C:\\Users\\Administrator\\sql-install\\add_node.ps1
        """
      }
    }
  }
}
