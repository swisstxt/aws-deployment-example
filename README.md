# Basic AWS Deployment Pipeline

Some Terraform scripts for creating an infrastructure deployment pipeline on AWS.

This is a combination of an S3 bucket for artifacts, a CodeCommit repository for your deployment scripts,
a CodePipeline for launching builds, and a CodeBuild project for executing the build scripts.

Once you've set up command line AWS access, git-remote-codecommit and Terraform, you can get started right away:

```shell
terraform init
terraform plan -out=terraform.tfplan
terraform apply terraform.tfplan
```

After the CodeCommit repository is created, clone it and put the example build script inside:

```shell
git clone codecommit://MyTestRepository
cp buildspec.yml hello.sh MyTestRepository/
```

Once you commit, you should see the build pipeline trigger and display a nice "Hello, world!" message.

```shell
cd MyTestRepository
git add buildspec.yml hello.sh
git commit -m "Initial commit"
git push
```
