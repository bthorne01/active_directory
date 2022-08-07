01 Installing the Domain Controller

1. SCCONFIG to:
	Change hostname
	change IP address to static
	Change DNS server to DC ip address

2. Install the active directory windows feature
	Install-WindowsFeature AD-Domain-Services -IncludeManagementServices
