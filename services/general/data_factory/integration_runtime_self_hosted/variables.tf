variable "data_factory_id" {
  type = string
}
variable "name" {
  type = string
}
variable "description" {
  type    = string
  default = null
}
variable "settings" {
  default = {}
}
# variable "data_factories" {
#   default = {}
# }
variable "id" {
  default = null
}
