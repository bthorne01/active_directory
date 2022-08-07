01 Installing the Domain Controller

1. SCCONFIG to:
	Change hostname
	change IP address to static
	Change DNS server to DC ip address

2. Install the active directory windows feature
	Install-WindowsFeature AD-Domain-Services -IncludeManagementServices

3. Import PS module ADDSFOREST
	Run the command Install-ADDSForest
	Supply domain name and SafeModeAdmin password


4. The install of directory services resets the dns server to localhost, we need to change this back.
	Get-DnsClientServerAddress -> get the correct network interface index
	Set-DnsClientServerAddress -InterfaceIndex 4 -ServerAddresses 192.168.0.112 -> Using powershell to set the DNS server address to the DC IP. 

	

