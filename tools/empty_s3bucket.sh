#!/bin/bash

S3BucketName=$1

function checkS3BucketProperty {
    resultStatus="$(aws s3api list-object-versions \
        --bucket "$1" \
        --output=json \
        --query='{Objects: '"$2"'[].{Key:Key,VersionId:VersionId}}')"
    parsedResultStatus=$(echo "${resultStatus}" | jq -r '.Objects')
    if [[ ${parsedResultStatus} == "null" ]]; then
        echo "null"
    else
        echo "not null"
    fi
}

function s3-delete-objects {
    echo -e "\nDeleting $2 from $1 bucket name\n"
    aws s3api delete-objects --bucket "$1" \
    --delete "$(aws s3api list-object-versions \
    --bucket "$1" \
    --query='{Objects: '"$2"'[].{Key:Key,VersionId:VersionId}}')"
}

versionResult=$(checkS3BucketProperty ${S3BucketName} "Versions")
if [[ "$versionResult" == "not null" ]]; then
    s3-delete-objects ${S3BucketName} "Versions"
fi

deleteMarkerResult=$(checkS3BucketProperty ${S3BucketName} "DeleteMarkers")
if [[ "$deleteMarkerResult" == "not null" ]]; then
    s3-delete-objects ${S3BucketName} "DeleteMarkers"
fi
