# Hybrid-Network-Connectivity
Hybrid Network Connectivity with Azure VPN Gateway + BGP
# 🔷 Hybrid Network Connectivity: Azure VPN Gateway + BGP

## 📖 Project Overview
This project simulates a hybrid cloud setup by connecting an on-premises data center (simulated as a separate Azure VNet) to an Azure production VNet using a **Site-to-Site VPN** with **BGP for dynamic routing**. It includes infrastructure automation with **Azure Bicep**, **GitHub Actions CI/CD**, and secure subnet-level traffic control using **NSGs** and **Route Tables**.

---

## 🛠️ Tech Stack
- **Azure VPN Gateway (Route-Based)**
- **BGP Configuration**
- **Local Network Gateway**
- **Site-to-Site VPN Connection**
- **Azure Route Tables (UDRs)**
- **Network Security Groups (NSGs)**
- **Azure Bastion**
- **Azure VMs (for Azure-side & simulated on-premises)**
- **Azure Bicep (Infrastructure as Code)**
- **Azure CLI**
- **GitHub Actions (CI/CD pipeline)**

---

## 🌐 Topology Diagram

On-Premises VNet (10.1.0.0/16)
|
VPN Gateway + BGP
|
Site-to-Site VPN
|
Azure Production VNet (10.0.0.0/16)
|
Azure VPN Gateway + BGP
|
Subnets + NSGs + Route Tables
|
Azure Bastion / Azure VMs


---

## 🚀 Key Features

- 🔒 **Secure VPN-based Hybrid Connectivity** between simulated on-premises and Azure VNet
- 📡 **BGP Dynamic Routing** enabled between VPN Gateways for automatic route advertisement
- 📑 **Infrastructure as Code** using Azure Bicep templates
- ⚙️ **Route Tables & NSGs** to control traffic flow and inspect routing behavior
- 🖥️ **Azure Bastion & RDP** for VM management without exposing public IP addresses
- 📦 **Automated Deployment via GitHub Actions pipeline**

---

## 📂 Project Structure

├── bicep/
| ├── main-f.bicep
| ├── main-s.bicep
│ ├── on-prem.bicep
│ ├── on-prem-config.bicep
│ ├── prod.bicep
│ ├── prod-config.bicep
├── pipelines/
│ └── azure-deploy.yml (changeable in my case)
├── README.md


---



## 🧑‍💻 User Roles & Access

| User                    | Role(s)                                | Scope                         |
|:------------------------|:---------------------------------------|:-----------------------------|
| Azure Network Engineer   | `Network Contributor` + `Virtual Machine Contributor` | Resource Group in my project |
| On-Prem Network Admin    | `Virtual Machine User Login` (on Azure VMs) | VM Resource |

**Note:** No NSG is applied to the GatewaySubnet as per Azure best practices.

---

## 📖 Deployment Process

1. Deploy Azure VNets, subnets, and GatewaySubnet
2. Deploy Azure VPN Gateway with BGP enabled
3. Deploy Local Network Gateway (representing on-prem)
4. Create Site-to-Site VPN Connection with BGP peering
5. Deploy Route Tables and NSGs
6. Deploy Azure VMs on both VNets
7. Configure RDP access and Bastion management
8. Test VPN tunnel, route advertisements, and NSG rules

---

## 📝 Lessons Learned

- BGP IP configuration logic on VPN Gateway
- NSG and Route Table interplay in hybrid networking
- Azure VPN Gateway + Bastion best practices
- Automating Azure infra with Bicep and GitHub Actions
- Real-world hybrid cloud connectivity design patterns

---



## 📌 License

MIT © [mozain187]

