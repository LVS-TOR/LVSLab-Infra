# LVS LAB Infrastructure

## Requirements

1. Create a new Azure Active Directory tenant.
Instructions: https://docs.microsoft.com/en-us/azure/active-directory/fundamentals/active-directory-access-create-new-tenant
1. Change the Visual Studio Enterprise Subscription – MPN Azure subscription to the new tenant.
Instructions: https://docs.microsoft.com/en-us/azure/active-directory/fundamentals/active-directory-how-subscriptions-associated-directory#associate-a-subscription-to-a-directory
1. NetworkWatcherRG resource should be removed from the envionment before running the script.

**The script will deploy the following devices:**

## Governance: 

### Azure Policy:

>Unattached disks should be encrypted

>Storage Accounts should use a virtual network service endpoint

>Require a tag on resource groups

>Network interfaces should not have public IPs

>Network interfaces should disable IP forwarding

>Key Vault should use a virtual network service endpoint

>Flow log should be configured for every network security group

>Custom subscription owner roles should not exist

>Audit resource location matches resource group location

>Allowed locations


### Azure AD Groups:

>LVS LAB - AZ Global - Contributors

>LVS LAB - AZ Global - Owners

>LVS LAB - AZ Security - Admin

**Note:** the groups will be associated with the susbsciption based on their role.


## Azure Resources:

### lvs-lab-network-rg
>Virtual Network

>NSGs

### lvs-lab-infra-rg
>Log Analytics

>Storage Account + Private Endpoint

>Key Vault

### lvs-lab-compute-rg
>2x Virtual Machines - (SKU B2ms)

>Managed Disks

>Public IPs

>Network Adaptors

>NSGs
