<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2023 v5.8.226
	 Created on:   	7/27/2023 7:54 PM
	 Created by:   	Skylancer
	 Organization: 	https://github.com/Skylancer187
	 Filename:     	Start-WinUtil.ps1
	===========================================================================
	.DESCRIPTION
		A simple wrapper for ChrisTitusTech's WinUtil tool. Sorry, but I don't think $10 is fair for a wrapper.
		His site is also loaded with adds, consider Paypal Direct or Ko-Fi for support instead of Ads/$10 fee.
		Again, great work, but be a bit more friendly to the community.

		I wrapped it for Free with my own license of Sapien PowerShell Studio Digital Certificate.

	.SOURCE
		https://github.com/ChrisTitusTech/winutil
#>

# Enable TLS1.2 Client Configuration.
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ChrisTitusTech/winutil/main/winutil.ps1')

