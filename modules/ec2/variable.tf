#----------------Project------------------#
 variable "project" {
  type = object({
    name = string
    env  = string
    region = string
    account_ids = list(string)
  })
}

variable "tags" {
  type = object({
    Name = string
  })
}

#---------------------EC2 instance---------------------#
variable "instance_type" {
  default = "t3.micro"
  type    = string
}

variable "iops" {
  type = number
}
variable "volume_size" {
  type = number
}

variable "enabled_eip" {
  type = bool
}

variable "instance_name" {
  type = string
}

variable "subnet_id" {}

variable "vpc_id" {
  type        = string
  description = "VPC ID where the EC2 instance will be created"
}

variable "alb_sg_id" {
  type        = string
  default     = "" # empty string means no ALB security group
  description = "Security group ID of ALB (optional)"
}

# variable "path_public_key" {
#   type = string
#   description = "Path to import public key"
# }

variable "path_user_data" {
  type = string
  description = "Path to user data"
}

variable "key_name" {
  type = string
  description = "Name of the key pair"
}

# variable "path_public_key" {
#   type = string
#   description = "Path to public key"
# }

variable "sg_ingress" {
  type = map(object({
    from_port      = number
    to_port        = number
    protocol       = string
    description    = string
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

variable "enable_cloudwatch" {
  type        = bool
  default     = false
  description = "Enable CloudWatch alarms and dashboard for EC2"
}

variable "cloudwatch_alarms" {
  type = object({
    cpu_high = object({
      threshold          = number
      evaluation_periods = number
      period             = number
    })
    status_check_failed = object({
      threshold          = number
      evaluation_periods = number
      period             = number
    })
    instance_status_check_failed = object({
      threshold          = number
      evaluation_periods = number
      period             = number
    })
    system_status_check_failed = object({
      threshold          = number
      evaluation_periods = number
      period             = number
    })
    disk_read_ops_high = object({
      threshold          = number
      evaluation_periods = number
      period             = number
    })
    disk_write_ops_high = object({
      threshold          = number
      evaluation_periods = number
      period             = number
    })
    alarm_actions = list(string)
    ok_actions    = list(string)
  })
  default = {
    cpu_high = {
      threshold          = 80
      evaluation_periods = 2
      period             = 300
    }
    status_check_failed = {
      threshold          = 0
      evaluation_periods = 2
      period             = 60
    }
    instance_status_check_failed = {
      threshold          = 0
      evaluation_periods = 2
      period             = 60
    }
    system_status_check_failed = {
      threshold          = 0
      evaluation_periods = 2
      period             = 60
    }
    disk_read_ops_high = {
      threshold          = 1000
      evaluation_periods = 2
      period             = 300
    }
    disk_write_ops_high = {
      threshold          = 1000
      evaluation_periods = 2
      period             = 300
    }
    alarm_actions = []
    ok_actions    = []
  }
  description = "CloudWatch alarm configuration for EC2 instance"
}

