#!/bin/sh

## KMS

kms_key_id=$(awslocal kms create-key | jq -r '.KeyMetadata.KeyId')

## ACM

cert_arn=$(awslocal acm request-certificate --domain-name www.boomerangelectronics.com --validation-method DNS --idempotency-token 1234 --options CertificateTransparencyLoggingPreference=DISABLED | jq -r '.CertificateArn')

## WAF

# awslocal wafv2 create-web-acl --name MainWebAcl --scope REGIONAL --default-action Allow={} --visibility-config SampledRequestsEnabled=true,CloudWatchMetricsEnabled=true,MetricName=TestWebAclMetrics

## ELB

vpc_id=$(awslocal ec2 describe-vpcs | jq -r '.Vpcs[0].VpcId')

sub_id1=$(awslocal ec2 describe-subnets | jq -r '.Subnets[0].SubnetId')

loadBalancer=$(awslocal elbv2 create-load-balancer --name main-lb --subnets $sub_id1 | jq -r '.LoadBalancers[]|.LoadBalancerArn')

targetGroup=$(awslocal elbv2 create-target-group --name main-target-group --protocol HTTP --target-type ip --port 80 --vpc-id $vpc_id | jq -r '.TargetGroups[].TargetGroupArn')

## EC2 Instances with EBS
# Uses another repository to supply the code for the instance

awslocal iam create-instance-profile --instance-profile-name MainEC2Profile

awslocal iam create-role --role-name MainEC2Role --assume-role-policy-document file://./EC2s/EC2_IAM_role.json

policy_arn=$(awslocal iam create-policy --policy-name MainEC2Policy --policy-document file://./EC2s/EC2_IAM_policy.json | jq -r '.Policy.Arn')

awslocal iam attach-role-policy --role-name MainEC2Role --policy-arn $policy_arn

awslocal iam add-role-to-instance-profile --instance-profile-name MainEC2Profile --role-name MainEC2Role

awslocal ec2 create-key-pair --key-name ec2-key --query 'KeyMaterial' --output text | tee keys/Ec2PrivKey.pem

# awslocal kms encrypt --key-id $kms_key_id --plaintext fileb://keys/Ec2PrivKey.pem --output text --query CiphertextBlob | base64 --decode > keys/Ec2PrivKey.enc

# rm keys/Ec2PrivKey.pem

chmod 400 keys/Ec2PrivKey.pem

awslocal ec2 authorize-security-group-ingress --group-id default --protocol tcp --port 80 --cidr 0.0.0.0/0

sg_id=$(awslocal ec2 describe-security-groups | jq -r '.SecurityGroups[0].GroupId')

ec2_id=$(awslocal ec2 run-instances --image-id ami-ff0fea8310f3 --count 1 --instance-type t3.nano --key-name ec2-key --security-group-ids $sg_id --block-device-mapping '{"DeviceName":"/ebs-dev/sda1","Ebs":{"VolumeSize":10}}' --user-data file://./EC2s/ec2_script.sh --iam-instance-profile Name=MainEC2Profile | jq -r '.Instances[0].InstanceId')

awslocal elbv2 register-targets --target-group-arn $targetGroup --targets Id=$ec2_id

listenerArn=$(awslocal elbv2 create-listener --default-actions '{"Type":"forward","TargetGroupArn":"'$targetGroup'","ForwardConfig":{"TargetGroups":[{"TargetGroupArn":"'$targetGroup'","Weight":11}]}}' --load-balancer-arn $loadBalancer | jq -r '.Listeners[]|.ListenerArn')

awslocal elbv2 create-rule --conditions Field=path-pattern,Values=/ --priority 1 --actions '{"Type":"forward","TargetGroupArn":"'$targetGroup'","ForwardConfig":{"TargetGroups":[{"TargetGroupArn":"'$targetGroup'","Weight":11}]}}' --listener-arn $listenerArn

## ElastiCache

# sub_id2=$(awslocal ec2 create-subnet --vpc-id $vpc_id --cidr-block 172.31.100.0/20 --availability-zone us-east-1a | jq -r '.Subnet.SubnetId')

sub_id2=$(awslocal ec2 describe-subnets | jq -r '.Subnets[1].SubnetId')

# sub_id3=$(awslocal ec2 create-subnet --vpc-id $vpc_id --cidr-block 172.31.120.0/20 --availability-zone us-east-1b | jq -r '.Subnet.SubnetId')

sub_id3=$(awslocal ec2 describe-subnets | jq -r '.Subnets[2].SubnetId')

awslocal elasticache create-cache-subnet-group --cache-subnet-group-name cache-subnet-group --cache-subnet-group-description "Main ElastiCache Subnet Group" --subnet-ids $sub_id2 $sub_id3

awslocal elasticache create-replication-group --replication-group-id boomerang-redis-cache --replication-group-description 'boomerang cache' --engine redis --cache-node-type cache.t2.micro --num-cache-clusters 2 --cache-subnet-group-name cache-subnet-group

nacl_id1=$(awslocal ec2 create-network-acl --vpc-id $vpc_id | jq -r '.NetworkAcl.NetworkAclId')

nacl_id2=$(awslocal ec2 create-network-acl --vpc-id $vpc_id | jq -r '.NetworkAcl.NetworkAclId')

awslocal ec2 create-network-acl-entry --network-acl-id $nacl_id1 --ingress --rule-number 100 --protocol tcp --port-range From=4510,To=4510 --cidr-block 172.31.0.0/16 --rule-action allow

awslocal ec2 create-network-acl-entry --network-acl-id $nacl_id2 --ingress --rule-number 100 --protocol tcp --port-range From=4510,To=4510 --cidr-block 172.31.0.0/16 --rule-action allow

awslocal ec2 associate-network-acl --network-acl-id $nacl_id1 --subnet-id $sub_id2

awslocal ec2 associate-network-acl --network-acl-id $nacl_id2 --subnet-id $sub_id3

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

awslocal glacier create-vault --vault-name storage-vault --account-id -

awslocal glacier set-vault-access-policy --vault-name storage-vault --policy file://./S3s/S3_glacier_policy.json
