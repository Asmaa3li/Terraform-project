
# ================================================== Create Bastion Server ==================================================

resource "aws_instance" "asmaa-bastion" {
  ami             = "ami-0776c814353b4814d"    
  instance_type   = "t2.micro"     
  user_data = <<-EOF
    #!/bin/bash
    mkdir -p /home/ubuntu/.ssh
    echo -e "${aws_key_pair.asmaa-key.public_key}" >> /home/ubuntu/.ssh/authorized_keys
    EOF

    # cp /tmp/asmaa-private-key.pem /home/ubuntu/.ssh/id_rsa
    provisioner "file" {
    source      = "F:/ITI-9months/Terraform/day1/asmaa-private-key.pem" 
    destination = "/home/ubuntu/.ssh/id_rsa"    
    connection {
      type        = "ssh"
      user        = "ubuntu"  
      private_key = tls_private_key.asmaa-private-key.private_key_pem  
      host        = self.public_ip  
    }
  }
    provisioner "remote-exec" {
    inline = [
      #use echo
      "sudo chmod 400 /home/ubuntu/.ssh/id_rsa"  
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"  
      private_key = tls_private_key.asmaa-private-key.private_key_pem 
      host        = self.public_ip  
    }
  }

  subnet_id       = aws_subnet.asmaa-public-subnet.id
  security_groups = [aws_security_group.asmaa-secgroup.id]
  key_name        = aws_key_pair.asmaa-key.id  #overwrites userdata 
  tags = {
    Name = "asmaa-bastion"
  }


  depends_on = [     
    aws_key_pair.asmaa-key ,
    tls_private_key.asmaa-private-key
 ]
}

# ================================================== Create Private Instance ==================================================


resource "aws_instance" "asmaa-private" {
  ami             = "ami-0776c814353b4814d"  
  instance_type   = "t2.micro"     

  # user_data = <<-EOF
  #     #!/bin/bash
  #     echo -e "${aws_key_pair.asmaa-key.public_key}" >> /tmp/authorized_keys
  #     sudo mv /tmp/authorized_keys /home/ubuntu/.ssh/authorized_keys
  #   EOF

  subnet_id       = aws_subnet.asmaa-private-subnet.id
  security_groups = [aws_security_group.asmaa-secgroup2.id]
  key_name        = aws_key_pair.asmaa-key.id

  tags = {
    Name = "asmaa-private"
  }

  depends_on = [     
    aws_key_pair.asmaa-key,
    tls_private_key.asmaa-private-key

 ]

}