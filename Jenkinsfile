pipeline {
  agent any

  environment {
    NODE2 = '172.19.124.223'
    NODE3 = '172.19.124.224'
    SSH_USER = 'lab\\administrator'
    SSH_PASS = credentials('lab-administrator-password')
  }

  stages {
    stage('Clone Repo') {
      steps {
        git branch: 'main', url: 'https://github.com/Omarelshall1995/hyperv.git'
      }
    }

    stage('Terraform Init & Apply') {
      steps {
        dir('C:/hyperv-sql-cluster') {
          powershell 'terraform init'
          powershell 'terraform apply -auto-approve'
        }
      }
    }

    stage('Copy Scripts to Node2') {
      steps {
        powershell """
          sshpass -p ${env.SSH_PASS} scp -o StrictHostKeyChecking=no -r sql-install ${env.SSH_USER}@${env.NODE2}:C:\\Users\\Administrator\\
        """
      }
    }

    stage('Copy Scripts to Node3') {
      steps {
        powershell """
          sshpass -p ${env.SSH_PASS} scp -o StrictHostKeyChecking=no -r sql-install ${env.SSH_USER}@${env.NODE3}:C:\\Users\\Administrator\\
        """
      }
    }

    stage('Run SQL FCI Install on Node3') {
      steps {
        powershell """
          sshpass -p ${env.SSH_PASS} ssh -o StrictHostKeyChecking=no ${env.SSH_USER}@${env.NODE3} powershell.exe -ExecutionPolicy Bypass -File C:\\Users\\Administrator\\sql-install\\install_fci.ps1
        """
      }
    }

    stage('Add Node to Cluster on Node2') {
      steps {
        powershell """
          sshpass -p ${env.SSH_PASS} ssh -o StrictHostKeyChecking=no ${env.SSH_USER}@${env.NODE2} powershell.exe -ExecutionPolicy Bypass -File C:\\Users\\Administrator\\sql-install\\add_node.ps1
        """
      }
    }
  }
}
