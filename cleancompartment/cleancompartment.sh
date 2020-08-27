#!/bin/bash -ex

echo 'cleancompartment' 

export TF_VAR_tenancy_ocid=$OCI_TENANCY

cd ttt/cleancompartment/gbuocid

terraform init
terraform apply -auto-approve
export TF_VAR_compartment_id=`terraform output tenancycompartments`

rm -rf .terraform

cd .. 

pwd 

rm -rf tf-export 

mkdir tf-export 

terraform init

export TPO=`find . -name *terraform-provider-oci*.*`

eval $TPO -command=export \
                         -compartment_id=$TF_VAR_compartment_id \
                         -output_path=tf-export \
                         -generate_state

cd tf-export

terraform init
terraform destroy -auto-approve

echo 'cleancompartment complete'

