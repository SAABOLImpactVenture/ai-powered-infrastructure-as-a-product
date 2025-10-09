terraform {
  required_providers { aws = { source="hashicorp/aws", version=">= 5.62" } }
}
provider "aws" { region = var.region }

variable "region" { type=string }
variable "bucket" { type=string }
variable "db_name" { type=string, default="evidence" }
variable "table_name" { type=string, default="evidence_json" }

resource "aws_s3_bucket" "lake" { bucket = var.bucket }
resource "aws_s3_bucket_versioning" "v" { bucket = aws_s3_bucket.lake.id versioning_configuration { status="Enabled" } }
resource "aws_s3_bucket_server_side_encryption_configuration" "sse" {
  bucket = aws_s3_bucket.lake.id
  rule { apply_server_side_encryption_by_default { sse_algorithm = "AES256" } }
}

resource "aws_glue_catalog_database" "db" { name = var.db_name }

resource "aws_glue_catalog_table" "tbl" {
  name          = var.table_name
  database_name = aws_glue_catalog_database.db.name
  table_type    = "EXTERNAL_TABLE"
  parameters    = { "classification" = "json" }
  storage_descriptor {
    location      = "s3://${aws_s3_bucket.lake.bucket}/evidence/"
    input_format  = "org.apache.hadoop.mapred.TextInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"
    serde_info { serialization_library = "org.openx.data.jsonserde.JsonSerDe" }
    columns = [
      { name="kind", type="string" },
      { name="status", type="string" },
      { name="timestamp", type="string" },
      { name="source", type="string" },
      { name="path", type="string" },
      { name="details", type="string" }
    ]
  }
}

output "athena_query_example" {
  value = "SELECT status, count(*) FROM \""${aws_glue_catalog_database.db.name}\"".\"${aws_glue_catalog_table.tbl.name}\" GROUP BY status;"
}
