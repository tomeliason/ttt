# GBU T3 (TTT) Utility Scripts 

## Introduction

This is a set of utility scripts implemented to support the GBU T3 program, documented at https://gbuconfluence.us.oracle.com/display/CDSMS/GBU+T3+%28Tech%2C+Trial+and+Test%29+OCI+Tenancies 

## Assumptions 

* This set of scripts is intended/assumed to be running within the CloudShell environment. 
* To execute these scripts outside of CloudShell, see the section below for using env.sh 

### Using env.sh instead of CloudShell 

#### Prerequisites 

* A Linux machine/environment is assumed in these steps - using Windows is possible, but has not been tested 
* Create an OCI API Key, and register that API key with your OCI User 
* Note the API key location, API key fingerprint, and OCI tenancy region
* Obtain the OCI Tenancy OCID and the OCI User OCID 
* Install and configure the OCI CLI on your machine
* If you are using multiple OCI CLI configurations, note which configuration/OCI Tenancy you wish to target and export OCI_CLI_PROFILE=<config> to ensure you are using the intended tenancy 

#### Using env.sh 

Open a shell session 
Clone the repo 


## Initializing a Compartment 

The initcompartment directory is used to create and configure a compartment for a GBU to access and use OCI services within that compartment, in a TIMS-compliant manner. 

### Prerequisites 

* Access to the OCI Tenancy is configured, t3pool02 in this example
* The OCI Tenancy has been configured and setup within TIMS 
* The IDCS group has been created within the federated IDCS instance, GBUCAA in this example

### Initializing a Compartment 

Open a shell session
Clone the repo 
Execute 

## Cleaning a Compartment 

The cleancompartment directory is used to 'clean up' or remove resources from a compartment that has been used by a GBU.

### Prerequisites 

* The OCI Tenancy/Compartment has been checked-in and the GBU T3 team is no longer using the tenancy or compartment. 

### Executing Cleanup 

Open a shell session
Clone the repo 
Execute 

## Initializing Compute Nodes for oSSH

The initcompute directory is an example of using Terraform to provision a set of compute nodes that have oSSH installed and configured.

### Prerequisites 

* The OCI Tenancy/Compartment is available 

### Executing Initializing Compute 

Open a shell session
Clone the repo 
Execute 

## Using CleanSweep for a Tenancy

Each solution has specific use-cases and nuances to running a project in OCI - in very special cases, the GBU T3 team is granted tenancy-level access to create resources. 

We need a way to 'cleansweep' the tenancy after it's been used, to ensure the tenancy is reclaimed and ready for re-use by other GBU T3 teams. 

### Prerequisites 

* CleanSweep is intended to be executed by the OCI Tenancy creator/primary user
* The CleanSweep set of scripts will remove everything from the OCI Tenancy, and the primary user will have to re-configure the tenancy with TIMS

### Executing CleanSweep 

Open a shell session
Clone the repo 
Execute 

## Getting Help 

Need help with the GBU T3 program? Use the slack channel: #gbu-t3-help 

