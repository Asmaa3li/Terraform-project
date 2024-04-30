#create pub/pri tls #aws_ky_pair 

resource "tls_private_key" "asmaa-private-key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}  #key-gen creates both 

resource "local_file" "private_key_file" {
  content  = tls_private_key.asmaa-private-key.private_key_pem
  filename = "asmaa-private-key.pem"
}

resource "aws_key_pair" "asmaa-key" {
  key_name   = "asmaa-key"
  public_key = tls_private_key.asmaa-private-key.public_key_openssh   #public key from tls_private_key
}