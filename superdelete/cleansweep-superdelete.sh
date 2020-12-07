#!/bin/bash -ex

echo 'super delete - cleansweep' 

# obtain the tenancy OCID from the environment in the OIC Cloud Shell 
export TF_VAR_tenancy_ocid=$OCI_TENANCY

# move into the super delete directory
cd ttt/superdelete 

pwd 

echo "super delete - cleansweep - executing python script"

python3 delete.py -c $TF_VAR_tenancy_ocid  

terraform destroy -auto-approve

echo 'super delete - cleansweep complete'

