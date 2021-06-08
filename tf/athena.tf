resource "aws_athena_workgroup" "analyze" {
  name = "analyze-${random_id.rando.hex}"

  configuration {
    result_configuration {
      output_location = "s3://${aws_s3_bucket.resultbucket.id}/athena_output/"
      encryption_configuration {
        encryption_option = "SSE_S3"
      }
    }
  }
}

resource "aws_glue_catalog_table" "aws_glue_catalog_table" {
  name          = "glue${random_id.rando.hex}"
  database_name = aws_athena_database.analyze-db.id
}

resource "aws_athena_database" "analyze-db" {
  name   = "analyzeathenadb${random_id.rando.hex}"
  bucket = aws_s3_bucket.resultbucket.id
}

resource "aws_athena_named_query" "analyze-query" {
  name      = "query-${random_id.rando.hex}"
  workgroup = aws_athena_workgroup.analyze.id
  database  = aws_athena_database.analyze-db.name
  query     = "SELECT * FROM ${aws_athena_database.analyze-db.name} limit 10;"
}