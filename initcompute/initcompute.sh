#!/bin/bash -ex

echo 'initcompute' 

# obtain the tenancy OCID from the environment in the OIC Cloud Shell 
export TF_VAR_tenancy_ocid=$OCI_TENANCY

echo 'working in tenancy ' `oci iam tenancy get --tenancy-id $OCI_TENANCY --query 'data."name"' --output json  `

oci iam compartment list --lifecycle-state ACTIVE --query 'data[*]|[*]."name"' --compartment-id-in-subtree true --output table
read -p "enter the compartment to create compute with oSSH: " compartment_name

echo ${compartment_name}
export TF_VAR_compartment_name=${compartment_name}

#echo $TF_VAR_tenancy_ocid

# change in to the directory to get the GBU compartment OCID
cd ttt/initcompute/gbuocid

rm -rf .terraform.d 
rm -rf .terraform
rm -rf terraform.tfstate
rm -rf terraform.tfstate.*
rm -rf .terraform.tfstate.*

# execute terraform; initialize, apply to retrieve the GBU compartment OCID
terraform init
terraform apply -auto-approve
export TF_VAR_compartment_id=`terraform output tenancycompartments`

# cleanup the temporary terraform directory
rm -rf .terraform

# move up a directory
cd ../
pwd 

# get the most recent Oracle Linux 7 image 
export instance_image_id=`oci compute image list --compartment-id $TF_VAR_tenancy_ocid --sort-order DESC --sort-by TIMECREATED --query "data[?contains(\"display-name\", 'Oracle-Linux-7')].\"id\"" | awk -F '"' '{print $2}' | awk 'NF' | sed -n '1p'`

rm -rf .terraform.d 
rm -rf .terraform
rm -rf terraform.tfstate
rm -rf terraform.tfstate.*
rm -rf .terraform.tfstate.*

# initialize terraform to get the provider
terraform init

terraform plan 

# execute the terraform by applying and auto-approve

terraform apply -auto-approve

echo 'initcompute complete'

