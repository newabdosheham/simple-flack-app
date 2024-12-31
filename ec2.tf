resource "aws_instance" "server" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.example2.key_name
  vpc_security_group_ids = [aws_security_group.webSg.id]
  subnet_id              = aws_subnet.sub1.id

  user_data = <<-EOF
    #!/bin/bash
    set -e

    # Update system and install necessary packages
    apt-get update -y
    apt-get install -y software-properties-common python3 python3-pip python3-venv unzip

    # Create project directory and copy Flask app
    mkdir -p /home/ubuntu/templates
    echo "${app_py_content}" > /home/ubuntu/app.py
    echo "${index_html_content}" > /home/ubuntu/templates/index.html

    # Set up Python virtual environment
    python3 -m venv /home/ubuntu/flask_env
    source /home/ubuntu/flask_env/bin/activate
    pip install flask

    # Start the Flask app
    nohup python3 /home/ubuntu/app.py > /home/ubuntu/app.log 2>&1 &
  EOF

  tags = {
    Name = "Flask Server"
  }
}

# Local file reading for app.py content
locals {
  app_py_content = <<EOT
  ${file("./app.py")}
  EOT

  index_html_content = <<EOT
  ${file("./templates/index.html")}
  EOT
}

output "instance_ip" {
  value = aws_instance.server.public_ip
}
