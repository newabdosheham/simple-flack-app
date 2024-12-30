resource "aws_instance" "server" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name      = aws_key_pair.example.key_name
  vpc_security_group_ids = [aws_security_group.webSg.id]
  subnet_id              = aws_subnet.sub1.id

  connection {
    type        = "ssh"
    user        = "ubuntu"  # Replace with the appropriate username for your EC2 instance
    private_key = file("${path.module}/mykey")  # Replace with the path to your private key
    host        = self.public_ip
   }

   # File provisioner to copy a file from local to the remote EC2 instance
   provisioner "file" {
    source      = "./app.py"  # Replace with the path to your local file
    destination = "/home/ubuntu/app.py"  # Replace with the path on the remote instance
   }

Even though you're using Ubuntu, the solution still applies because Ubuntu is based on Debian and uses the same package management system (APT). The DEBIAN_FRONTEND=noninteractive environment variable is applicable to Ubuntu systems as well. Here's how you can modify your configuration specifically for Ubuntu:
Updated Solution for Ubuntu
1. Suppress Interactive Prompts for APT in Ubuntu

Use the DEBIAN_FRONTEND=noninteractive environment variable to disable prompts, which works seamlessly on Ubuntu as well. Update your remote-exec provisioner like this:

provisioner "remote-exec" {
  inline = [
    "export DEBIAN_FRONTEND=noninteractive",
    #"sudo apt-get update -y",
    #"sudo apt-get upgrade -y",
    "sudo apt-get install -y python3-pip",
    "cd /home/ubuntu",
    "sudo pip3 install flask",
    "nohup sudo python3 app.py &"
  ]
}
}
