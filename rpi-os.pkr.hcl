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
  iso_url              = var.source_iso_url
  iso_checksum         = "sha256:${var.source_iso_checksum}"
  iso_target_extension = "img"
  image_type           = "raspberrypi"
  output_filename      = local.image_name
  target_image_size    = 3221225472
}

build {
  name    = "base"
  sources = ["source.arm-image.pi"]

  provisioner "shell" {
    script = "./rpi-os-prerun.sh"
  }

  provisioner "shell" {
    script = "./rpi-os-run.sh"
  }
}