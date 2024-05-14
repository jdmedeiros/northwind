variable "key_name" {
  description = "Key pair name to use for the EC2 instance"
  type        = string
  default     = "aws-academy-key"
}

variable "user" {
  description = "RDS instance username"
  type        = string
  default     = "admin"
}

variable "password" {
  description = "RDS instance password"
  type        = string
  default     = "Passw0rd#SuperSecreta"
  sensitive   = true
}

variable "port" {
  description = "RDS instance port"
  type        = number
  default     = 3306
}

variable "ip_list" {
  description = "List of allowed IPs"
  type        = list(string)
  default     = [
    "10.0.0.0/8",
    "172.16.0.0/12",
    "192.168.0.0/16",
    "62.28.64.146/32",
  ]
}
