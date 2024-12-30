resource "aws_key_pair" "example" {
  key_name   = var.key_name 
  public_key = file("/mnt/c/terraform/projects/simple-flask-aap/mykey.pub")  # Replace the path for your public key file
}
