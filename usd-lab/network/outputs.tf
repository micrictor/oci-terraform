output "vcn" {
    description = "Created VCN"
    value = oci_core_vcn.lab_network
}

output "public_subnet" {
    description = "Subnet that allows inbound SSH"
    value = oci_core_subnet.public_subnet
}

output "permit_ssh" {
    description = "NSG to permit ssh"
    value = oci_core_network_security_group.permit_ssh
}