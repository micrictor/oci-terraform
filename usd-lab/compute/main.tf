resource "oci_core_instance" "bastion_instance" {
    compartment_id = var.compartment_id
    availability_domain = local.instance_config.availability_domain
    display_name = "Bastion instance"
    shape = local.instance_config.shape_id
    source_details {
        source_id = local.instance_config.source_details.source_id
        source_type = local.instance_config.source_details.source_type
    }
    create_vnic_details {
        subnet_id = var.public_subnet_id
        nsg_ids = [ var.permit_ssh_nsg_id ]
    }
    metadata = {
      "ssh_authorized_keys" = local.instance_config.metadata.ssh_authorized_keys
      "user_data" = base64encode(var.bastion_user_data)
    }
}

resource "oci_core_instance" "ms3_instance" {
    compartment_id = var.compartment_id
    availability_domain = local.instance_config.availability_domain
    display_name = "Metasploitable 3"
    shape = local.instance_config.shape_id
    source_details {
        source_id = local.instance_config.source_details.source_id
        source_type = local.instance_config.source_details.source_type
    }
    create_vnic_details {
        subnet_id = var.public_subnet_id
    }
    metadata = {
      "ssh_authorized_keys" = local.instance_config.metadata.ssh_authorized_keys
      "user_data" = base64encode(var.metasploitable_user_data)
    }
}