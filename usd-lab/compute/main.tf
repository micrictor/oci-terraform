resource "oci_core_instance" "bastion_instance" {
    compartment_id = var.compartment_id
    availability_domain = var.availability_domain
    display_name = "Bastion instance"
    shape = var.bastion_shape
    image = var.bastion_image
    create_vnic_details {
        subnet_id = var.public_subnet_id
    }
    metadata = {
      "ssh_authorized_keys" = join("\n", var.ssh_authorized_keys)
    }
}