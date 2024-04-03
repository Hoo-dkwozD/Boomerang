#!/bin/sh

# awslocal wafv2 create-web-acl --name MainWebAcl --scope REGIONAL --default-action Allow={} --visibility-config SampledRequestsEnabled=true,CloudWatchMetricsEnabled=true,MetricName=TestWebAclMetrics

## EC2 Instances with EBS
# Uses another repository to create the AMI

awslocal iam create-instance-profile --instance-profile-name MainEC2Profile

awslocal iam create-role --role-name MainEC2Role --assume-role-policy-document file://./EC2s/EC2_IAM_role.json

policy_arn=$(awslocal iam create-policy --policy-name MainEC2Policy --policy-document file://./EC2s/EC2_IAM_policy.json | jq -r '.Policy.Arn')

awslocal iam attach-role-policy --role-name MainEC2Role --policy-arn $policy_arn

awslocal iam add-role-to-instance-profile --instance-profile-name MainEC2Profile --role-name MainEC2Role

awslocal ec2 create-key-pair --key-name ec2-key --query 'KeyMaterial' --output text | tee keys/Ec2PrivKey.pem

chmod 400 keys/Ec2PrivKey.pem

awslocal ec2 authorize-security-group-ingress --group-id default --protocol tcp --port 80 --cidr 0.0.0.0/0

sg_id=$(awslocal ec2 describe-security-groups | jq -r '.SecurityGroups[0].GroupId')

awslocal ec2 run-instances --image-id ami-ff0fea8310f3 --count 1 --instance-type t3.nano --key-name ec2-key --security-group-ids $sg_id --block-device-mapping '{"DeviceName":"/ebs-dev/sda1","Ebs":{"VolumeSize":10}}' --user-data file://./EC2s/ec2_script.sh --iam-instance-profile Name=MainEC2Profile

vpc_id=$(awslocal ec2 describe-vpcs | jq -r '.Vpcs[0].VpcId')

## ElastiCache

# sub_id1=$(awslocal ec2 create-subnet --vpc-id $vpc_id --cidr-block 172.31.100.0/20 --availability-zone us-east-1a | jq -r '.Subnet.SubnetId')

sub_id1=$(awslocal ec2 describe-subnets | jq -r '.Subnets[0].SubnetId')

# sub_id2=$(awslocal ec2 create-subnet --vpc-id $vpc_id --cidr-block 172.31.120.0/20 --availability-zone us-east-1b | jq -r '.Subnet.SubnetId')

sub_id2=$(awslocal ec2 describe-subnets | jq -r '.Subnets[1].SubnetId')

awslocal elasticache create-cache-subnet-group --cache-subnet-group-name cache-subnet-group --cache-subnet-group-description "Main ElastiCache Subnet Group" --subnet-ids $sub_id1 $sub_id2

awslocal elasticache create-replication-group --replication-group-id boomerang-redis-cache --replication-group-description 'boomerang cache' --engine redis --cache-node-type cache.t2.micro --num-cache-clusters 2 --cache-subnet-group-name cache-subnet-group

nacl_id1=$(awslocal ec2 create-network-acl --vpc-id $vpc_id | jq -r '.NetworkAcl.NetworkAclId')

nacl_id2=$(awslocal ec2 create-network-acl --vpc-id $vpc_id | jq -r '.NetworkAcl.NetworkAclId')

awslocal ec2 create-network-acl-entry --network-acl-id $nacl_id1 --ingress --rule-number 100 --protocol tcp --port-range From=4510,To=4510 --cidr-block 172.31.0.0/16 --rule-action allow

awslocal ec2 create-network-acl-entry --network-acl-id $nacl_id2 --ingress --rule-number 100 --protocol tcp --port-range From=4510,To=4510 --cidr-block 172.31.0.0/16 --rule-action allow

awslocal ec2 associate-network-acl --network-acl-id $nacl_id1 --subnet-id $sub_id1

awslocal ec2 associate-network-acl --network-acl-id $nacl_id2 --subnet-id $sub_id2

## RDS Tables

awslocal rds create-db-cluster --db-cluster-identifier db1 --engine mysql --database-name BoomerangElectronics --master-username root --master-user-password root

awslocal rds create-db-instance --db-instance-identifier db1-instance --db-cluster-identifier db1 --engine mysql --db-instance-class db.t3.large

## DynamoDB Tables

python3 DynamoDB/setup.py

## S3 Buckets

awslocal s3api create-bucket --bucket css-bucket

awslocal s3api put-bucket-acl --bucket css-bucket --acl public-read

for file in S3s/css/*; do
    awslocal s3api put-object --bucket css-bucket --key $file --body $file
done

awslocal s3api list-objects --bucket css-bucket

awslocal s3api put-bucket-policy --bucket css-bucket --policy file://./S3s/S3_css_policy.json

awslocal s3api create-bucket --bucket img-bucket

awslocal s3api put-bucket-acl --bucket img-bucket --acl public-read

for file in S3s/images/*; do
    awslocal s3api put-object --bucket img-bucket --key $file --body $file
done

awslocal s3api list-objects --bucket img-bucket

awslocal s3api put-bucket-policy --bucket img-bucket --policy file://./S3s/S3_images_policy.json

## S3 Glacier Buckets

# pass
