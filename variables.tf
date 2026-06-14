variable "location" {
  description = "Azure region for all resources"
  type        = string
  default     = "swedencentral"
}

variable "student_name" {
  description = "Student name used for resource naming"
  type        = string
  default     = "abdalhakim"
}

variable "docker_image" {
  description = "Docker Hub image to deploy"
  type        = string
  default     = "abdalhakimelghweiry/cloudscale-app:latest"
}

variable "container_cpu" {
  description = "Number of CPU cores for the container"
  type        = number
  default     = 1
}

variable "container_memory" {
  description = "Memory in GB for the container"
  type        = number
  default     = 1.5
}
