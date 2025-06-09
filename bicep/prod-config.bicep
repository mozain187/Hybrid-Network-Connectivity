param location string = resourceGroup().location
param env string = 'prod'
param prodPIP string = '/subscriptions/90f930dc-3b4a-442a-98a0-f4e1b7a2989d/resourceGroups/prod-rg/providers/Microsoft.Network/publicIPAddresses/prod-PublicIP'


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
      asn: 64513
  }
}
}

  output BGPAddress string = gateWay.properties.bgpSettings.bgpPeeringAddress
