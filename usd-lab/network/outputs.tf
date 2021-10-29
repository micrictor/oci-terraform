output "vcn" {
    description = "Created VCN"
    value = oci_core_vcn.lab_network
}

output "public_subnet" {
    description = "Subnet that allows inbound SSH"
    value = oci_core_subnet.public_subnet
}