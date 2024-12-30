resource "aws_key_pair" "example2" {
  key_name   = var.key_name 
  public_key = file("${path.module}/mykey.pub")  # Replace the path for your public key file
}
