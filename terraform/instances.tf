locals {
  nginx_private_ip = aws_instance.nginx.private_ip
}

resource "aws_instance" "bastion" {
  ami                         = var.bastion_ami
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [module.allow_http_sg.security_group_id]
  subnet_id                   = module.vpc.public_subnets[0]
  associate_public_ip_address = true
  user_data                   = <<-EOF
              #!/bin/bash
              sudo yum install -y nginx
              sudo systemctl start nginx
              sudo systemctl enable nginx
              PUBLIC_IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)
              cat << 'EOF_NGINX' | sudo tee /etc/nginx/conf.d/default.conf
              server {
                  listen 80;
                  server_name $PUBLIC_IP;
                  location / {
                      proxy_pass http://${local.nginx_private_ip}:80;
                      proxy_set_header Host \$host;
                      proxy_set_header X-Real-IP \$remote_addr;
                      proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
                      proxy_set_header X-Forwarded-Proto \$scheme;
                  }
              }
              EOF_NGINX
              sudo systemctl restart nginx
              EOF

  tags = {
    Name      = var.bastion_instance_name
    Terraform = "true"
  }
}

resource "aws_instance" "nginx" {
  ami                    = var.custom_ami
  instance_type          = "t2.micro"
  vpc_security_group_ids = [module.allow_bastion_sg.security_group_id]
  subnet_id              = module.vpc.private_subnets[0]
  user_data              = <<-EOF
              #!/bin/bash
              sudo yum install -y docker
              sudo systemctl start docker
              sudo systemctl enable docker
              sudo docker run --name yo-nginx -d -p 80:80 glengold/nginx:latest
              EOF

  tags = {
    Name      = var.nginx_instance_name
    Terraform = "true"
  }
}
#