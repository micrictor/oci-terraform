variable "compartment_id" {
    description = "OCI Compartment ID"
    type = string
}

variable "public_subnet_id" {
    description = "Subnet for the bastion instance"
    type = string
}

variable "permit_ssh_nsg_id" {
    description = "NSG to permit SSH"
    type = string
}

variable "availability_domain" {
    description = "Availability domain for subnets"
    type = string
    default = "xdil:US-SANJOSE-1-AD-1"
}

variable "ssh_authorized_keys" {
    description = "List of authorized SSH keys"
    type = list
    default = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC+R7q2SmjpuQ0YiRr1SnyPQFyKjtG3sG0KG07Y1hA5tP6Cg0zN5wbuky3u6lpa7jy8rV4ij4lPDDHs3sL3tK248QUx+1061tSEZ+mzpR1c7z194RFUT8IuRy7sc+HvyH+ufey6DgeKYmJIxjJQevTYTGTldo8kyR2qKXyfewjLDOjEIuo19TnU1Di/Q/7g6s84jSdEEm2ZPXuxt0Lp9j6ViSM9sw63JsdBHyLO7bjRZLY+MIjZxJk6BFDzrSq9tE34pnuS6jvc6jUtXviCOFX2lPpic+98qIAwOU+GsOjvtI2ZD7L1yf6M5pNK+N9dNxLaLwmvRaK9IkxNwxBMBj61wdIwhoYtpu7PJWj9KwVZ01aQCRUZqVNKPMrzNzR6JtufRaUPRUkfOzfG04be/XxB0vhVqsKU9WFlSHOlvY0+7ocO1907FjCnCa4oo/ucuB3roBo9q7tuq3+nt2FlnRWnHMc+a483OlxR0DMNa2Qgi6Uj4G//6gWRZbk7BqaPrS8= mtu@laptop-01.attlocal.net",
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCXNYeVgEsZewIGyHkpXV+KTmJf6J7fgiDnHzSHQ3o12msuXGJXv8+YcjNlvefxhqay9ydxCe7VTXY/W8shXTXLu0/XnKIT5EpH9gQjX38UbynnjEbq9Sm+IwGFyiIqwYt6cQvYSf+BrsXM/K/KnXl6j8+ZyJQ1/bnF2pbohaCjPA+HEbOLuJBoBgXGXdP6B4y+dkxYQvf9LPSK6PSVqdDhWpF7oTOvg9O+XmrUiQL6VABvqf0yp6doIit8clPnF2Ja7Kprxp1/nxfZeUF5jYHKqs8RqO11lrebPTfugTDBd95YYAuaNxdmw9KueKhMyD62se2M81kDn+DIEmNTBDvx CYBR512_groupssh",
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKbVoMOOhlkOksenq9HOJ2/79OwjML0DCvakmpXA5S+N tonyrpark@gmail.com",
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICNB7m6G+KJb5H02YHRBX/FiZIQhrbndEWnZNUmR4ADe peiyin760l@gmail.com"
    ]
}

variable "bastion_user_data" {
    description = "Commands to be ran at boot for the bastion instance. Default installs Kali headless"
    type = string
    default = <<EOT
#!/bin/sh
sudo apt update \
&& echo 'deb http://http.kali.org/kali kali-rolling main non-free contrib' | sudo tee /etc/apt/sources.list \
&& wget https://http.kali.org/kali/pool/main/k/kali-archive-keyring/kali-archive-keyring_2020.2_all.deb -O /tmp/keyring.deb \
&& sudo apt install /tmp/keyring.deb \
&& sudo apt update \
&& sudo DEBIAN_FRONTEND=noninteractive apt install -y kali-linux-headless
EOT
}

variable "metasploitable_user_data" {
    description = "Commands to be ran at boot for the bastion instance. Default installs Kali headless"
    type = string
    default = <<EOT
#!/bin/sh
sudo apt-get update
sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
sudo docker run -d --restart always -p 21:21 -p 80:80 -p 445:445 -p 631:631 -p 3000:3000 -p 3500:3500 -p 6697:6697 -p 3306:3306 -p 8181:8181 heywoodlh/vulnerable
EOT
}

locals {
    instance_config = {
        shape_id = "VM.Standard.E2.1.Micro"
        source_details = {
            // Canonical-Ubuntu-20.04-2021.10.15-0
            source_id = "ocid1.image.oc1.us-sanjose-1.aaaaaaaaugtulb77ufxo7io3zw2hj2cy34oerrfjweg6hlvxaffze754mm7a"
            source_type = "image"
        }
        metadata = {
            "ssh_authorized_keys" = join("\n", var.ssh_authorized_keys)
        }
        availability_domain = var.availability_domain
    }
}