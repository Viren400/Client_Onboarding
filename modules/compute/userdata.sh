#!/bin/bash

dnf update -y

dnf install -y httpd

systemctl enable httpd

systemctl start httpd

TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" \
-H "X-aws-ec2-metadata-token-ttl-seconds: 21600")

INSTANCE_ID=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" \
http://169.254.169.254/latest/meta-data/instance-id)

HOSTNAME=$(hostname)

echo "<html>" > /var/www/html/index.html
echo "<h1>Client Onboarding Platform</h1>" >> /var/www/html/index.html
echo "<h2>Client : ${client_name}</h2>" >> /var/www/html/index.html
echo "<h3>Hostname : $HOSTNAME</h3>" >> /var/www/html/index.html
echo "<h3>Instance : $INSTANCE_ID</h3>" >> /var/www/html/index.html
echo "</html>" >> /var/www/html/index.html

dnf install -y amazon-efs-utils

mkdir /shared-data

mount -t efs fs-xxxxxxxx:/ /shared-data