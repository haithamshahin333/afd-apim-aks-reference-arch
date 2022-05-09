param apimServiceName string
param apimEnv string

var envConfigMap = {
  dev: {
    url: 'https://dev-url'
  }
  staging: {
    url: 'https://staging-url'
  }
  prod: {
    url: 'https://prod-url'
  }
}

//example openapi spec provided
resource javaApi 'Microsoft.ApiManagement/service/apis@2021-08-01' = {
  name: '${apimServiceName}/javaApi'
  properties: {
    path: 'javaApi'
    apiRevision: '1'
    apiRevisionDescription: 'initial api'
    displayName: 'java api'
    subscriptionRequired: false
    serviceUrl: envConfigMap[apimEnv].url
    protocols: [
      'https' 
    ]
    format: 'openapi+json'
    value: loadTextContent('openapi.json')
  }
}
