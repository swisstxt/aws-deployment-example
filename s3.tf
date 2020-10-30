resource "aws_s3_bucket" "pipeline" {
  bucket = "bucket-${data.aws_caller_identity.current.account_id}-codepipeline-test"
  acl    = "private"
}
