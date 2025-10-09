terraform {
  required_providers { aws = { source = "hashicorp/aws", version = ">= 5.62" } }
}
provider "aws" { region = var.region }
variable "region" { type = string }
variable "bucket" { type = string }
variable "db" { type = string }

resource "aws_s3_bucket" "evidence" { bucket = var.bucket }
resource "aws_s3_bucket_versioning" "v" { bucket = aws_s3_bucket.evidence.id versioning_configuration { status="Enabled" } }

resource "aws_glue_catalog_database" "evidb" { name = var.db }
resource "aws_glue_catalog_table" "evi" {
  name          = "evidence_json"
  database_name = aws_glue_catalog_database.evidb.name
  table_type    = "EXTERNAL_TABLE"
  parameters = { classification="json" }
  storage_descriptor {
    location      = "s3://${aws_s3_bucket.evidence.bucket}/evidence/"
    input_format  = "org.apache.hadoop.mapred.TextInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"
    serde_info { serialization_library = "org.openx.data.jsonserde.JsonSerDe" }
    columns = [
      { name="kind", type="string" },
      { name="status", type="string" },
      { name="ts", type="string" }
    ]
  }
}
output "athena_table" { value = "${aws_glue_catalog_database.evidb.name}.${aws_glue_catalog_table.evi.name}" }
