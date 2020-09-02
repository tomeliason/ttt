#!/bin/bash -ex
#########################################################################################################
#
# SCRIPT:            inittenancy.sh       
#
# inittenancy to create a GBU compartment and configure policies using terraform

echo 'inittenancy'

# obtain the tenancy OCID from the environment in the OIC Cloud Shell 
export TF_VAR_tenancy_ocid=$OCI_TENANCY

# change in to the directory to intialize the OCI Tenancy
cd ttt/inittenancy 

# execute terraform; initialize, apply to initialize the OCI Tenancy
terraform init
terraform plan
terraform apply -auto-approve

echo 'inittenancy - complete'


