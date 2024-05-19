variable "web_bucket_name" {
  description = "Name of the s3 web bucket. Must be unique."
  type        = string
}

variable "web_directory_to_upload" {
  description = "Path to the web directory to upload."
  type        = string
}