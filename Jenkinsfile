pipeline {
  agent any

  environment {
    NODE2 = '172.19.124.223'
    NODE3 = '172.19.124.224'
    SSH_USER = 'Administrator'
    SSH_PASS = credentials('local-admin-password')  // your password stored in Jenkins creds
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

    stage('Copy Scripts to Nodes') {
      steps {
        powershell """
          \$password = ConvertTo-SecureString '${SSH_PASS}' -AsPlainText -Force
          \$cred = New-Object System.Management.Automation.PSCredential ('${SSH_USER}', \$password)

          # Copy sql-install to Node2
          Invoke-Command -ComputerName ${NODE2} -Credential \$cred -ScriptBlock {
            param(\$source)
            if (-Not (Test-Path -Path \$source)) { New-Item -ItemType Directory -Path \$source -Force }
            Copy-Item -Path 'C:\\jenkins\\workspace\\pipeline script from scm\\sql-install\\*' -Destination \$source -Recurse -Force
          } -ArgumentList 'C:\\Users\\Administrator\\sql-install'

          # Copy sql-install to Node3
          Invoke-Command -ComputerName ${NODE3} -Credential \$cred -ScriptBlock {
            param(\$source)
            if (-Not (Test-Path -Path \$source)) { New-Item -ItemType Directory -Path \$source -Force }
            Copy-Item -Path 'C:\\jenkins\\workspace\\pipeline script from scm\\sql-install\\*' -Destination \$source -Recurse -Force
          } -ArgumentList 'C:\\Users\\Administrator\\sql-install'
        """
      }
    }

    stage('Run SQL FCI Install on Node3') {
      steps {
        powershell """
          \$password = ConvertTo-SecureString '${SSH_PASS}' -AsPlainText -Force
          \$cred = New-Object System.Management.Automation.PSCredential ('${SSH_USER}', \$password)
          Invoke-Command -ComputerName ${NODE3} -Credential \$cred -ScriptBlock {
            powershell.exe -ExecutionPolicy Bypass -File 'C:\\Users\\Administrator\\sql-install\\install_fci.ps1'
          }
        """
      }
    }

    stage('Add Node to Cluster on Node2') {
      steps {
        powershell """
          \$password = ConvertTo-SecureString '${SSH_PASS}' -AsPlainText -Force
          \$cred = New-Object System.Management.Automation.PSCredential ('${SSH_USER}', \$password)
          Invoke-Command -ComputerName ${NODE2} -Credential \$cred -ScriptBlock {
            powershell.exe -ExecutionPolicy Bypass -File 'C:\\Users\\Administrator\\sql-install\\add_node.ps1'
          }
        """
      }
    }
  }
}
