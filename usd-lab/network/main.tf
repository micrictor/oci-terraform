resource "oci_core_vcn" "lab_network" {
  compartment_id = var.compartment_id
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
  compartment_id = var.compartment_id
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

resource "oci_core_internet_gateway" "internet_gateway" {
    compartment_id = var.compartment_id
    vcn_id = oci_core_vcn.lab_network.id
    enabled = true
}

resource "oci_core_default_route_table" "internet_route_table" {
    compartment_id = var.compartment_id
    manage_default_resource_id = oci_core_vcn.lab_network.default_route_table_id

    route_rules {
        network_entity_id = oci_core_internet_gateway.internet_gateway.id
        destination = "0.0.0.0/0"
        destination_type = "CIDR_BLOCK"
    }
}

resource "oci_core_subnet" "public_subnet" {
  compartment_id = var.compartment_id
  availability_domain = "xdil:US-SANJOSE-1-AD-1"
  vcn_id = oci_core_vcn.lab_network.id
  cidr_block = oci_core_vcn.lab_network.cidr_blocks[0]
  display_name = "Public subnet"
  security_list_ids = [ oci_core_security_list.ssh_inbound_list.id, oci_core_vcn.lab_network.default_security_list_id ]
}