terraform {
  required_providers {
    hyperv = {
      source  = "taliesins/hyperv"
      version = "1.2.1"
    }
  }
}

provider "hyperv" {
  user     = var.hyperv_user
  password = var.hyperv_password
}


resource "hyperv_machine_instance" "node01" {
  name                   = "node01"
  generation             = 1
  memory_startup_bytes   = 2147483648
  processor_count        = 2
  static_memory          = true
  automatic_start_action = "StartIfRunning"
  automatic_stop_action  = "ShutDown"

  network_adaptors {
    name        = "Default Switch"
    switch_name = "Default Switch"
  }

  hard_disk_drives {
    path                = "C:\\ProgramData\\Microsoft\\Windows\\Virtual Hard Disks\\dc.vhdx"
    controller_number   = 0
    controller_location = 0
    controller_type     = "Ide"
  }
}

resource "hyperv_machine_instance" "node2" {
  name                   = "node2"
  generation             = 1
  memory_startup_bytes   = 2147483648
  processor_count        = 2
  static_memory          = true
  automatic_start_action = "StartIfRunning"
  automatic_stop_action  = "ShutDown"

  network_adaptors {
    name        = "Default Switch"
    switch_name = "Default Switch"
  }

  hard_disk_drives {
    path                = "C:\\HyperV\\BaseImages\\node2-clean.vhdx"
    controller_number   = 0
    controller_location = 0
    controller_type     = "Ide"
  }
}

resource "hyperv_machine_instance" "iscsi_server" {
  name                   = "isci-server"
  generation             = 1
  memory_startup_bytes   = 2147483648
  processor_count        = 4
  dynamic_memory         = true
  automatic_start_action = "StartIfRunning"
  automatic_stop_action  = "Save"
  checkpoint_type        = "Standard"

  network_adaptors {
    name                              = "Default Switch"
    switch_name                       = "Default Switch"
    allow_teaming                     = "Off"
    iov_interrupt_moderation          = "Default"
    iov_weight                        = 0
    packet_direct_moderation_count    = 64
    packet_direct_moderation_interval = 1000000
    vmmq_enabled                      = true
    wait_for_ips                      = false
  }

  hard_disk_drives {
    path                = "C:\\ProgramData\\Microsoft\\Windows\\Virtual Hard Disks\\isci-server.vhdx"
    controller_number   = 0
    controller_location = 0
    controller_type     = "Ide"
  }
}
resource "hyperv_machine_instance" "node3" {
  name                   = "node3"
  generation             = 1
  memory_startup_bytes   = 1073741824  # 1 GB
  processor_count        = 2
  static_memory          = true
  automatic_start_action = "StartIfRunning"
  automatic_stop_action  = "ShutDown"

  network_adaptors {
    name        = "Default Switch"
    switch_name = "Default Switch"
  }

  hard_disk_drives {
    path                = "C:\\HyperV\\BaseImages\\node3-clean.vhdx"
    controller_number   = 0
    controller_location = 0
    controller_type     = "IDE"
  }

}

 


