resource "aws_security_group" "master-nodes" {
  name        = "tf-master-nodes"
  description = "Enable mandatory communication between worker nodes"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name = "tf-master-nodes"
  }
}

resource "aws_security_group_rule" "all_tcp_master_nodes" {
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  security_group_id = aws_security_group.master-nodes.id
  source_security_group_id = aws_security_group.worker-nodes.id
}

resource "aws_security_group_rule" "all_udp_master_nodes" {
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "udp"
  security_group_id = aws_security_group.master-nodes.id
  source_security_group_id = aws_security_group.worker-nodes.id
}

resource "aws_security_group_rule" "ssh_master_nodes" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.master-nodes.id
}


resource "aws_security_group_rule" "all_internal_master_nodes" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "all"
  security_group_id = aws_security_group.master-nodes.id
  self              = true
}
