# FRONT DOOR / APIM / AKS API

## Goal

This architecture shows how you can front an APIM instance that is injected into a VNET and proxy requests through Front Door. As an example, you can run your backend API on AKS and expose it from within the VNET using an ingress controller.

> Take note that you need to deploy your application/ingress controller and create an API in apim accordingly. You will find a sample for how to create an API through bicep here

## AKS Bicep Reference

The Bicep modules, templates, and params used in this project are sourced from the upstream [AKS Deploy Helper](https://azure.github.io/AKS-Construction/) which allows you to use a GUI to further customize your AKS deployment depending on your needs.

Currently the [latest release](https://github.com/Azure/AKS-Construction/releases/tag/0.7.0) is used in this project.

## Commands to deploy infrastructure

1. Command to Deploy:

```bash
az cloud set --name <AzureCloud | AzureUSGovernment>

az login --use-device-code

export LOCATION=<eastus | usgovvirginia | etc.>

cp main.parameters.json local.parameters.json

###
### FILL IN LOCAL PARAMS BEFORE RUNNING BELOW
###

az deployment sub create \
    --name fd-deployment \
    --template-file ./main.bicep \
    --parameters local.parameters.json \
    --location $LOCATION
```
