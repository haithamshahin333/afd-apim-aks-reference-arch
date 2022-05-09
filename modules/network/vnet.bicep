param vnetAddressSpace object = {
  addressPrefixes: [
    '10.0.0.0/16'
  ]
}
param vnetName string = 'vnet'
param subnets array = json(loadTextContent('./subnets.json')).subnets

param location string = resourceGroup().location

resource vnet 'Microsoft.Network/virtualNetworks@2021-02-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: vnetAddressSpace
    subnets: subnets
  }
}

output vnetId string = vnet.id
output vnetName string = vnet.name
output vnetSubnets array = vnet.properties.subnets
