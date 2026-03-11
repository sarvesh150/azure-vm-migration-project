**Overview**

Build a Production-ready infracture with 2 Windows VM's, Load Balancer, and Network Security.

**Architecture :**

**Internet**

Load Balancer(pip - lb)
1. vm-web-1 (IIS)
2. vm-web-2 (IIS)



[Resources]        /[Name]                          /[Type]

[Resource Group]   /[rg-vm-migration-production]    /[Southeast Asia]

[Virtual Network]  /[vnet-migration]                /[10.0.0.0/16]

[Subnets]          /[subnet-web, subnet-app,        /[3x / 24] 
                 subnet-db]            

[Load Balancer]    /[lb-main]                       /[Standard]

[VM's]             /[vm-web-1, vm-web-2]            /[Windows 2022, D2s_v3]

[Public IP]        /[pip-lb]                        /[Static]

[NSG]              /[nsg-web]                       /[HTTP/HTTPS allowed]


**Total Number of Resources 14 (6 primary + 8 Auto-Created)**


**Key Features**
1. High Availability - 2 VM's with automatic failover
2. Load Balancing - Round-robin traffic distribution
3. Health Monitoring - Automatic health checks every 15s
4. Security - NSG firewall rules (HTTP/HTTPS only)
5. Scalability - Ready to add more VM's


**[How It Works]**
1. User Visits Load Balancer public IP
2. Health probe checks both VM's (every 15 seconds)
3. Traffic ditributed round-robin:
       * Request 1 -> VM-1
       * Request 2 -> VM-2
       * Request 3 -> VM-1 (repeat)
4. If one VM fails -> all traffic routes to heavy VM
5. No Downtime, automatic recovery


**Testing Resutls**
* Load Balancer accessible via public IP
* Both VM's showing as Healthy
* Direct access to both VM's works
* IIS Default Page loads on all endpoints
* NSG rules verified (only HTTP/HTTPS allowed)

**Monthly Cost**
[Service]  / [cost]

[2x VM's (D2s_v3)] / [$180]

[Load Balancer]  /  [$16]

[Public IP's (3x)]  /  [$9]

[Storage]  /  [$10]

[Total]  /  [~$215/ month]



**Status** 
1. Infrastructure Deployed and tested
2. All Components working
3. Production-ready
4. Ready For Project 2 (CI/CD)

