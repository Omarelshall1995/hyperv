pipeline {
  agent any
  environment {
    NODE2_IP = '172.19.124.223'
    NODE3_IP = '172.19.124.224'
    SSH_USER = 'administrator'
    SSH_PASS = credentials('ssh-password-id')  // your Jenkins credential ID for SSH password
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
          \$pass = ConvertTo-SecureString -String '${SSH_PASS}' -AsPlainText -Force
          \$cred = New-Object System.Management.Automation.PSCredential('${SSH_USER}', \$pass)
          \$session = New-PSSession -HostName ${NODE2_IP} -UserName '${SSH_USER}' -SSHTransport -Credential \$cred
          Copy-Item -Path '.\\scripts\\*' -Destination 'C:\\Scripts\\' -ToSession \$session -Recurse -Force
          Remove-PSSession \$session
        """
      }
    }

    stage('Copy Scripts to Node3') {
      steps {
        powershell """
          \$pass = ConvertTo-SecureString -String '${SSH_PASS}' -AsPlainText -Force
          \$cred = New-Object System.Management.Automation.PSCredential('${SSH_USER}', \$pass)
          \$session = New-PSSession -HostName ${NODE3_IP} -UserName '${SSH_USER}' -SSHTransport -Credential \$cred
          Copy-Item -Path '.\\scripts\\*' -Destination 'C:\\Scripts\\' -ToSession \$session -Recurse -Force
          Remove-PSSession \$session
        """
      }
    }

    stage('Run SQL FCI Install on Node3') {
      steps {
        powershell """
          \$pass = ConvertTo-SecureString -String '${SSH_PASS}' -AsPlainText -Force
          \$cred = New-Object System.Management.Automation.PSCredential('${SSH_USER}', \$pass)
          \$session = New-PSSession -HostName ${NODE3_IP} -UserName '${SSH_USER}' -SSHTransport -Credential \$cred
          Invoke-Command -Session \$session -ScriptBlock { & 'C:\\Scripts\\install-sql-fci.ps1' }
          Remove-PSSession \$session
        """
      }
    }

    stage('Add Node to Cluster on Node2') {
      steps {
        powershell """
          \$pass = ConvertTo-SecureString -String '${SSH_PASS}' -AsPlainText -Force
          \$cred = New-Object System.Management.Automation.PSCredential('${SSH_USER}', \$pass)
          \$session = New-PSSession -HostName ${NODE2_IP} -UserName '${SSH_USER}' -SSHTransport -Credential \$cred
          Invoke-Command -Session \$session -ScriptBlock { & 'C:\\Scripts\\add-node.ps1' }
          Remove-PSSession \$session
        """
      }
    }
  }
}
