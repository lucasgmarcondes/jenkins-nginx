#!/bin/bash

cd 08-jenkins/deploy-infra-img-java-app/terraform
curl "http://$(~/terraform output | grep public_dns | awk '{print $2;exit}')" | sed -e "s/\",//g"