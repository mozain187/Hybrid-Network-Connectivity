param env string ='on-prem'
param location string = resourceGroup().location
param onPremPIP string  = '/subscriptions/90f930dc-3b4a-442a-98a0-f4e1b7a2989d/resourceGroups/on-prem-rg/providers/Microsoft.Network/publicIPAddresses/on-prem-PublicIP'


resource onPremVnet 'Microsoft.Network/virtualNetworks@2024-07-01' existing ={
  name:'on-prem-Vnet'
}

resource Gateway 'Microsoft.Network/virtualNetworkGateways@2024-07-01' = {
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
        name: 'vnetGatewayConfig'
        properties: {
          subnet: {
            id: onPremVnet.properties.subnets[0].id
          }
          publicIPAddress: {
            id: onPremPIP

          }
          privateIPAllocationMethod:'Dynamic'
        }
      }
    ]
    bgpSettings:{
      asn: 65515
      
      
      
      
    }

  }
}

