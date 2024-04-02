#!/bin/sh

# awslocal wafv2 create-web-acl --name MainWebAcl --scope REGIONAL --default-action Allow={} --visibility-config SampledRequestsEnabled=true,CloudWatchMetricsEnabled=true,MetricName=TestWebAclMetrics

# EC2 Instances

awslocal ec2 create-key-pair --key-name ec2-key --query 'KeyMaterial' --output text | tee Ec2PrivKey.pem

chmod 400 Ec2PrivKey.pem

awslocal ec2 authorize-security-group-ingress --group-id default --protocol tcp --port 80 --cidr 0.0.0.0/0

sg_id=$(awslocal ec2 describe-security-groups | jq -r '.SecurityGroups[0].GroupId')

awslocal ec2 run-instances --image-id ami-ff0fea8310f3 --count 1 --instance-type t3.nano --key-name ec2-key --security-group-ids $sg_id
