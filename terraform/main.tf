locals {
  name   = "complete-oracle"
  region = "eu-west-1"
  tags = {
    owner= var.tag_name // change back if needed
    Name="OracleToMongo"
    purpose="other"
    expire-on="2023-04-09" # YYYY-MM-DD
  }
}