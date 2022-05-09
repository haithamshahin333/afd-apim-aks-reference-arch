param location string = resourceGroup().location

@secure()
param publisherEmail string
param publisherName string

param apimServiceName string = 'apim'
param apimEnv string = 'dev'

param virtualNetworkType string = 'Internal'
param subnetName string = ''
param vnetName string = ''

@description('The pricing tier of this API Management service')
@allowed([
  'Developer'
  'Standard'
  'Premium'
])
param sku string = 'Developer'


module serviceConfig 'apim-modules/service/service.bicep' = {
  name: 'serviceConfiguration'
  params: {
    publisherEmail: publisherEmail
    publisherName: publisherName
    location: location
    apiManagementServiceName: apimServiceName
    sku: sku
    subnetName: subnetName
    vnetName: vnetName
    apimEnv: apimEnv
    virtualNetworkType: virtualNetworkType
  }
}

module shared 'apim-modules/shared/shared.bicep' = {
  name: 'shared'
  params: {
    apimInstance: serviceConfig.outputs.apimInstance
    apimEnv: apimEnv
    
  }
}

module apis 'apim-modules/apis/apis.bicep' = {
  name: 'apis'
  params: {
    apimInstance: serviceConfig.outputs.apimInstance
    apimEnv: apimEnv
  }
}

output apimResourceId string = serviceConfig.outputs.apimInstance.id
output apimResourceName string = serviceConfig.outputs.apimInstance.name
