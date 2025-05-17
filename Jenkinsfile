pipeline {
  agent any
  environment {
    NODE2_IP = '172.19.124.223'
    NODE3_IP = '172.19.124.224'
    SSH_USER = 'Administrator'
    SSH_PASS = credentials('ssh-password-id') // your Jenkins password credential ID
  }
  stages {
    stage('Checkout') {
      steps {
        git url: 'https://github.com/Omarelshall1995/hyperv.git', branch: 'main'
      }
    }
    stage('Copy Scripts to Node2') {
      steps {
        powershell """
          $password = ConvertTo-SecureString '${SSH_PASS}' -AsPlainText -Force
          $credential = New-Object System.Management.Automation.PSCredential ('${SSH_USER}', $password)
          $session = New-PSSession -ComputerName ${NODE2_IP} -Credential $credential -Authentication Basic
          Copy-Item -Path './scripts/*' -Destination 'C:\\Scripts\\' -ToSession $session -Recurse -Force
          Remove-PSSession $session
        """
      }
    }
    stage('Copy Scripts to Node3') {
      steps {
        powershell """
          $password = ConvertTo-SecureString '${SSH_PASS}' -AsPlainText -Force
          $credential = New-Object System.Management.Automation.PSCredential ('${SSH_USER}', $password)
          $session = New-PSSession -ComputerName ${NODE3_IP} -Credential $credential -Authentication Basic
          Copy-Item -Path './scripts/*' -Destination 'C:\\Scripts\\' -ToSession $session -Recurse -Force
          Remove-PSSession $session
        """
      }
    }
    stage('Run SQL FCI Install on Node3') {
      steps {
        powershell """
          $password = ConvertTo-SecureString '${SSH_PASS}' -AsPlainText -Force
          $credential = New-Object System.Management.Automation.PSCredential ('${SSH_USER}', $password)
          Invoke-Command -ComputerName ${NODE3_IP} -Credential $credential -Authentication Basic -ScriptBlock {
            & 'C:\\Scripts\\install-sql-fci.ps1'
          }
        """
      }
    }
    stage('Add Node to Cluster on Node2') {
      steps {
        powershell """
          $password = ConvertTo-SecureString '${SSH_PASS}' -AsPlainText -Force
          $credential = New-Object System.Management.Automation.PSCredential ('${SSH_USER}', $password)
          Invoke-Command -ComputerName ${NODE2_IP} -Credential $credential -Authentication Basic -ScriptBlock {
            & 'C:\\Scripts\\add-node.ps1'
          }
        """
      }
    }
  }
}
