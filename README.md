# High Availability SQL Server Failover Cluster Setup

This project automates the deployment of a highly available SQL Server Failover Cluster Instance (FCI) on Windows Server VMs using Hyper-V and shared iSCSI storage.

---

## Architecture Overview

* **Domain Controller:** Active Directory setup to manage authentication.
* **Node1 & Node2:** Windows Server 2022 VMs participating in the failover cluster.
* **Shared Storage:** iSCSI target attached to both nodes.
* **SQL Server 2022:** Installed as a Failover Cluster Instance.

---

## Key Features

* Automated provisioning using Terraform
* SQL Server setup via PowerShell and Jenkins
* Shared storage mounted as `Cluster Disk 1`
* Failover Cluster configured and validated

---

## Prerequisites

### On Hyper-V Host

* Enabled Hyper-V feature
* Shared VHDX or iSCSI Target setup for shared disk

### On Each Node

* Windows Server 2022
* Roles:

  * Failover Clustering
  * File Server
  * iSCSI Initiator
* Features:

  * .NET Framework 4.7+

---

## Setup Instructions

### 1. Create Domain Controller

* Promote `node01` to Domain Controller: `lab.local`
* Set static IP and enable DNS

### 2. Create and Join Cluster Nodes

* Provision `node2` and `node3`
* Join both to `lab.local`

### 3. Configure iSCSI Target

* Setup shared disk and connect from both nodes
* Initialize and format as NTFS

### 4. Enable Windows Roles

```
Install-WindowsFeature Failover-Clustering -IncludeManagementTools
Install-WindowsFeature FS-iSCSITarget-Server
```

---

## Jenkins Pipeline

Used `Plink.exe` and `pscp.exe` (Putty tools) to automate SSH-based remote execution.

### Steps:

1. Checkout from GitHub
2. Skip file copy if already manually placed
3. Execute `install_fci.ps1` on Node3
4. Add Node2 to cluster with `add_node.ps1`

---

## PowerShell Scripts

### `install_fci.ps1`

Installs SQL Server 2022 FCI on Node3.

```powershell
$setupPath = "E:\setup.exe"
$configFile = "C:\Scripts\SQLFCI.ini"
Start-Process -FilePath $setupPath -ArgumentList "/ConfigurationFile=$configFile" -Wait
```

### `add_node.ps1`

Adds Node2 to the cluster setup.

```powershell
$setupPath = "E:\setup.exe"
$configFile = "C:\Scripts\SQLAddNode.ini"
Start-Process -FilePath $setupPath -ArgumentList "/ConfigurationFile=$configFile" -Wait
```

---

## Screenshots

(To be inserted below)

1. **Cluster Summary View** – Shows cluster name, nodes, networks
   `cluster-summary.png`

2. **Nodes Status** – Both nodes `UP` and in the cluster
   `cluster-nodes.png`

3. **Add Shared Disk** – Adding iSCSI shared disk to the cluster
   `add-cluster.png`

4. **Disk Management** – Confirming Cluster Disk is online
   `disk-management-node01.png`

5. **iSCSI Connected (Node1 & Node2)** – Verified iSCSI targets are connected
   `iscsi-node01-connected.png`, `iscsi-node02-connected.png`

6. **SQL Cluster Validation Passed** – All checks passed, one warning for MSCS
   `fci-validation-results.png`

7. **Skip AD Check** – Used SkipRules to bypass AD domain controller rule
   `skip-ad-validation.png`

8. **SQL FCI Setup** – Installation executed via `setup.exe` with config file
   `sql-fci-install-node01.png`

---

## Notes

* Pipeline execution issues were bypassed by copying files manually to C:\Scripts on the nodes
* SSH used instead of WinRM for simplicity
* AD was needed for DNS and Failover Cluster support

---

## Credits

Omar Elshall
GitHub: [Omarelshall1995](https://github.com/Omarelshall1995)
