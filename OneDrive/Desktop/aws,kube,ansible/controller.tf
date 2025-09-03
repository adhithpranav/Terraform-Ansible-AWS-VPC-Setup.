resource "aws_instance" "controller" {
  count         = 3
  ami           = "ami-0f918f7e67a3323f0" # Ubuntu AMI
  instance_type = "t2.micro"

  subnet_id                   = aws_subnet.sub_kubernetes.id
  private_ip                  = cidrhost("10.43.0.0/16", 5 + count.index)
  associate_public_ip_address = true
  availability_zone           = "ap-south-1a"
  vpc_security_group_ids      = ["${aws_security_group.allow_all.id}"]
  key_name                    = "LaptopKey" # Replace with your key pair name

  tags = {
    Owner           = "Adhith Pranav"
    Name            = "controller"
    ansibleFilter   = "Kubernetes01"
    ansibleNodeType = "controller"
    ansibleNodeName = "controller${count.index}"
  }
}
