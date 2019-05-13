#!/bin/bash 



exit 0 

export TF_VAR_aws_access_key=$AWS_ACCESS_KEY_ID
export TF_VAR_aws_secret_key=$AWS_SECRET_ACCESS_KEY
export TF_VAR_aws_pem=$HOME/Downloads/podcast.pem

echo "the AWS_PEM is ${TF_VAR_aws_pem}"

e=tmp/env.sh
mkdir -p $(dirname $e)
rm -rf $e 
echo "export RMQ_ADDRESS=${RMQ_ADDRESS}" >>  $e 
echo "export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" >>  $e 
echo "export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" >>  $e 

terraform destroy -input=false -auto-approve 
terraform apply -input=false -auto-approve 

rm -rf $e 