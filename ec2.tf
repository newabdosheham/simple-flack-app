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

#provisioner "remote-exec" {
 # inline = [
 #   "export DEBIAN_FRONTEND=noninteractive",
 #   "curl -O https://bootstrap.pypa.io/get-pip.py",
 #   "sudo python3 get-pip.py",
 #   "cd /home/ubuntu",
 #   "pip3 install flask --break-system-packages",
  #  "nohup sudo python3 app.py &"
  #]
#}
  # User data script to install Flask
  user_data = <<-EOT
    #!/bin/bash
    # Update package list
    sudo apt update -y
    
    # Install Python and pip
    sudo apt install -y python3 python3-pip python3-venv
    
    # Create a virtual environment
    #mkdir /home/ubuntu/flask_app
    #cd /home/ubuntu/flask_app
    python3 -m venv flask_env
    
    # Activate the virtual environment and install Flask
    source flask_env/bin/activate
    pip install Flask

    # Create a basic Flask app
    cat <<EOF > /home/ubuntu/app.py
    from flask import Flask

    app = Flask(__name__)

    @app.route('/')
    def home():
        return "Hello, Flask on Ubuntu!"

    if __name__ == "__main__":
        app.run(host='0.0.0.0', port=5000)
    EOF

    # Run the Flask app in the background
    nohup flask_env/bin/python /home/ubuntu/app.py &
  EOT

  tags = {
    Name = "FlaskServer"
  }
}
}
