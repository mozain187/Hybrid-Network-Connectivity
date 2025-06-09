param adminName string = 'azureUser'
@secure()
param adminPassword string
param env string = 'prod'
param location string = resourceGroup().location


resource prodVnet 'Microsoft.Network/virtualNetworks@2024-07-01' ={
  name: '${env}-Vnet'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '20.0.0.0/16'
      ]
    }
    subnets:[
      {
        name: 'GatewaySubnet'
        properties: {
          addressPrefix: '20.0.1.0/24'
        }
      }
      {
        name: 'ProdSubnet'
        properties: {
          addressPrefix: '20.0.2.0/24'
          
        }

      }
      {
        name: 'AzureBastionSubnet'
        properties: {
          addressPrefix: '20.0.3.0/24'
        }
      }
    ]
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
            id: prodVnet.properties.subnets[1].id
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
        publisher: 'Canonical'
        offer: '0001-com-ubuntu-server-jammy'
        sku: '22_04-lts-gen2'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'Standard_LRS'
        }
      }
    }
    osProfile: {
      computerName: '${env}-vm'
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

resource BastionIp 'Microsoft.Network/publicIPAddresses@2024-07-01' = {
  name: '${env}-BastionPIP'
  location: location
  properties: {
    publicIPAllocationMethod: 'Static'
  }
  sku: {
    name: 'Standard'
  }
}
resource Bastion 'Microsoft.Network/bastionHosts@2024-07-01' = {
  name: '${env}-Bastion'
  location: location
  properties: {
    
    ipConfigurations: [
      {
        name: 'bastionIpConfig'
        properties: {
          subnet: {
            id: prodVnet.properties.subnets[2].id
          }
          publicIPAddress: {
            id: BastionIp.id
          }
        }
      }
    ]
  }
  sku: {
    name: 'Standard'
    
  }
}
resource vmNsg 'Microsoft.Network/networkSecurityGroups@2024-07-01' = {
  name: '${env}-VmNSG'
  location: location
  properties: {
    securityRules: [
      {
        name: 'AllowAzureBastion'
        properties: {
          priority: 100
          protocol: 'Tcp'
          access: 'Allow'
          direction: 'Inbound'
          sourceAddressPrefix: '20.0.3.0/24'
          destinationAddressPrefix: nic.properties.ipConfigurations[0].properties.privateIPAddress
          sourcePortRange: '*'
          destinationPortRange: '22'
        }
      }
      {
        name: 'AllowRDP'
        properties: {
          priority: 200
          protocol: 'Tcp'
          access: 'Allow'
          direction: 'Inbound'
          sourceAddressPrefix: '10.0.0.0/16'
          destinationAddressPrefix: nic.properties.ipConfigurations[0].properties.privateIPAddress
          sourcePortRange: '*'
          destinationPortRange: '3389'
        }
      }
      {
        name: 'AllowSSH'
        properties: {
          priority: 110
          protocol: 'Tcp'
          access: 'Allow'
          direction: 'Inbound'
          sourceAddressPrefix: '10.0.0.0/16'
          destinationAddressPrefix: nic.properties.ipConfigurations[0].properties.privateIPAddress
          sourcePortRange: '*'
          destinationPortRange: '22'
        }
      }
      {
        name: 'AllowICMP'
        properties: {
          priority: 120
          protocol: 'Icmp'
          access: 'Allow'
          direction: 'Inbound'
          sourceAddressPrefix: '10.0.0.0/16'
          destinationAddressPrefix: nic.properties.ipConfigurations[0].properties.privateIPAddress
          sourcePortRange: '*'
          destinationPortRange: '*'
        }
      }
      

    ]
  }
}
resource ProdGpublicIP 'Microsoft.Network/publicIPAddresses@2024-07-01' = {
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
