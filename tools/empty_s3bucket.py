#!/usr/bin/env python
import sys
import boto3

S3BucketName = sys.argv[1]

s3 = boto3.resource('s3')
bucket = s3.Bucket(S3BucketName)

print(f"Deleting objects and versions from {S3BucketName}")
bucket.object_versions.all().delete()
