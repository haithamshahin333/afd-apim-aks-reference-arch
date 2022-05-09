targetScope = 'subscription'

param rgName string
param location string

//NETWORK
param vnetName string = 'vnet'
param aksSubnetName string = 'aksSubnet'
param apimSubnetName string = 'apimSubnet'
// param lbSubnetName string = 'lbSubnet'

//AKS
param aksClusterName string = 'aks-cluster'
param authorizedIPRanges array
param agentCountMax int = 0
param networkPlugin string = 'kubenet'
param JustUseSystemPool bool = true

//APIM
@secure()
param apimPublisherEmail string
param apimPublisherName string
param apimServiceNamePrefix string = 'apim'

resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: rgName
  location: location
}

module vnet 'modules/network/vnet.bicep' = {
  scope: resourceGroup
  name: 'vnetDeployment'
  params: {
    location: location
    vnetName: vnetName
  }
}

//specified in network/subnets.json
/***
BICEP RELEASE PULLED FROM: https://azure.github.io/AKS-Construction/
*/
module aks 'modules/aks/AKS-Construction-0.7.0/bicep/main.bicep' = {
  scope: resourceGroup
  name: 'aksDeployment'
  params: {
    location: location
    resourceName: aksClusterName
    JustUseSystemPool: JustUseSystemPool
    agentCountMax: agentCountMax
    byoAKSSubnetId: '${vnet.outputs.vnetId}/subnets/${aksSubnetName}'
    networkPlugin: networkPlugin
    authorizedIPRanges: authorizedIPRanges
    podCidr: '10.244.0.0/16'
  }
}

var apimName = uniqueString(apimServiceNamePrefix, resourceGroup.id)
module apim 'modules/apim/apim.bicep' = {
  scope: resourceGroup
  name: 'apimDeployment'
  params: {
    publisherEmail: apimPublisherEmail
    publisherName: apimPublisherName
    location: location
    apimServiceName: apimName
    vnetName: vnetName
    subnetName: apimSubnetName
    virtualNetworkType: 'External'
  }
  dependsOn: [
    vnet
  ]
}

var proxyEndpointName = uniqueString('frontDoor',resourceGroup.id)
module frontDoor 'modules/front-door/front-door.bicep' = {
  scope: resourceGroup
  name: 'frontDoorDeployment'
  params: {
    location: location
    proxyEndpointName: proxyEndpointName
    proxyOriginHostName: '${apim.outputs.apimResourceName}.azure-api.net'
  }
}
