\# \*\*Project 1: Azure VM Migration with Load Balancing 

\## \*\* Complete Implementation Documentation





\---





\## \*\*PROJECT OVERVIEW\*\*



Build a production-ready Azure infrastructure that:

Deploys 2 Windows VMs with IIS web servers

Implements Load Balancer for automatic traffic distribution

Creates Virtual Network with 3-tier subnet architecture

Applies Network Security for firewall protection

Provides high availability with automatic failover





\---





\## \*\*ARCHITECTURE\*\*



Internet/Users

|

Load Balancer(pip-lb)

|\_\_vm-web-1(10.0.1.4) - Windows2022, IIS

|

|\_\_vm-web-2(10.0.1.5) - Windows2022, IIS

|

Virtual Network(vnet-migration:10.0.0.0/16)

|

|\_subnet-web(10.0.1.0/24)-Web Tier(VMs here)

|

|\_Subnet-web(10.0.2.0/24) - Application Tier

|

|\_Subnet-database(10.0.3.0/24) - Database Tier





\---





\## \*\*INFRASTRUCTURE COMPONENTS\*\*





\### Core Resources

✅ Resource Group: rg-vm-migration-production (Southeast Asia)

✅ Virtual Network: vnet-migration (10.0.0.0/16)

✅ Subnets: subnet-web, subnet-app, subnet-databse

✅ Load Balancer: lb-main (Standard SKU)

✅ 2 Windows VMs: vm-web-1, vm-web-2 (Standard\_D2s\_v3)

✅ Network Security Group: nsg-web

✅ Public IP: pip-lb (load Balancer endpoint)

✅ Network Interfaces: 2 (one per VM)

✅ OS Disks: 2 (128 GB each)

✅ Public IPs for VMs: pip-web-1, pip-vm-web-2





\*\*Total Resources Deployed: 14\*\*





\---





\## \*\*HOW IT WORKS (Step-by-Step)\*\*



\## Users Request Flow:



User visits: http://\[Load-Balancer-IP]

Load Balancer receives HTTP request

Load Balancer checks health of both VMs

If both healthy:

&#x09;- 1st request->vm-web-1

&#x09;- 2nd request->vm-web-2

&#x09;- 3rd request->vm-web-1(Round-robin)

5\. If vm-web-1 fails:

&#x09;- All requests->vm-web-2 only

&#x09;- No downtime

6\. Website display in browser





\### \*\*Health Monitoring:\*\*



Every 15 seconds:

|\_Load Balancer sends HTTP GET to port 80

|\_Checks if VM responds with timeout 

|\_vm-web-1 Healthy? ✅ YES

|\_vm-web-2 Healthy? ✅ YES

|\_Result: Both VMs in active backend pool



If VM becomes unhealthy (after 2 failed check):

|\_Automatically removed from backend pool

|\_All traffic routes to healthy VM only

|\_No user-facing downtime

|\_Ready for remediation





\---





\## \*\*NETWORK CONFIGURATION\*\*



\### Virtual Network

Name: vnet-migration

Address Space: 10.0.0.0/16

Region: Southeast Asis



\## Subnets

subnet-web: 10.0.1.0/24 (Web Tier - VMs deployed here)

subnet-app: 10.0.2.0/24 (Application Tier - Reserved)

subnet-database: 10.0.3.0/24 (Database Tier - Reserved)



\## IP Allocation

vm-web-1: 10.0.1.4

vm-web-2: 10.0.1.5

Load Balancer: Public IP (pip-lb)





\---





\## \*\*SECURITY CONFIGURATION\*\*





\### \*\*Network Security Group Rules\*\*



Rule 1: Allow HTTP

|\_Protocol: TCP

|\_Port:80

|\_Priority:100



Rule 2: Allow HTTPS

|\_Protocol: TCP

|\_Port: 443

|\_Priority:110



All Other Ports: DENY(Default)




### \*\*Security Features\*\*

✅ Network isolation via subnets

✅ Stateful firewall protection

✅ Only necessary ports open

✅ Private VMs (no direct internet access)

✅ Traffic only through Load Balancer





\---





\## \*\*LOAD BALANCER CONFIGURATION\*\*



\### Backend Pool: BackEndAddressPool

vm-web-1(10.0.1.4:80)

vm-web-2(10.0.1.5:80)



\### Health Probe: http-probe

Protocol: HTTP

port: 80

Interval: 15 seconds

unhealthy threshold: 2 consecutive failures



\### Load Balancing Rule: http-rule

Frontend Port: 80

Backend Port: 80

Protocol: TCP

Distribution: Round-robin





\---





\## \*\*VIRTUAL MACHINE SPECIFICATIONS\*\*



\### VM-web-1

OS: Windows Server 2022 Datacenter

Size: Standard\_D2s\_v3 (2 vCPU, 8 GB RAM)

OS Disk: Premium SSD 128 GB

Network: Subnet-web (10.0.1.4)

Public IP: pip-vm-web-1

Software: IIS 10.0 installed

Admin: migration01



\### VM-web-2

OS: Windows Server 2022 Datacenter

Size: Standard\_D2s\_v3 (2 vCPU, 8 GB RAM)

OS Disk: Premium SSD 128 GB

Network: subnet-web (10.0.1.5)

Public IP: pip-vm-web-2

Software: IIS 10.0 installed

Admin: migration01





\---





\## \*\*ACCESS METHODS\*\*



\### Public Access (via Load Balancer)

URL: http://\[Load-Balancer-Public-ip]

Port: 80

Access Type: HTTP

Intended For: End users



\### VM Direct Access (Management)

vm-web-1: http://\[pip-vm-web-1]

vm-web-2: http://\[pip-vm-web-2]

Intended For: Administrators





\---





\## \*\*TESTING PERFORMED\*\*



\### Test 1: Load Balancer Access

✅ Accessed via Load Balancer public IP

✅ IIS Default Page displayed

✅ Response time: <100ms

✅ Status: \*\*WORKING\*\*



\### Test 2: VM-1 Direct Access

✅ Accessed vm-web-1 directly

✅ IIS Default Page displayed

✅ Response time: <100ms

✅ Status: \*\*WORKING\*\*



\### Test 3: VM-2 Direct Access

✅ Accessed vm-web-2 directly

✅ IIS Default Page displayed

✅ Response time: <100ms

✅ Status: \*\*WORKING\*\*



\### Test 4: Load Balancer Health Probe

✅ Both VMs marked as Healthy

✅ Health checks running every 15 seconds

✅ Probe responses received

✅ Status: \*\*WORKING\*\*



\### Test 5: Network Security

✅ HTTP (port 80) accessible

✅ HTTPS (port 443) configured

✅ RDP blocked from internet

✅ All other ports blocked

✅ Status: \*\*WORKING\*\*





\## \*\*MONITORING \& STATUS\*\*



\### Load Balancer

✅ Status: \*\*ACTIVE\*\*

✅ Uptime SLA: 99.9%

✅ Health Probe: Every 15 seconds

✅ Failover Time: <1 minute



\### Virtual Machines

✅ vm-web-1: Running

✅ vm-web-2: Running

✅ Both Showing as Healthy: YES

✅ IIS responding: YES



\### Network

✅ Subnet configuration: OK

✅ Network isolation: OK

✅ Traffic Distribution: OK

✅ Security rules: OK





\---





\## \*\*KEY BENEFITS\*\*



✅ \*\*High Availability\*\*

* No single point of failure
* 2 VMs in separate fault domains
* Automatic failover
* 99.9% uptime SLA



✅ \*\*Load Balancing\*\*

* Automatic traffic distribution
* Round-robin algorithm
* Optimal resource utilization
* Even load across VMs



✅ \*\*Security\*\*

* Network isolation via subnets
* Firewall protection (NSG)
* Only necessary ports open
* No direct internet access to VMs



✅ \*\*Scalability\*\*

* Ready to add more VMs
* Load Balancer support 10+ VMs
* Subnets have room for expansion





\---





\## \*\*WHAT THIS DEMONSTRATES\*\*



This infrastructure shows:

* \*\*Enterprise Architecture\*\* - Professional infrastructure design
* \*\*High Availability\*\* - No single point of failure
* \*\*Load Balancing\*\* - Automatic traffic distribution
* \*\*Security\*\* - Firewall and network isolation
* \*\*Scalability\*\* - Ready for growth
* \*\*Production Ready\*\* - 99.9% uptime capable 
* \*\*Best Practices\*\* - Industry-standard setup





\---





\## \*\*USE CASES\*\*



This infrastructure is ideal for:

* E-commerce websites
* SaaS applications
* API backends
* Web services
* Business applications





\---





\## \*\*PROJECT COMPLETION STATUS\*\*



| \*\*COMPONENTS | \*\*STATUS\*\* |

|--------------|------------|



\[Resource Group] / \[✅ Created]

\[Virtual Network] / \[✅ Created]

\[Subnets (3)] / \[✅ Created]

\[Virtual Machines (2)] / \[✅ Deployed]

\[IIS Installation] / \[✅ Complete]

\[Load Balancer] / \[✅ Configured]

\[Backend Pool] / \[✅ Configured]

\[Health Probe] / \[✅ Configured]

\[Load Balancing Rule] / \[✅ Configured]

\[Network Security Group] / \[✅ Configured]

\[Testing] / \[✅ Complete]

\[Documentation] / \[✅ Complete]









