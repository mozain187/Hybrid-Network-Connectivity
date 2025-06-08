param env string ='on-prem'
param location string = resourceGroup().location
param prodPIP string
param prodBGPAddress string 


resource localGateway 'Microsoft.Network/localNetworkGateways@2024-07-01' = {
  name: '${env}-LocalGateway'
  location: location
  properties: {
    gatewayIpAddress: prodPIP
    bgpSettings: {
      asn: 65520
      bgpPeeringAddress: prodBGPAddress
    }
    localNetworkAddressSpace: {
      addressPrefixes: [
        '20.0.0.0/16'
      ]
    }
}
}
