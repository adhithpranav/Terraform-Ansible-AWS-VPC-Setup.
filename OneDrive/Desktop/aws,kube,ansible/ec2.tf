resource "aws_instance" "etcd" {
  count         = 3
  ami           = "ami-0f918f7e67a3323f0" // Unbuntu 16.04 LTS HVM, EBS-SSD
  instance_type = "t2.micro"

  subnet_id                   = aws_subnet.sub_kubernetes.id
  private_ip                  = cidrhost("10.43.0.0/16", 10 + count.index)
  associate_public_ip_address = true

  availability_zone      = "ap-south-1a"
  vpc_security_group_ids = ["${aws_security_group.allow_all.id}"]
  key_name               = "LaptopKey"

  tags = {
    Owner           = "Adhith Pranav"
    Name            = "etcd-${count.index}"
    ansibleFilter   = "Kubernetes01"
    ansibleNodeType = "etcd"
    ansibleNodeName = "etcd${count.index}"
  }
}