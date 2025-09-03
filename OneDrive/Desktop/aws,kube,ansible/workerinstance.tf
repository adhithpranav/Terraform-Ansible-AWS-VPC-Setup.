resource "aws_instance" "worker" {
  count         = 3
  ami           = "ami-0f918f7e67a3323f0" # Replace with a valid AMI ID
  instance_type = "t2.micro"              # Replace with your desired instance type
  key_name      = "LaptopKey"             # Replace with your key pair name
  subnet_id     = aws_subnet.sub_kubernetes.id
  private_ip    = cidrhost("10.43.0.0/16", 20 + count.index)

  tags = {
    Owner           = "Adhith Pranav"
    Name            = "worker-${count.index}"
    ansibleFilter   = "Kubernetes01"
    ansibleNodeType = "worker"
    ansibleNodeName = "worker${count.index}"
  }
}
