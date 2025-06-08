param location string = resourceGroup().location
param env string = 'prod'
param onPremPIP string
param prodPIP string
param onPremBGPAddress string
resource prodVnet 'Microsoft.Network/virtualNetworks@2024-07-01' existing = {
  name: '${env}-Vnet'
}


resource gateWay 'Microsoft.Network/virtualNetworkGateways@2024-07-01' = {
  name: '${env}-Gateway'
  location: location
  properties: {
    sku: {
      name: 'VpnGw1'
      tier: 'VpnGw1'
    }
    gatewayType: 'Vpn'
    vpnType: 'RouteBased'
    enableBgp: true
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: prodVnet.properties.subnets[0].id
          }
          publicIPAddress: {
            id: prodPIP
          }
        }
      }
    ]
    bgpSettings: {
      asn: 65520
       customBgpIpAddresses: [
        '20.0.1.253'
      ]
      
  }
}
}

resource localNetworkGateway 'Microsoft.Network/localNetworkGateways@2024-07-01' = {
  name: '${env}-LocalGateway'
  location: location
  properties: {
    gatewayIpAddress:onPremPIP
    localNetworkAddressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    bgpSettings:{
      asn: 65512
      bgpPeeringAddress: onPremBGPAddress
    }

    }
  }
var BGPAddress = gateWay.properties.bgpSettings.customBgpIpAddresses[0]
  output BGPAddress string = gateWay.properties.bgpSettings.bgpPeeringAddress

