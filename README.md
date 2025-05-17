# SQL Server 2022 Failover Cluster Instance (FCI) Setup using Hyper-V, PowerShell, Terraform, and Jenkins

## Overview

This project demonstrates the automated setup of a highly available SQL Server 2022 Failover Cluster Instance using two Windows Server nodes provisioned via Terraform and running on Hyper-V. The solution includes:

* Active Directory and DNS configuration
* iSCSI shared storage setup
* Failover Clustering configuration
* SQL Server 2022 FCI installation
* Jenkins CI/CD pipeline to execute remote scripts using Plink (SSH)

## Infrastructure Components

* **Node1 (DC01):** Domain Controller, DNS
* **Node2 & Node3:** SQL FCI cluster nodes
* **Hyper-V Host:** Running all VMs
* **Shared Disk:** Configured with iSCSI

---

## Step-by-Step Setup

### 1. Prepare Hyper-V Environment

* Installed Hyper-V on the host machine
* Used Terraform to provision VMs:

  * Domain Controller (Node1)
  * Node2 (SQL FCI Primary)
  * Node3 (SQL FCI Secondary)

### 2. Active Directory Setup

* Promoted Node1 to Domain Controller (`lab.local`)
* Added Node2 and Node3 to the domain

### 3. iSCSI Target Configuration

* Created virtual disk `iscsi-server.vhdx`
* Configured iSCSI target on host and allowed Node2 & Node3 as initiators

**Screenshot Reference:**

* `iscsi-node01-connected.png`
* `iscsi-node02-connected.png`

### 4. Failover Cluster Installation

* Installed Failover Clustering role on Node2 & Node3
* Validated cluster using wizard

**Screenshot Reference:**

* `fci-validation-results.png`
* `add-cluster.png`
* `cluster-nodes.png`
* `cluster-summary.png`

### 5. Shared Disk Setup

* Initialized the shared disk in Disk Management (Node01)
* Added disk to cluster via Failover Cluster Manager

**Screenshot Reference:**

* `disk-manaement-node01.png`
* `Clusterdisk ON NODE01 ONLY.png`
* `Add clusterdisk ON FAILOVERCLUSTER.png`

### 6. Skip AD Checks (If any domain/validation warnings)

**Screenshot Reference:**

* `skip-ad-validation.png`

### 7. SQL Server 2022 Installation - Node1

* Mounted SQL ISO: `SQLServer2022-x64-ENU-Dev.iso`
* Launched setup using a PowerShell script:

```powershell
Start-Process -FilePath "C:\SQL2022\setup\setup.exe" -ArgumentList "/ConfigurationFile=C:\Scripts\SQLFCI.ini" -Wait
```

**Screenshot Reference:**

* `sql-fci-install-node01.png`
* `sql fci node01.png`
* `installin fci.png`

### 8. Jenkins Pipeline

* Jenkins runs on a Windows VM
* We used Plink (`plink.exe`) for SSH remote execution and `pscp.exe` for file transfer (but this was later skipped in favor of manual copy)
* Jenkinsfile uses `bat` steps to invoke PowerShell over SSH:

```groovy
bat "plink.exe -pw %SSH_PASS% administrator@NODE3_IP powershell -ExecutionPolicy Bypass -File C:\Scripts\install_fci.ps1"
```

**Jenkins Stages:**

* Run SQL install script on Node3
* Add Node2 to SQL cluster using `add_node.ps1`

---

## Remaining Screenshots You Uploaded:

* `2 Nodes no issues noerrors.png` → Cluster healthy status
* `2 nODES up and running till now.png` → Confirmation of active nodes
* `node2 connected.png` / `nod1 Asci connected.png` → iSCSI confirmation

We will embed these with captions and appropriate stages if you confirm final names and ordering.

---

## Final Note

* Ensure all scripts are copied to `C:\Scripts` on each node
* Verify SQL shared disk is online and owned by Node1 before starting installation
* Use Jenkins only to run scripts (no file copying now)

Let me know when you’re ready to embed Jenkins stage screenshots or if anything should be renamed/added.
