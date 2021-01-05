variable "user" {
  description = "RDS instance user name"
  default = "admin"
}

variable "password" {
  description = "RDS instance user password"
  default = "Passw0rd#SuperSecreta"
}

variable "port" {
  description = "RDS instance port"
  default = "3306"
}

variable "ip_list" {
  description = "Allowed IPs"
  type = list(string)
  default = [
    "10.0.0.0/8",
    "172.16.0.0/12",
    "192.168.0.0/16",
    "128.65.243.205/32",
    "78.29.152.220/32",
  ]
}
