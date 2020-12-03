#!/bin/bash -ex

echo 'cleancompartment' 

# obtain the tenancy OCID from the environment in the OIC Cloud Shell 
export TF_VAR_tenancy_ocid=$OCI_TENANCY

oci iam compartment list --lifecycle-state ACTIVE --query 'data[*]|[*]."name"' --compartment-id-in-subtree true --output table
read -p "select compartment you wish to clean: " compartment_name

echo ${compartment_name}
export TF_VAR_compartment_name=${compartment_name}

echo $TF_VAR_tenancy_ocid

echo 'cleancompartment - getting compartment ocid' 

# change in to the directory to get the GBU compartment OCID
cd ttt/cleancompartment/gbuocid

# execute terraform; initialize, apply to retrieve the GBU compartment OCID
terraform init
terraform apply -auto-approve
export TF_VAR_compartment_id=`terraform output tenancycompartments`

# cleanup the temporary terraform directory
rm -rf .terraform

# move up a directory
cd .. 

pwd 

echo "cleancompartment - removing objects from buckets"

# delete all objects from buckets before terraform deletes the buckets 

array=( ` oci os bucket list --compartment-id  $TF_VAR_compartment_id --query 'data[*]|[*]."name"' `) 


for i in "${array[@]}"
do
	echo $i
    oci os object bulk-delete -bn $i --force
done 

echo 'cleancompartment - removing any existing tf-export' 

# cleanup any existing export directory and recreate it
rm -rf tf-export 
mkdir tf-export 

# initialize terraform to get the provider
terraform init

echo 'cleancompartment - finding the terraform provider ' 

# find the provider executable and put it in a variable; the export command applies directly to a provider
export TPO=`find . -name *terraform-provider-oci*.*`

echo 'cleancompartment - terraform provider ' 
echo $TPO 

# execute eval for the export, pass in the compartment, and generate a state
eval $TPO -command=export \
                         -compartment_id=$TF_VAR_compartment_id \
                         -output_path=tf-export \
                         -generate_state

echo 'cleancompartment - moving into tf-export to adjust some resources' 

# change into the export directory; the terraform state is there
cd tf-export

pwd 

# initialize terraform in this directory, and destroy what was exported in the GBU compartment
terraform init

echo "cleancompartment take tag namespaces out of state since they need to be retired separately " 

# remove tag namespaces since they can only be retired 

arr=( ` terraform state list|grep oci_identity_tag_namespace ` )

for i in "${arr[@]}"
do
	echo $i
    terraform state rm $i
done

echo 'cleancompartment - remove bucket objects, they cannot be destroyed with terraform' 

# remove bucket objects since they have to be pre-deleted before the bucket, and the oci cli command to delete them will eventually remove the objects  
arr=( `terraform state list|grep oci_objectstorage_object` )

for i in "${arr[@]}"
do
	echo $i
    terraform state rm $i
done

echo 'cleancompartment - terraform destroy' 

terraform destroy -auto-approve

echo 'cleancompartment complete'

