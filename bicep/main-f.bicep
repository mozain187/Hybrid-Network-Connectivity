targetScope = 'subscription'
@secure()
param adminPassword string

module onPrem 'on-prem.bicep' = {
  name: 'onPremConfig'
  params: {
    adminPassword: adminPassword

  }
  scope:resourceGroup('on-prem-rg')
}

module prod 'prod.bicep' = {
  name: 'prodConfig'
  params: {
    adminPassword: adminPassword
    addressPrefix: onPrem.outputs.nicIp
  }
  scope: resourceGroup('prod-rg')
}
