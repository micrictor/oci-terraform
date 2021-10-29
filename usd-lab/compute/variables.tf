variable "compartment_id" {
    description = "OCI Compartment ID"
    type = string
}

variable "public_subnet_id" {
    description = "Subnet for the bastion instance"
    type = string
}

variable "availability_domain" {
    description = "Availability domain for subnets"
    type = string
    default = "xdil:US-SANJOSE-1-AD-1"
}

variable "bastion_shape" {
    description = "Shape for the bastion host"
    type = string
    default = "VM.Standard.E2.1.Micro"
}

variable "bastion_image" {
    description = "Image for the bastion host"
    type = string
    // Oracle-Linux-7.9-2021.10.20-0
    default = "ocid1.image.oc1.us-sanjose-1.aaaaaaaacm32nukryvrugwg2aeupbl342mx7oaa6gz4fwfd7uucm7u36alcq"
}

variable "ssh_authorized_keys" {
    description = "List of authorized SSH keys"
    type = list
    default = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC+R7q2SmjpuQ0YiRr1SnyPQFyKjtG3sG0KG07Y1hA5tP6Cg0zN5wbuky3u6lpa7jy8rV4ij4lPDDHs3sL3tK248QUx+1061tSEZ+mzpR1c7z194RFUT8IuRy7sc+HvyH+ufey6DgeKYmJIxjJQevTYTGTldo8kyR2qKXyfewjLDOjEIuo19TnU1Di/Q/7g6s84jSdEEm2ZPXuxt0Lp9j6ViSM9sw63JsdBHyLO7bjRZLY+MIjZxJk6BFDzrSq9tE34pnuS6jvc6jUtXviCOFX2lPpic+98qIAwOU+GsOjvtI2ZD7L1yf6M5pNK+N9dNxLaLwmvRaK9IkxNwxBMBj61wdIwhoYtpu7PJWj9KwVZ01aQCRUZqVNKPMrzNzR6JtufRaUPRUkfOzfG04be/XxB0vhVqsKU9WFlSHOlvY0+7ocO1907FjCnCa4oo/ucuB3roBo9q7tuq3+nt2FlnRWnHMc+a483OlxR0DMNa2Qgi6Uj4G//6gWRZbk7BqaPrS8= mtu@laptop-01.attlocal.net",
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCXNYeVgEsZewIGyHkpXV+KTmJf6J7fgiDnHzSHQ3o12msuXGJXv8+YcjNlvefxhqay9ydxCe7VTXY/W8shXTXLu0/XnKIT5EpH9gQjX38UbynnjEbq9Sm+IwGFyiIqwYt6cQvYSf+BrsXM/K/KnXl6j8+ZyJQ1/bnF2pbohaCjPA+HEbOLuJBoBgXGXdP6B4y+dkxYQvf9LPSK6PSVqdDhWpF7oTOvg9O+XmrUiQL6VABvqf0yp6doIit8clPnF2Ja7Kprxp1/nxfZeUF5jYHKqs8RqO11lrebPTfugTDBd95YYAuaNxdmw9KueKhMyD62se2M81kDn+DIEmNTBDvx CYBR512_groupssh"
    ]
}