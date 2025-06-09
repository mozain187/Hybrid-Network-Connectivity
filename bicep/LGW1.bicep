param location string = resourceGroup().location
param prodPIP string ='172.174.68.226'

param prodBGPAddress string 


resource localNetworkGateway 'Microsoft.Network/localNetworkGateways@2024-07-01' = {
  name: 'onPrem-to-prod-LocalGateway'
  location: location
  properties: {
    gatewayIpAddress: prodPIP
    bgpSettings: {
      asn: 64513
      bgpPeeringAddress: prodBGPAddress
    }
    localNetworkAddressSpace: {
      addressPrefixes: ['20.0.0.0/16']

    }
  }
}
