resource "aws_docdb_subnet_group" "subnets" {
  subnet_ids = [data.aws_subnet.public-a.id, data.aws_subnet.public-b.id]
  name       = "default-ab"
}

resource "aws_docdb_cluster" "mycluster" {
  cluster_identifier = "mycluster"
  # Network settings
  db_subnet_group_name   = aws_docdb_subnet_group.subnets.id
  vpc_security_group_ids = [aws_security_group.documentdb.id]
  # Cluster settings
  engine          = "docdb"
  engine_version  = "4.0.0"
  master_username = "administrator"
  master_password = "Staple3-Battery2-Horse1"
}

resource "aws_docdb_cluster_instance" "myinstance" {
  cluster_identifier = aws_docdb_cluster.mycluster.id
  instance_class     = "db.t4g.medium"
  engine             = "docdb"
  identifier         = "myinstance"
}

output "host-port" {
  value = "${aws_docdb_cluster.mycluster.endpoint}:${aws_docdb_cluster.mycluster.port}"
}
