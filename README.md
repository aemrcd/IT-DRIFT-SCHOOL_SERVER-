# **💻 IT-DRIFT-SCHOOL-SERVER 🖥️**

A guide to setting up and managing an IT server environment using PowerShell for ADD, DNS, DHCP, File Server, Hyper-V and IIS configurations.

---

### **📖 Table of Contents**
1. [🚀 Powershell Recommendations](#-powershell-recommendations-)
2. [🌐 Set Static IP Address](#-set-static-ip-address)
3. [📡 Create DHCP Server & Set Scope](#create-dhcp-server--set-dhcpserverscope)
4. [📂 Create Organizational Unit (OU)](#create-dhcp-server--set-dhcpserverscope)
5. [🧑🏻 Add/Remove Users in OU](#-add-a-single-user-in-ou)
6. [👥 Add Multiple Users Using CSV](#-add-multiple-users-in-ou-using-powershell-iis)

---

### **🚀 Powershell Recommendations** <a name="powershell-recommendations"></a>
Install necessary Windows features for ADD, DNS, DHCP, File Server, and IIS. ⚙️

```powershell
Get-WindowsFeature
Install-WindowsFeature -Name ADD -IncludeAllSubFeature -IncludeManagementTools
Install-WindowsFeature -Name DHCP -IncludeAllSubFeature -IncludeManagementTools
Install-WindowsFeature -Name AD-Domain-Services -IncludeAllSubFeature -IncludeManagementTools
Install-WindowsFeature -Name Web-Webserver -IncludeAllSubFeature -IncludeManagementTools
install-WindowsFeature -Name Hyper-V -IncludeManagementTools
```

### 🌐 Set Static IP Address

#### Get ifIndex
```powershell
Get-Netadapter
```
#### Create IP Address
```powershell
New-NetIPAddress -InterfaceIndex <PLACE THE IFINDEX> -IPAddress <Create own IP> -PrefixLength 24 -DefaultGateway <Place your own IP but add .1 at the end>
```
#### Example:
```powershell
New-NetIPAddress -InterfaceIndex 14 -IPAddress 192.168.5.100 -PrefixLength 24 -DefaultGateway 192.168.5.1
```
#### To check the StaticIP
```powershell
Get-NetIPAddress
```


### 📡Create DHCP server & Set DHCPServerscope
```powershell
Add-DhcpServerInDC -DnsName "<PLACE YOUR DOMAINNAME>" -IPAddress <PLACE YOUR OWN GATEWAY>
```
#### Example:
```powershell
Add-DhcpServerInDC -DnsName "Angelito.local" -IPAddress 192.168.5.1
```
```powershell
Add-DhcpServerv4Scope -Name "<Set Your own Name>" -StartRange <Your IPAddress>.100 -EndRange <Your IPAddress>.200 -SubnetMask 255.255.255.0 -State Active
```
#### Example:
```powershell
Add-DhcpServerv4Scope -Name "Kubennett" -StartRange 192.168.5.100 -EndRange 192.168.5.200 -SubnetMask 255.255.255.0 -State Active
```
#### Restart the DHCP-server
```powershell
restart-service DHCPServer
```


### 📂 Create OrganizationalUNIT(OU)
```powershell
New-ADOrganizationalUnit -Name "<SET YOUR OWN NAME>" -path "DC=<FIRST DOMAIN NAME>,DC=<local>"
```
#### To Check the OU
```powershell
Get-ADOrganizationalUnit -Filter * -SearchBase "DC=<FIRST DOMAIN NAME>,DC=<local>"
```

### 🧑🏻 ADD A Single user in OU
```powershell
New-ADUser -Name "John Doe" -GivenName "John" -Surname "Doe" -SamAccountName "jdoe" -UserPrincipalName "jdoe@example.com" -Path "OU=<NAME OF OU>,DC=<FIRST DOMAIN NAME>,DC=<local>" -AccountPassword (ConvertTo-SecureString "<CREATE STRONG PASSWORD>" -AsPlainText -Force) -Enabled $true
```
#### EXAMPLE:
```powershell
New-ADUser -Name "John Doe" -GivenName "John" -Surname "Doe" -SamAccountName "jdoe" -UserPrincipalName "jdoe@angelito.local" -Path "OU=Kuben-IT,DC=angelito,DC=local" -AccountPassword (ConvertTo-SecureString "Password123!" -AsPlainText -Force) -Enabled $true
```

#### To Remove User From OU
```powershell
Remove-ADUser -Identity "CN=<NAME OF THE USER>,OU=<NAME OF OU>,DC=<FIRST DOMAIN NAME>,DC=<local>" -Confirm$false
```
#### Example:
```powershell
Remove-ADUser -Identity "CN=FrendonReyes,OU=Kuben-IT,DC=Angelito,DC=local" -Confirm$false
```

#### 👥 ADD Multiple Users in OU Using Powershell IIS 
```powershell
# Import Active Directory module
Import-Module ActiveDirectory

# Define CSV file path
$csvfile = "C:\Users\Administrator\Desktop\test.csv" <USE THE CSV FILE "INFO.CSV" IN THE RESPOSITORY>

# Import users from CSV
$users = Import-Csv -Path $csvfile

# Loop through each user in CSV
foreach ($user in $users) {
    $FirstName = $user.Name
    $GivenName = $user.GivenName
    $LastName = $user.Surname
    $DisplayName = $user.DisplayName
    $Username = $user.SAMAccountName
    $Password = $user.Password
    $Description = $user.Description
    $OU = $user.OU

    # Create new Active Directory user
    New-ADUser -Name "$FirstName $LastName" `
        -GivenName $GivenName `
        -Surname $LastName `
        -DisplayName $DisplayName `
        -SamAccountName $Username `
        -AccountPassword (ConvertTo-SecureString $Password -AsPlainText -Force) `
        -Description $Description `
        -Path $OU `
        -Enabled $true `
        -PassThru
}

```

### 🖥️ Create a virtual switch in Hyper-V
```powershell
'New-VMSwitch -Name "<Set Name>" -NetAdapterName "<Set Name>" -AllowManagementOS $true
```
#### Example 
```
New-VMSwitch -Name "VLAN01Switch" -NetAdapterName "Ethernet" -AllowManagementOS $true
```

