resource "aws_ssm_parameter" "insert_plenty" {
  name  = "/docdb/insert_plenty"
  type  = "String"
  value = file("insert_plenty.py")
}

resource "aws_ssm_parameter" "query_much" {
  name  = "/docdb/query_much"
  type  = "String"
  value = file("query_much.py")
}
