variable "hyperv_user" {
  description = "Username for Hyper-V host"
  type        = string
}

variable "hyperv_password" {
  description = "Password for Hyper-V host"
  type        = string
  sensitive   = true
}
