######################### VARIABLES #########################

#------------VPC------------#
variable "cidr_block" { type = string }

variable "subnet_az" {
  type = map(object({
    az_index             = number
    public_subnet_count  = number
    private_subnet_count = number
  }))
  description = "Map of AZ configurations with subnet counts"
}

#------------ACM------------#
variable "domain" { type = string }

#------------PARAMETER STORE------------#
variable "source_services" {
  type = list(string)
}

#------------EC2------------#
variable "enabled_eip" {
  type = bool
  default = true
}

variable "instance_type" {
  type = string
  default = "t3a.medium"
}

variable "instance_name" {
  type = string
}

variable "iops" {
  type = number
  default = 3000
}

variable "path_user_data" {
  type = string
}

variable "volume_size" {
  type = number
  default = 40
}

variable "key_name" {
  type = string
}

variable "sg_ingress" {
  type = map(object({
    from_port   = number
    to_port     = number
    protocol    = optional(string, "tcp")
    description = string
    source_security_group_id = optional(string, null)
    cidr_blocks = optional(list(string), ["0.0.0.0/0"])
  }))
  description = "Map of ingress rules for EC2 security group"
}

variable "sg_egress" {
  type = map(object({
    from_port   = optional(number, 0)
    to_port     = optional(number, 0)
    protocol    = optional(string, "-1")
    description = optional(string, "Allow outbound access")
    cidr_blocks = optional(list(string), ["0.0.0.0/0"])
    source_security_group_id = optional(string, null)
  }))
  description = "Map of egress rules for EC2 security group"
}

#------------ALB------------#
variable "lb_name" {
  type = string
}

variable "source_ingress_sg_cidr" {
  type = list(string)
  default = ["0.0.0.0/0"]
  description = "Source ingress security group CIDR"
}

variable "enable_https_listener" {
  type = bool
  default = false
  description = "Enable HTTPS listener (requires dns_cert_arn)"
}

variable "target_groups" {
  type = map(object({
    name = string
    service_port = number
    health_check_path = string
    priority = number
    host_header = string
    description = string
    target_type = optional(string, "instance")
    ec2_id = optional(string, null)
  }))
}