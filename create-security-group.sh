#!/bin/bash

aws ec2 create-security-group --group-name "will-it-scale-sg" --description "Security Group used for demo purposes, allows SSH, HTTP, HTTPS, and 5000"
aws ec2 authorize-security-group-ingress --group-name "will-it-scale-sg" --protocol tcp --port 22 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-name "will-it-scale-sg" --protocol tcp --port 80 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-name "will-it-scale-sg" --protocol tcp --port 443 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-name "will-it-scale-sg" --protocol tcp --port 3306 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-name "will-it-scale-sg" --protocol tcp --port 5000 --cidr 0.0.0.0/0