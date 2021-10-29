terraform {
  required_providers {
    oci = {
      source = "hashicorp/oci"
    }
  }
}

provider "oci" {
  region              = "us-sanjose-1"
  auth                = "SecurityToken"
  config_file_profile = "terraform-deploy"
}

module "network" {
  source="./network"
  
  compartment_id = var.compartment_id
}

module "compute" {
  source="./compute"
  
  compartment_id = var.compartment_id
  public_subnet_id = module.network.public_subnet.id
}