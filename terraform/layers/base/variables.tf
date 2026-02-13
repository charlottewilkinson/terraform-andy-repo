variable "project_name" {
  description = "Project Name Identifier"
  type        = string
}

variable "environment" {
  description = "Deployed environment identifier"
  type        = string
  default     = "dev"
}

variable "cidr" {
  description = "CIDR for my-vpc"
}