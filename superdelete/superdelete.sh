#!/bin/bash -ex

echo 'super delete - cleancompartment' 

# obtain the tenancy OCID from the environment in the OIC Cloud Shell 
export TF_VAR_tenancy_ocid=$OCI_TENANCY

oci iam compartment list --lifecycle-state ACTIVE --query 'data[*]|[*]."name"' --compartment-id-in-subtree true --output table
read -p "select compartment you wish to clean: " compartment_name

echo ${compartment_name}
export TF_VAR_compartment_name=${compartment_name}

echo $TF_VAR_tenancy_ocid

echo 'super delete - cleancompartment - getting compartment ocid' 

# change in to the directory to get the GBU compartment OCID
cd ttt/cleancompartment/gbuocid

# execute terraform; initialize, apply to retrieve the GBU compartment OCID
terraform init
terraform apply -auto-approve
export TF_VAR_compartment_id=`terraform output tenancycompartments`

# cleanup the temporary terraform directory
rm -rf .terraform

# move up a directory
cd ../.. 

# move into the super delete directory
cd superdelete 

pwd 

echo "super delete - cleancompartment - executing python script"

python3 delete.py -c $TF_VAR_compartment_id 

terraform destroy -auto-approve

echo 'super delete - cleancompartment complete'

