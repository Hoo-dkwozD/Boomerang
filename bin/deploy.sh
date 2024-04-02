#!/bin/sh

# awslocal wafv2 create-web-acl --name MainWebAcl --scope REGIONAL --default-action Allow={} --visibility-config SampledRequestsEnabled=true,CloudWatchMetricsEnabled=true,MetricName=TestWebAclMetrics

## EC2 Instances with EBS
# Uses another repository to create the AMI

awslocal ec2 create-key-pair --key-name ec2-key --query 'KeyMaterial' --output text | tee keys/Ec2PrivKey.pem

chmod 400 keys/Ec2PrivKey.pem

awslocal ec2 authorize-security-group-ingress --group-id default --protocol tcp --port 80 --cidr 0.0.0.0/0

sg_id=$(awslocal ec2 describe-security-groups | jq -r '.SecurityGroups[0].GroupId')

awslocal ec2 run-instances --image-id ami-ff0fea8310f3 --count 1 --instance-type t3.nano --key-name ec2-key --security-group-ids $sg_id --block-device-mapping '{"DeviceName":"/ebs-dev/sda1","Ebs":{"VolumeSize":10}}' --user-data file://./EC2s/ec2_script.sh

## ElastiCache

awslocal elasticache create-replication-group --replication-group-id boomerang-redis-cache --replication-group-description 'boomerang cache' --engine redis --cache-node-type cache.t2.micro --num-cache-clusters 2

## S3 Buckets

awslocal s3api create-bucket --bucket css-bucket

for file in S3s/css/*; do
    awslocal s3api put-object --bucket css-bucket --key $file --body $file
done

awslocal s3api list-objects --bucket css-bucket

awslocal s3api create-bucket --bucket img-bucket

for file in S3s/images/*; do
    awslocal s3api put-object --bucket img-bucket --key $file --body $file
done

awslocal s3api list-objects --bucket img-bucket

## S3 Glacier Buckets

# pass

## DynamoDB Tables

# pass
