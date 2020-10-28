#!/bin/bash 

echo 'cleansweep' 

# obtain the tenancy OCID from the environment in the OIC Cloud Shell 
export TF_VAR_tenancy_ocid=$OCI_TENANCY

# array of identity objects that belong to user who created the tenancy 

declare -a userid=("oci_identity_api_key.export_jerry-mabry-oracle-com_api_key_1" 
                   "oci_identity_api_key.export_oracleidentitycloudservice-tom-eliason-oracle-com_api_key_1"
                   "oci_identity_api_key.export_oracleidentitycloudservice-jerry-mabry-oracle-com_api_key_1"
                   "oci_identity_authentication_policy.export_authentication_policy"
                   "oci_identity_compartment.export_ManagedCompartmentForPaaS"
                   "oci_identity_group.export_Administrators"
                   "oci_identity_identity_provider.export_OracleIdentityCloudService"
                   "oci_identity_idp_group_mapping.export_OracleIdentityCloudService_idp_group_mapping_1"
                   "oci_identity_policy.export_PSM-mgd-comp-policy"
                   "oci_identity_policy.export_PSM-root-policy"
                   "oci_identity_policy.export_Tenant-Admin-Policy"
                   "oci_identity_user.export_jerry-mabry-oracle-com"
                   "oci_identity_user.export_oracleidentitycloudservice-jerry-mabry-oracle-com"
                   "oci_identity_user.export_oracleidentitycloudservice-tom-eliason-oracle-com"
                   "oci_identity_user_group_membership.export_jerry-mabry-oracle-com_user_group_membership_1"
                   ) 

for i in "${userid[@]}"
do
   echo "$i"
   # or do whatever with individual element of the array
done 

# cleanup any existing export directories
rm -rf tf-export 
rm -rf tf-export-compartment 
rm -rf tf-export-id 

# initialize terraform to get the provider
terraform init

# find the provider executable and put it in a variable; the export command applies directly to a provider
export TPO=`find . -name *terraform-provider-oci*.*`

# create the identity export directory
mkdir tf-export-id 

# execute eval for the export, pass in the compartment, and generate a state
eval $TPO -command=export -compartment_id=$TF_VAR_tenancy_ocid -output_path=tf-export-id -services=identity -generate_state

# change into the export directory; the terraform state is there
cd tf-export-id

# initialize terraform in this directory
terraform init

for i in "${userid[@]}"
do
   echo "$i"
   terraform state rm $i 
done

arr=( `terraform show -json | jq -r '.values[].resources[] | select(.type=="oci_identity_compartment") | .values.id'` )

for i in "${arr[@]}"
do
	echo $i
    # delete all objects from buckets before terraform deletes the buckets 

    array=( ` oci os bucket list --compartment-id  $i --query 'data[*]|[*]."name"' --output json | awk -F '"' '{print $2}' | awk 'NF' ` )

    for j in "${array[@]}"
    do
	    echo $j
        oci os object bulk-delete -bn $j --force
    done 

done

arr=( `terraform show -json | jq -r '.values[].resources[] | select(.type=="oci_identity_compartment") | .values.id'` )

cd .. 

for i in "${arr[@]}"
do
	echo $i
    # delete all resources in the compartments 

    # cleanup any previous export
    rm -rf tf-export-compartment 

    # pre-create the export directory
    mkdir tf-export-compartment 

    # execute eval for the export, pass in the compartment, and generate a state
    eval $TPO -command=export -compartment_id=$i -output_path=tf-export-compartment -generate_state

    cd tf-export-compartment 
    terraform init

    # remove tag namespaces since they can only be retired 
    arr=( `terraform state list|grep compartment` )

    for i in "${arr[@]}"
    do
	    echo $i
        terraform state rm $i
    done

    echo "terraform would destroy in compartment $i"
    terraform state list 
    terraform destroy -auto-approve

    cd ..

done

# cleanup any leftover tf-export
rm -rf tf-export 

# pre-create the tf-export directory 
mkdir tf-export 

# execute eval for the export, pass in the compartment, and generate a state
eval $TPO -command=export -compartment_id=$TF_VAR_tenancy_ocid -output_path=tf-export -generate_state

cd tf-export
terraform init 

# remove original user identity objects 
for i in "${userid[@]}"
do
   echo "$i"
   terraform state rm $i 
done 

# remove tag namespaces since they can only be retired 
arr=( `terraform state list|grep oci_identity_tag_namespace` )

for i in "${arr[@]}"
do
	echo $i
    terraform state rm $i
done

# remove bucket objects since they have to be pre-deleted before the bucket, and the oci cli command to delete them will eventually remove the objects  
arr=( `terraform state list|grep oci_objectstorage_object` )

for i in "${arr[@]}"
do
	echo $i
    terraform state rm $i
done

echo "terraform would destroy in compartment $TF_VAR_tenancy_ocid "
terraform state list 

terraform destroy -auto-approve

echo 'cleansweep complete'
