# IT-DRIFT-SCHOOL_SERVER-

## Powershell Recommendation  (ADD, DNS, DHCP, FS-fileserver, IIS)

```
Get-WindowFeature
Install-WindowsFeature -Name ADD -IncludeAllsubFeature -InculdeManagementTools 
install-WindowsFeature -Name DHCP -IncludeAllsubFeature -IncludeManagementTools
Install-WindowsFeature -Name AD-Domain-Services -IncludeAllSubFeature -IncludeManagementTools
Install-WindowsFeature -Name Web-Webserver -IncludeAllsubFeature -InculdeManagementTools 
```

## Set Static IP Address
### !!!NOTE THIS METHOD WILL LOSE THE INTERNET!!!
### Get ifIndex
```
Get-Netadapter
```
### Create IP Address
```
New-NetIPAddress -InterfaceIndex <PLACE THE IFINDEX> -IPAddress <Create own IP> -PrefixLength 24 -DefaultGateway <Place your own IP but add .1 at the end>
```
#### Example:
```
New-NetIPAddress -InterfaceIndex 14 -IPAddress 192.168.5.100 -PrefixLength 24 -DefaultGateway 192.168.5.1
```
#### To check the StaticIP
```
Get-NetIPAddress
```


## Create DHCP server & Set DHCPServerscope
```
Add-DhcpServerInDC -DnsName "<PLACE YOUR DOMAINNAME>" -IPAddress <PLACE YOUR OWN GATEWAY>
```
#### Example:
```
Add-DhcpServerInDC -DnsName "Angelito.local" -IPAddress 192.168.5.1
```
```
Add-DhcpServerv4Scope -Name "<Set Your own Name>" -StartRange <Your IPAddress>.100 -EndRange <Your IPAddress>.200 -SubnetMask 255.255.255.0 -State Active
```
#### Example:
```
Add-DhcpServerv4Scope -Name "Kubennett" -StartRange 192.168.5.100 -EndRange 192.168.5.200 -SubnetMask 255.255.255.0 -State Active
```
#### Restart the DHCP-server
```
restart-service DHCPServer
```


## Create OrganizationalUNIT(OU)
```
New-ADOrganizationalUnit -Name "<SET YOUR OWN NAME>" -path "DC=<FIRST DOMAIN NAME>,DC=<local>"
```
#### To Check the OU
```
Get-ADOrganizationalUnit -Filter * -SearchBase "DC=<FIRST DOMAIN NAME>,DC=<local>"
```
#### To Remove User From OU
```
Remove-ADUser -Identity "CN=<NAME OF THE USER>,OU=<NAME OF OU>,DC=<FIRST DOMAIN NAME>,DC=<local>" -Confirm$false
```
#### Example:
```
Remove-ADUser -Identity "CN=FrendonReyes,OU=Kuben-IT,DC=Angelito,DC=local" -Confirm$false
```
#### ADD A Single user in OU
```

```
#### ADD Multiple Users in OU Using Powershell IIS 


