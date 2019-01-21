# Intro

This is just a start.  It currently only creates the master node for a locust application.
Work still needs to be done to create the slave cluster which points back to the master env's
`EndpointURL`.  I think all of that can be done by building on the CloudFormation template.

# Setting Up

Create the S3 bucket used to store the package zip.  
The Cloudformation template looks for a bucket named `locust-<AWSAccountId>`.

```bash
aws s3 mb s3://locust-975590397174
```

# Building
```bash
git archive -v -o locust.zip --format=zip HEAD
```

```bash
aws s3 cp locust.zip s3://locust-975590397174/
```

# Deploying
```bash
aws cloudformation create-stack --stack-name locust \
  --template-body file://$PWD/template.yaml \
  --parameters ParameterKey=TargetUrl,ParameterValue=http://www.google.com \
    ParameterKey=LocustFilePath,ParameterValue=/locust/locustfile.py \
  --on-failure DELETE \
  --capabilities CAPABILITY_IAM
```

Check the status of the stack.
```bash
aws cloudformation describe-stacks --stack-name locust
```

Copy the `OutputValue` from the `EndpointURL` output key. Open that sucker up in a browser.

You should see 
# Cleaning up
Teardown the application
```bash
aws cloudformation delete-stack --stack-name locust
```

Delete the contents of the bucket

```bash
aws rm s3://locust-975590397174/ --recursive
```