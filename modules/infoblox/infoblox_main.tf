resource "aws_instance" "vnios" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.security_group_ids
  key_name               = var.key_name # Optional: for SSH access
  private_ip             = var.private_ip # Optional: for static IP

  tags = merge(var.tags, {
    Name = "${var.name}-vnios"
  })

  network_interface {
    network_interface_id = aws_network_interface.eni.id
    device_index         = 0
  }
}

resource "aws_network_interface" "eni" {
  subnet_id       = var.subnet_id
  private_ip      = var.private_ip # Optional: for static IP
  security_groups = var.security_group_ids

  tags = merge(var.tags, {
    Name = "${var.name}-vnios-eni"
  })
}

resource "aws_eip" "vnios" {
  count        = var.allocate_eip ? 1 : 0
  vpc          = true
  network_interface = aws_network_interface.eni.id

  tags = merge(var.tags, {
    Name = "${var.name}-vnios-eip"
  })
}