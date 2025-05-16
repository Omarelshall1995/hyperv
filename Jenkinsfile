pipeline {
  agent any

  environment {
    NODE2 = '172.19.124.223'
    NODE3 = '172.19.124.224'
    SSH_USER = 'Administrator'
    SSH_PASS = credentials('local-admin-password')  // Jenkins credential ID for Qwaszx12_
    REPO_URL = 'https://github.com/Omarelshall1995/hyperv.git'
  }

  stages {
    stage('Clone Repo') {
      steps {
        git branch: 'main', url: "${REPO_URL}"
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
          \$password = '${SSH_PASS}'
          \$user = '${SSH_USER}'
          \$node = '${NODE2}'
          # Native scp command, assuming scp is available in PATH
          scp -r sql-install \$user@\$node:C:\\Users\\Administrator\\sql-install
        """
      }
    }

    stage('Copy Scripts to Node3') {
      steps {
        powershell """
          \$password = '${SSH_PASS}'
          \$user = '${SSH_USER}'
          \$node = '${NODE3}'
          scp -r sql-install \$user@\$node:C:\\Users\\Administrator\\sql-install
        """
      }
    }

    stage('Run SQL FCI Install on Node3') {
      steps {
        powershell """
          \$password = '${SSH_PASS}'
          \$user = '${SSH_USER}'
          \$node = '${NODE3}'
          ssh \$user@\$node powershell.exe -ExecutionPolicy Bypass -File C:\\Users\\Administrator\\sql-install\\install_fci.ps1
        """
      }
    }

    stage('Add Node to Cluster on Node2') {
      steps {
        powershell """
          \$password = '${SSH_PASS}'
          \$user = '${SSH_USER}'
          \$node = '${NODE2}'
          ssh \$user@\$node powershell.exe -ExecutionPolicy Bypass -File C:\\Users\\Administrator\\sql-install\\add_node.ps1
        """
      }
    }
  }
}
