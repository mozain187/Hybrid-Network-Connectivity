param location string = resourceGroup().location
param env string = 'on-prem'
@secure()
param adminPassword string
param adminName string = 'azureUser'

resource onPremVnet 'Microsoft.Network/virtualNetworks@2024-07-01' = {
  name: '${env}-Vnet'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
      }
    subnets: [
      {
        name: 'GatewaySubnet'
        properties: {
          addressPrefix: '10.0.1.0/24'
         
        }

    }
    {
      name: 'OnPremSubnet'
      properties:{
        addressPrefix: '10.0.2.0/24'
        
      }
    }
  ]
  }
}


resource PublicIP 'Microsoft.Network/publicIPAddresses@2024-07-01' = {
  name: '${env}-PublicIP'
  location: location
  properties: {
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
  }
  sku: {
    name: 'Standard'
  }
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
            id: PublicIP.id
          }
          privateIPAllocationMethod:'Dynamic'
        }
      }
    ]
    bgpSettings:{
      asn: 65512
      
      

    }

  }
}


        

resource nic 'Microsoft.Network/networkInterfaces@2024-07-01' = {
  name: '${env}-NIC'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: onPremVnet.properties.subnets[1].id
          }
          
        }
      }
    ]
  }
}

resource vm 'Microsoft.Compute/virtualMachines@2024-07-01' = {
  name: '${env}-VM'
  location: location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_B1s'
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2019-Datacenter'
        version: 'latest'
      }
      osDisk: {
        name: '${env}-OSDisk'
        caching: 'ReadWrite'
        createOption: 'FromImage'
      }
    }
    osProfile: {
      computerName: '${env}-VM'
      adminUsername: adminName
      adminPassword: adminPassword
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic.id
        }
      ]
    }

  }
}
output nicIp string = nic.properties.ipConfigurations[0].properties.privateIPAddress

