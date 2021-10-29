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
  config_file_profile = "DEFAULT"
}

resource "oci_core_vcn" "lab_network" {
  compartment_id = "ocid1.tenancy.oc1..aaaaaaaa6o4ttfxdfx7by5xhlb2527wylvsf3fyycheaqs4sjugy6ju2auya"
  dns_label      = "internal"
  cidr_blocks    = [
    "172.16.0.0/20",
    "10.0.0.0/24",
  ]
  display_name   = "Lab"
}

resource "oci_core_default_security_list" "default_list" {
  manage_default_resource_id = oci_core_vcn.lab_network.default_security_list_id

  display_name = "Outbound only (default)"

  egress_security_rules {
    protocol = "6" // TCP
    description = "Allow outbound"
    destination = "0.0.0.0/0"
  }
}

resource "oci_core_security_list" "ssh_inbound_list" {
  compartment_id = "ocid1.tenancy.oc1..aaaaaaaa6o4ttfxdfx7by5xhlb2527wylvsf3fyycheaqs4sjugy6ju2auya"
  vcn_id         = oci_core_vcn.lab_network.id
  display_name = "Permit SSH inbound"
  ingress_security_rules {
    protocol = "6" // TCP
    source = "0.0.0.0/0"
    tcp_options {
      max = 22
      min = 22
    }
  }
}

resource "oci_core_subnet" "public_subnet" {
  compartment_id = "ocid1.tenancy.oc1..aaaaaaaa6o4ttfxdfx7by5xhlb2527wylvsf3fyycheaqs4sjugy6ju2auya"
  availability_domain = "xdil:US-SANJOSE-1-AD-1"
  vcn_id = oci_core_vcn.lab_network.id
  cidr_block = oci_core_vcn.lab_network.cidr_blocks[0]
  display_name = "Public subnet"
  security_list_ids = [ oci_core_security_list.ssh_inbound_list.id, oci_core_vcn.lab_network.default_security_list_id ]
}
