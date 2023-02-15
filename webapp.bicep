param webAppName string = uniqueString(resourceGroup().id)
param sku string = 'F1'
param location string = resourceGroup().location
param linuxFxVersion string = 'node|14-lts'
param repositoryUrl string = 'https://github.com/Azure-Samples/nodejs-docs-hello-world'
param branch string = 'main'
var appServicePlanName = toLower('AppServicePlan-${webAppName}')
var webSiteName = toLower('wapp-${webAppName}')

resource appserviceplan 'Microsoft.Web/serverfarms@2022-03-01'= {
  name: appServicePlanName
  location: location
  properties: { 
    reserved: true
  }
  sku: {
    name: sku
  }
  kind: 'linux'
}

resource appservice 'Microsoft.Web/sites@2022-03-01' = [for i in range(0,2) : {
  name: '${i}${webSiteName}'
  location: location
  properties: {
    serverFarmId: appserviceplan.id
    siteConfig: {
      linuxFxVersion: linuxFxVersion
    }
  }
}]
//test
resource srcControls 'Microsoft.Web/sites/sourcecontrols@2022-03-01' = [for i in range(0,2) : {
  name: '${appservice[i].name}/web'
  properties: {
    repoUrl: repositoryUrl
    branch: branch
    isManualIntegration: true
  }
}]
