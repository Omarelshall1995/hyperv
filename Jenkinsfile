pipeline {
  agent any

  environment {
    NODE2_IP = '172.19.124.223'
    NODE3_IP = '172.19.124.224'
  }

  stages {
    stage('Checkout') {
      steps {
        git url: 'https://github.com/Omarelshall1995/hyperv.git', branch: 'main'
      }
    }

    stage('Copy Scripts to Node2') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'ssh-password-id', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
          powershell """
            \$secpasswd = ConvertTo-SecureString '${PASSWORD}' -AsPlainText -Force
            \$cred = New-Object System.Management.Automation.PSCredential('${USERNAME}', \$secpasswd)
            Copy-Item -Path "\${WORKSPACE}\\sql-install\\*" -Destination "C:\\Scripts\\" -Recurse -ToSession (New-PSSession -ComputerName ${NODE2_IP} -Credential \$cred)
          """
        }
      }
    }

    stage('Copy Scripts to Node3') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'ssh-password-id', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
          powershell """
            \$secpasswd = ConvertTo-SecureString '${PASSWORD}' -AsPlainText -Force
            \$cred = New-Object System.Management.Automation.PSCredential('${USERNAME}', \$secpasswd)
            Copy-Item -Path "\${WORKSPACE}\\sql-install\\*" -Destination "C:\\Scripts\\" -Recurse -ToSession (New-PSSession -ComputerName ${NODE3_IP} -Credential \$cred)
          """
        }
      }
    }

    stage('Run SQL FCI Install on Node3') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'ssh-password-id', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
          powershell """
            \$secpasswd = ConvertTo-SecureString '${PASSWORD}' -AsPlainText -Force
            \$cred = New-Object System.Management.Automation.PSCredential('${USERNAME}', \$secpasswd)
            Invoke-Command -ComputerName ${NODE3_IP} -Credential \$cred -ScriptBlock { C:\\Scripts\\install_fci.ps1 }
          """
        }
      }
    }

    stage('Add Node to Cluster on Node2') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'ssh-password-id', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
          powershell """
            \$secpasswd = ConvertTo-SecureString '${PASSWORD}' -AsPlainText -Force
            \$cred = New-Object System.Management.Automation.PSCredential('${USERNAME}', \$secpasswd)
            Invoke-Command -ComputerName ${NODE2_IP} -Credential \$cred -ScriptBlock { C:\\Scripts\\add_node.ps1 }
          """
        }
      }
    }
  }
}
