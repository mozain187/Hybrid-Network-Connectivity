targetScope = 'subscription'

param onPremPIP string = '172.190.149.73'
param prodPIP string = '74.235.219.163'
param onPremBGPAddress string = '10.0.1.254'

module onPrem 'on-config.bicep' = {
  name: 'onPremConfig'
  params: {
    prodPIP: prodPIP
    prodBGPAddress: prod.outputs.BGPAddress
  }
  scope: resourceGroup('on-prem-rg')
}

module prod 'prod-config.bicep' = {
  name: 'prodConfig'
  params: {
    onPremPIP: onPremPIP
    prodPIP: prodPIP
    onPremBGPAddress: onPremBGPAddress
  }
  scope: resourceGroup('prod-rg')
}
