# wk2-webapp

# Set up a Resource Group with a Virtual Network of 4 subnets (Bastion - Postgresql - Keyvault - Webapp)
# Linked the VNET to a private DNS
# Hosted a webapp via app service plan/serverfarms and pulled a nodejs from a Git repo
# Created a Postgres DB and deploying to a subnet with private endpoint so that it cannot be accessed via public IP
# Created a VM to check if our DB was up and running and if the private endpoint was working correctly
# Created a Bastion to allow for more secure access to the VM (No public IP access)
# Created a Key Vault to store ssh keys for connecting to a VM