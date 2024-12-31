resource "aws_instance" "server" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name      = aws_key_pair.example2.key_name
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

   # File provisioner to copy a file from local to the remote EC2 instance
   provisioner "file" {
    source      = "./templates/index.html"  # Replace with the path to your local file
    destination = "/home/ubuntu/templates/index.html"  # Replace with the path on the remote instance
   }


provisioner "remote-exec" {
  inline = [
      "cd /home/ubuntu",
    "sudo apt install -y software-properties-common",
    "sudo add-apt-repository universe -y",
    "sudo apt install -y python3 python3-pip python3-venv",
    "python3 -m venv /home/ubuntu/flask_env",
    "source /home/ubuntu/flask_env/bin/activate && pip install flask",
    "nohup python3 /home/ubuntu/app.py > app.log 2>&1 &"
  ]
 

}
}
