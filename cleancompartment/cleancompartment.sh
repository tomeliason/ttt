#!/usr/bin/env bash -ex

export TF_VAR_tenancy_ocid=$OCI_TENANCY

cd gbuocid

terraform init
terraform apply -auto-approve
export TF_VAR_compartment_id = `terraform output tenancycompartments`


rm -rf tf-export 

mkdir tf-export 

#./terraform-provider-oci -command=export \
#                         -#compartment_id=ocid1.compartment.oc1..aaaaaaaaas357j3xdy5grl4dmotmtumrcopqxifuayurkowavjvzrmihfala \
#                         -output_path=tf-export \
#                         -generate_state

#cd tf-export

#terraform init
#terraform destroy -auto-approve
