#!/bin/bash -ex
#########################################################################################################
#
# SCRIPT:            initcompartment.sh       
#
# initcompartment to prompt for a compartment name, create the compartment and configure policies using terraform

echo 'initcompartment'

# obtain the tenancy OCID from the environment in the OIC Cloud Shell 
export TF_VAR_tenancy_ocid=$OCI_TENANCY

read -p "enter the name of the compartment you wish to create: " compartment_name

echo ${compartment_name}
export TF_VAR_compartment_name=${compartment_name}

# determine if the dynamic group TIMS-oSSH exists 
idgroup=$(oci iam dynamic-group list --lifecycle-state ACTIVE --query "data[?\"name\" == 'TIMS-oSSH'].name")

#if the dynamic group TIMS-oSSH doesnt exist, create it

if [ -z "$idgroup" ]
then 
    # change in to the directory to create the TIMS-oSSH dynamic group for the OCI Tenancy
    cd ttt/initcompartment/timsossh-dynamicgroup

    # execute terraform; initialize, apply to create the TIMS-oSSH dynamic group for the OCI Tenancy
    terraform init
    terraform plan
    terraform apply -auto-approve

    echo 'created dynamic group TIMS-oSSH for the OCI tenancy' 
else
    echo 'dynamic group TIMS-oSSH already exists in this OCI tenancy'
fi 

# determine if the identity policy TIMS-oSSH exists 
ipolicy=$(oci iam policy list --compartment-id $OCI_TENANCY --lifecycle-state ACTIVE --query "data[?\"name\" == 'TIMS-oSSH'].name")

# if identity policy TIMS-oSSH  doesnt exist, create it

if [ -z "$ipolicy" ]
then 
    # change in to the directory to create the TIMS-oSSH dynamic group for the OCI Tenancy
    cd ttt/initcompartment/timsossh-dynamicgroup

    # execute terraform; initialize, apply to create the TIMS-oSSH dynamic group for the OCI Tenancy
    terraform init
    terraform plan
    terraform apply -auto-approve
    echo 'created policy TIMS-oSSH for the OCI tenancy' 
else
    echo 'policy TIMS-oSSH already exists in this OCI tenancy'
fi 

# change in to the directory to intialize the OCI Tenancy
cd ttt/initcompartment 

# execute terraform; initialize, apply to initialize the OCI Tenancy
terraform init
terraform plan
terraform apply -auto-approve

echo 'initcompartment - complete - for compartment ' ${compartment_name}


