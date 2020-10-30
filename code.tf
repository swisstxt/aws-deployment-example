resource "aws_codecommit_repository" "test" {
  repository_name = "MyTestRepository"
  description     = "This is a simple test repository"
}

resource "aws_codebuild_project" "test" {
  name          = "MyTestProject"
  build_timeout = "10"
  service_role  = aws_iam_role.build.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:1.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
  }

  source {
    type            = "CODEPIPELINE"
  }
}

resource "aws_codepipeline" "test" {
  name     = "MyTestPipeline"
  role_arn = aws_iam_role.pipeline.arn

  artifact_store {
    location = aws_s3_bucket.pipeline.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      output_artifacts = ["source_output"]
      configuration = {
        RepositoryName = aws_codecommit_repository.test.repository_name
        BranchName     = "master"
        # not recommended, see docs.aws.amazon.com/codepipeline/latest/userguide/update-change-detection.html#update-change-detection-cli-codecommit
        PollForSourceChanges = true
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"

      configuration = {
        ProjectName = aws_codebuild_project.test.name
      }
    }
  }
}
