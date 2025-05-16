pipeline {
  agent any

  environment {
    NODE2 = '172.19.124.223'
    NODE3 = '172.19.124.224'
    SSH_USER = 'Administrator'
    SSH_PASS = credentials('local-admin-password')  // Use your Jenkins credential ID for Qwaszx12_
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
          $password = ConvertTo-SecureString '${SSH_PASS}' -AsPlainText -Force
          $cred = New-Object System.Management.Automation.PSCredential ('${SSH_USER}', $password)
          New-SFTPSession -ComputerName ${NODE2} -Credential $cred
          Set-SFTPFile -SessionId 0 -LocalFile 'sql-install\\*' -RemotePath 'C:\\Users\\Administrator\\sql-install' -Recurse
          Remove-SFTPSession -SessionId 0
        """
      }
    }

    stage('Copy Scripts to Node3') {
      steps {
        powershell """
          $password = ConvertTo-SecureString '${SSH_PASS}' -AsPlainText -Force
          $cred = New-Object System.Management.Automation.PSCredential ('${SSH_USER}', $password)
          New-SFTPSession -ComputerName ${NODE3} -Credential $cred
          Set-SFTPFile -SessionId 0 -LocalFile 'sql-install\\*' -RemotePath 'C:\\Users\\Administrator\\sql-install' -Recurse
          Remove-SFTPSession -SessionId 0
        """
      }
    }

    stage('Run SQL FCI Install on Node3') {
      steps {
        powershell """
          $password = ConvertTo-SecureString '${SSH_PASS}' -AsPlainText -Force
          $cred = New-Object System.Management.Automation.PSCredential ('${SSH_USER}', $password)
          $session = New-SSHSession -ComputerName ${NODE3} -Credential $cred
          Invoke-SSHCommand -SessionId $session.SessionId -Command 'powershell.exe -ExecutionPolicy Bypass -File C:\\Users\\Administrator\\sql-install\\install_fci.ps1'
          Remove-SSHSession -SessionId $session.SessionId
        """
      }
    }

    stage('Add Node to Cluster on Node2') {
      steps {
        powershell """
          $password = ConvertTo-SecureString '${SSH_PASS}' -AsPlainText -Force
          $cred = New-Object System.Management.Automation.PSCredential ('${SSH_USER}', $password)
          $session = New-SSHSession -ComputerName ${NODE2} -Credential $cred
          Invoke-SSHCommand -SessionId $session.SessionId -Command 'powershell.exe -ExecutionPolicy Bypass -File C:\\Users\\Administrator\\sql-install\\add_node.ps1'
          Remove-SSHSession -SessionId $session.SessionId
        """
      }
    }
  }
}
