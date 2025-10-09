variable "required_labels" {
  type        = list(string)
  description = "Labels that must be present on resources"
  default     = ["owner"]
}
