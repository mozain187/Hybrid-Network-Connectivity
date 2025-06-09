param location string = resourceGroup().location
param env string = 'prod'
param onPremPIP string  ='74.235.27.6'
param onPremBGPAddress string ='10.0.1.254'
resource localNetworkGateway 'Microsoft.Network/localNetworkGateways@2024-07-01' = {
  name: '${env}-to-onPrem-LocalGateway'
  location: location
  properties: {
    gatewayIpAddress:onPremPIP
    localNetworkAddressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    bgpSettings:{
      asn: 65515
      bgpPeeringAddress: onPremBGPAddress
 
    }

    }
  }
