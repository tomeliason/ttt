#!/usr/bin/env bash

rm -rf tf-export 

mkdir tf-export 

./terraform-provider-oci -command=export \
                         -compartment_id=ocid1.compartment.oc1..aaaaaaaaas357j3xdy5grl4dmotmtumrcopqxifuayurkowavjvzrmihfala \
                         -output_path=tf-export \
                         -generate_state

cd tf-export

terraform init
terraform destroy -auto-approve
