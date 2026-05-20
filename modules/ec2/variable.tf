
variable "instances" {
  description = "List of EC2 instance configurations"
  type = map(object({
    ami_id        = string
    instance_type = string
    name          = string
    subnet_id     = string
  }))
}


variable "environment" {
  description = "environment for dev or prod"
  type        = string
}
