packer {
  required_plugins {
    arm-image = {
      version = "~> 0.2.7"
      source  = "github.com/solo-io/arm-image"
    }
  }
}

variable "source_iso_url" {
  type = string
}

variable "source_iso_checksum" {
  type = string
}

locals {
  image_name = "${formatdate("YYYYMMDD-hhmmss", timestamp())}_arm64.img"
}

source "arm-image" "pi" {
  iso_url           = var.source_iso_url
  iso_checksum      = var.source_iso_checksum
  target_image_size = 3221225472
}

build {
  name            = "base"
  sources         = ["source.arm-image.pi"]
  output_filename = local.image_name

  provisioner "shell" {
    script = "./rpi-prerun.sh"
  }

  provisioner "shell" {
    script = "./rpi-run.sh"
  }
}