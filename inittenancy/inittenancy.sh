#!/bin/bash -ex
#########################################################################################################
#
# SCRIPT:            inittenancy.sh       
#
# inittenancy to create a GBU compartment and configure policies using terraform

echo 'inittenancy'

export TF_VAR_tenancy_ocid=$OCI_TENANCY

cd ttt/inittenancy 

terraform init

terraform plan

terraform apply -auto-approve

echo 'inittenancy - complete'


