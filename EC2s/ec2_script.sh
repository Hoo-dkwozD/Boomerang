#!/bin/bash

## EC2 App
apt update
apt install git -y
git clone https://github.com/Hoo-dkwozD/Boomerang-EC2.git

## EBS Volumes
set -eo
mkdir -p /ebs-mounted
mkfs -t ext3 /ebs-dev/sda1
mount -o loop /ebs-dev/sda1 /ebs-mounted
touch /ebs-mounted/my-test-file
