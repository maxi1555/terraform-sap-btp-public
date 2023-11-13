variable "globacct" {
  type        = string
  nullable    = false
  description = "The Global Account subdomain."
}


variable "username" {
  type        = string
  nullable    = false
  sensitive = true
  description = "Global Administrator e-mail address."
}


variable "password" {
  type        = string
  nullable    = false
  sensitive   = true
  description = "Global Administrator password."
}


variable "region" {
  type        = string
  description = "The region where the project account shall be created in."
  nullable    = false
}


variable "shootname" {
  type        = string
  description = "The Kyma Cluster shootname which the project is deployed to."
  default     = null
  nullable    = true
}

variable "subaccount_admins" {
  type        = list(string)
  default     = null
  description = "The Subaccount Admin(s)."

  validation {
    condition = (var.subaccount_admins == null || can([for s in var.subaccount_admins : regex("^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}$", s)]))
    error_message = "Provide a valid subaccount administrator."
  }
}

variable "tenant" {
  type        = string
  nullable    = false
  description = "The name of your subscriber tenant."

  validation {
    condition     = can(regex("^[a-zA-Z0-9_\\-]{1,200}", var.tenant))
    error_message = "Provide a valid subscriber tenant name."
  }
}