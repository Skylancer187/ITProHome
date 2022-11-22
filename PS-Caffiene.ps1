﻿<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2022 v5.8.206
	 Created on:   	11/3/2022 1:56 PM
	 Created by:   	Nelson, Matthew
	 Organization: 	Florida State University
	 Filename:     	
	===========================================================================
	.DESCRIPTION
		Keep Windows awake script for various reasons.
#>

param
(
	[parameter(Mandatory = $false)]
	[int]$sleep = 60,
	#seconds
	[parameter(Mandatory = $false)]
	[int]$duration = 0 #hours
)

try
{
	$futuredate = (Get-Date).AddDays($duration)
	$stop = $false #reset/set while statement to $false
	#suggested using Media Player API Calls to keep system awake instead of pressing buttons. This uses Thread Execution behaviors.
	#Ex/Source: https://den.dev/blog/caffeinate-windows/
	$Signature = @"
[DllImport("kernel32.dll", CharSet = CharSet.Auto, SetLastError = true)]
public static extern void SetThreadExecutionState(uint esFlags);
"@
	
	$ES_DISPLAY_REQUIRED = [uint32]"0x00000002"
	$ES_CONTINUOUS = [uint32]"0x80000000"
	
	$JobName = "DrinkALotOfEspresso"
	
	
	#Start background job to keep system awake.
	$BackgroundJob = Start-Job -Name $JobName -ScriptBlock {
		$STES = Add-Type -MemberDefinition $args[0] -Name System -Namespace Win32 -PassThru
		
		$STES::SetThreadExecutionState($args[2] -bor $args[1])
		
		while ($true)
		{
			Start-Sleep -Seconds 15
		}
	} -ArgumentList $Signature, $ES_DISPLAY_REQUIRED, $ES_CONTINUOUS
	
	while ($stop -ne $true)
	{
		Start-Sleep -seconds $sleep
		
		#Check Duration
		if ($duration -ne 0) #if duration was supplied, I will check it. Otherwise it's an endless loop until exited.
		{
			$presentdate = Get-Date
			if (!($futuredate -ge $presentdate))
			{
				$stop = $true #stop loop
				Stop-Job -Name $JobName -Confirm:$false #media API calls that are keeping system awake. Aka, Cleanup.
				Remove-Job -Name $JobName -Force -Confirm:$false
			}
		}
	}
}
finally
{
	#In case there are unexpected exits, this will clean them up.
	Stop-Job -Name $JobName
	Remove-Job -Name $JobName
}
# SIG # Begin signature block
# MIIk7QYJKoZIhvcNAQcCoIIk3jCCJNoCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCC+VnrHu9KRXYCn
# SA5vkj/io1yVgm5vJnBBsOr4rdXxR6CCH5wwggMFMIIB7aADAgECAhAfK8eaTYBL
# mULrraKbZnX5MA0GCSqGSIb3DQEBCwUAMBUxEzARBgNVBAMTCklUUy1QS0ktUlQw
# HhcNMTUxMjE0MTI1MTMwWhcNMzUxMjE0MTMwMTMwWjAVMRMwEQYDVQQDEwpJVFMt
# UEtJLVJUMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAlWsp5JJIwV4R
# JzEgqTR9LRrVWJbRds/D2aDJK1o74bbeTp+Lr4tTt/JTNaApSqPE1geFZGAyJWQQ
# Uc5qW9ULH2ooP66DJ/fHOETUKlrpKTMy/63Y74rcaJJmmrVWuAq/QiRUp1FZ9snh
# y3LWYrMdIE7vtMtGWHg/aKKsrNXmTQk+8RkGaThc2x38jmw6e6xXMQivBcbgUaZT
# NfTVT5UZ+GVFxRKvo629Wl3ooZDWNM0Mzkeaky0JT917mDXqYezUChABWKw0wxGK
# xohcMmlwc7Gp1aInToX3x9Z8ssvWFlUrqjDRsz+xByw+lWvJpncTcTl1Zp0rnBxr
# fFLGboYlEwIDAQABo1EwTzALBgNVHQ8EBAMCAYYwDwYDVR0TAQH/BAUwAwEB/zAd
# BgNVHQ4EFgQUfRt1pL3PdSiE4+dJah9HjIxLMmUwEAYJKwYBBAGCNxUBBAMCAQAw
# DQYJKoZIhvcNAQELBQADggEBAISNjURl9bhN+A+IvlrGk1xiM4VlWxryPqyheZ/L
# 8uAGQGm2SYBgzl+EynC33G//1Nxx/Ezh1v9m2zM17FDaMBFvM1Z+//0TIWrVjj60
# PZKeT3l/jZlyg3app0RF2wva/kuO0Rpc22offbeWj3jBBWsfetWrf/WcuSoGLP/i
# hsGBVXatSPO4IvbpU7v/6jbajRHGa+GU0Mvz2hfMoe5fc4OWjNz2Dr+g079JrdlH
# k0ssyKpbU2DiXXQIPoe6UCFOY1Tmv/qd6oS4BoYGRnUPx7y+aLSGNaUe2W9dV/ji
# 3Q7io6i+3dte4MAunIWyIkigGs+++iTyOC2szKAXEuljUdYwggS2MIIDnqADAgEC
# AhM2AAAAAshhcEW5fFYUAAAAAAACMA0GCSqGSIb3DQEBCwUAMBUxEzARBgNVBAMT
# CklUUy1QS0ktUlQwHhcNMTUxMjE0MTMyNDIzWhcNMjUxMjE0MTMzNDIzWjBEMRMw
# EQYKCZImiZPyLGQBGRYDZWR1MRMwEQYKCZImiZPyLGQBGRYDZnN1MRgwFgYDVQQD
# Ew9mc3UtSVRTLVBLSS1TVUIwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIB
# AQDbar1hmUO5ZqLMjnaW2tIb/D1J+l2i/KGJrqfTCBX5QDQYiX88rG2osZ6UHYAg
# SiaSW9/DOpQwMvl2BuBaiisP1svZYBuJgoU8CcGMQzfME6RWylIl5ck3InWkx0bh
# krgAC4m9/omJM8JKcB24eMLLAEuyzuuHIiYrfp7Ik0XyeqfTlnjd8/ZuSJM4jl+q
# XBYdeVJTVaHfkp14D2Z6iUjHg4UhOOJ8ebKVV9bSf3iZC9PykXj0CEYk0E2qBK1c
# 1vuE9fy0Gg177WmbBof4EWEc7ZX8pXj11kLEUSvCjJjfBnCL7fPYgJrvrfVusm02
# 2r50ZieGfZ+KwaVWFmRgu+VNAgMBAAGjggHOMIIByjAQBgkrBgEEAYI3FQEEAwIB
# ADAdBgNVHQ4EFgQU7oXURG6+4/E3NYWspy2mXp0w5EYwGQYJKwYBBAGCNxQCBAwe
# CgBTAHUAYgBDAEEwCwYDVR0PBAQDAgGGMA8GA1UdEwEB/wQFMAMBAf8wHwYDVR0j
# BBgwFoAUfRt1pL3PdSiE4+dJah9HjIxLMmUwPQYDVR0fBDYwNDAyoDCgLoYsaHR0
# cDovL2l0cy1wa2ktc3ViL0NlcnRFbnJvbGwvSVRTLVBLSS1SVC5jcmwwgf0GCCsG
# AQUFBwEBBIHwMIHtMIGlBggrBgEFBQcwAoaBmGxkYXA6Ly8vQ049SVRTLVBLSS1S
# VCxDTj1BSUEsQ049UHVibGljJTIwS2V5JTIwU2VydmljZXMsQ049U2VydmljZXMs
# Y249Y29uZmlndXJhdGlvbixkYz1mc3UsZGM9ZWR1P2NBQ2VydGlmaWNhdGU/YmFz
# ZT9vYmplY3RDbGFzcz1jZXJ0aWZpY2F0aW9uQXV0aG9yaXR5MEMGCCsGAQUFBzAC
# hjdodHRwOi8vaXRzLXBraS1zdWIvQ2VydEVucm9sbC9JVFMtUEtJLVJUX0lUUy1Q
# S0ktUlQuY3J0MA0GCSqGSIb3DQEBCwUAA4IBAQATUcfWf/KCS6qnYs71tEuA2dWX
# yGFmzjkrdLKEtsoGvcX73hXJ/Ssih6SpCgbX0gY+B9rT6CtoV6gAtUcLUO9nOBni
# Ps4R2PQUKc9GOM9jVJHYf6Qha4PK5NWqgCH4qZlqNpK/z4P6pK/VX/QWvvJYHV5E
# l+kCgSIP+eK4BFRU/mZBxWCF2lyGL//Og1rABRA8wKIgSS0zC1xg3YNJhZiQMgSQ
# wW4w5/36twwvgQ+xht5vNaKk6Jiu7Tm/KkPyaD7S6q4Xr0A9vRmMnq6R+3ciGr3h
# UpEZATNh4KGMUnkd1SmNgE6/5VY1BUrSG17lPsrrx05rPz56J7pE7D5i6E5xMIIF
# gzCCA2ugAwIBAgIORea7A4Mzw4VlSOb/RVEwDQYJKoZIhvcNAQEMBQAwTDEgMB4G
# A1UECxMXR2xvYmFsU2lnbiBSb290IENBIC0gUjYxEzARBgNVBAoTCkdsb2JhbFNp
# Z24xEzARBgNVBAMTCkdsb2JhbFNpZ24wHhcNMTQxMjEwMDAwMDAwWhcNMzQxMjEw
# MDAwMDAwWjBMMSAwHgYDVQQLExdHbG9iYWxTaWduIFJvb3QgQ0EgLSBSNjETMBEG
# A1UEChMKR2xvYmFsU2lnbjETMBEGA1UEAxMKR2xvYmFsU2lnbjCCAiIwDQYJKoZI
# hvcNAQEBBQADggIPADCCAgoCggIBAJUH6HPKZvnsFMp7PPcNCPG0RQssgrRIxutb
# PK6DuEGSMxSkb3/pKszGsIhrxbaJ0cay/xTOURQh7ErdG1rG1ofuTToVBu1kZguS
# gMpE3nOUTvOniX9PeGMIyBJQbUJmL025eShNUhqKGoC3GYEOfsSKvGRMIRxDaNc9
# PIrFsmbVkJq3MQbFvuJtMgamHvm566qjuL++gmNQ0PAYid/kD3n16qIfKtJwLnvn
# vJO7bVPiSHyMEAc4/2ayd2F+4OqMPKq0pPbzlUoSB239jLKJz9CgYXfIWHSw1CM6
# 9106yqLbnQneXUQtkPGBzVeS+n68UARjNN9rkxi+azayOeSsJDa38O+2HBNXk7be
# svjihbdzorg1qkXy4J02oW9UivFyVm4uiMVRQkQVlO6jxTiWm05OWgtH8wY2SXcw
# vHE35absIQh1/OZhFj931dmRl4QKbNQCTXTAFO39OfuD8l4UoQSwC+n+7o/hbguy
# CLNhZglqsQY6ZZZZwPA1/cnaKI0aEYdwgQqomnUdnjqGBQCe24DWJfncBZ4nWUx2
# OVvq+aWh2IMP0f/fMBH5hc8zSPXKbWQULHpYT9NLCEnFlWQaYw55PfWzjMpYrZxC
# RXluDocZXFSxZba/jJvcE+kNb7gu3GduyYsRtYQUigAZcIN5kZeR1BonvzceMgfY
# FGM8KEyvAgMBAAGjYzBhMA4GA1UdDwEB/wQEAwIBBjAPBgNVHRMBAf8EBTADAQH/
# MB0GA1UdDgQWBBSubAWjkxPioufi1xzWx/B/yGdToDAfBgNVHSMEGDAWgBSubAWj
# kxPioufi1xzWx/B/yGdToDANBgkqhkiG9w0BAQwFAAOCAgEAgyXt6NH9lVLNnsAE
# oJFp5lzQhN7craJP6Ed41mWYqVuoPId8AorRbrcWc+ZfwFSY1XS+wc3iEZGtIxg9
# 3eFyRJa0lV7Ae46ZeBZDE1ZXs6KzO7V33EByrKPrmzU+sQghoefEQzd5Mr6155ws
# TLxDKZmOMNOsIeDjHfrYBzN2VAAiKrlNIC5waNrlU/yDXNOd8v9EDERm8tLjvUYA
# Gm0CuiVdjaExUd1URhxN25mW7xocBFymFe944Hn+Xds+qkxV/ZoVqW/hpvvfcDDp
# w+5CRu3CkwWJ+n1jez/QcYF8AOiYrg54NMMl+68KnyBr3TsTjxKM4kEaSHpzoHdp
# x7Zcf4LIHv5YGygrqGytXm3ABdJ7t+uA/iU3/gKbaKxCXcPu9czc8FB10jZpnOZ7
# BN9uBmm23goJSFmH63sUYHpkqmlD75HHTOwY3WzvUy2MmeFe8nI+z1TIvWfspA9M
# Rf/TuTAjB0yPEL+GltmZWrSZVxykzLsViVO6LAUP5MSeGbEYNNVMnbrt9x+vJJUE
# eKgDu+6B5dpffItKoZB0JaezPkvILFa9x8jvOOJckvB595yEunQtYQEgfn7R8k8H
# WV+LLUNS60YMlOH1Zkd5d9VUWx+tJDfLRVpOoERIyNiwmcUVhAn21klJwGW45hpx
# bqCo8YLoRT5s1gLXCmeDBVrJpBAwggWFMIIEbaADAgECAhNQAAEKUJiOaSLmD7G6
# AAAAAQpQMA0GCSqGSIb3DQEBCwUAMEQxEzARBgoJkiaJk/IsZAEZFgNlZHUxEzAR
# BgoJkiaJk/IsZAEZFgNmc3UxGDAWBgNVBAMTD2ZzdS1JVFMtUEtJLVNVQjAeFw0y
# MDA2MTExOTUwMzlaFw0yMzA2MTExOTUwMzlaMIGCMRMwEQYKCZImiZPyLGQBGRYD
# ZWR1MRMwEQYKCZImiZPyLGQBGRYDZnN1MRswGQYDVQQLExJGU1UgU2VydmljZSBB
# ZG1pbnMxFzAVBgNVBAsTDkFkbWluIEFjY291bnRzMQ0wCwYDVQQLEwRNU1RTMREw
# DwYDVQQDEwhtY25lbHNvbjB2MBAGByqGSM49AgEGBSuBBAAiA2IABEtbXVG4Lm6t
# DjEJ7TV59etXVk7Nofv8kNtKlbCsxjknoqpDtbAV55uC//PLDhHbsiCQFwU1vv0W
# 1EN2kNPDF5zLVGEpJBJhP95YF4FfnMEkDTFdJmXR/UdJx8i/Su73taOCAt0wggLZ
# MD0GCSsGAQQBgjcVBwQwMC4GJisGAQQBgjcVCIWy4GeB/KR3hMWPGoTwkzmB1OMH
# gV2G+cUQwfUZAgFkAgEFMBMGA1UdJQQMMAoGCCsGAQUFBwMDMAsGA1UdDwQEAwIH
# gDAbBgkrBgEEAYI3FQoEDjAMMAoGCCsGAQUFBwMDMB0GA1UdDgQWBBSa6yhcBUPv
# qAt3J7ZG69JMRlrfQDAfBgNVHSMEGDAWgBTuhdREbr7j8Tc1haynLaZenTDkRjCB
# zQYDVR0fBIHFMIHCMIG/oIG8oIG5hoG2bGRhcDovLy9DTj1mc3UtSVRTLVBLSS1T
# VUIsQ049aXRzLXBraS1zdWIsQ049Q0RQLENOPVB1YmxpYyUyMEtleSUyMFNlcnZp
# Y2VzLENOPVNlcnZpY2VzLENOPUNvbmZpZ3VyYXRpb24sREM9ZnN1LERDPWVkdT9j
# ZXJ0aWZpY2F0ZVJldm9jYXRpb25MaXN0P2Jhc2U/b2JqZWN0Q2xhc3M9Y1JMRGlz
# dHJpYnV0aW9uUG9pbnQwggEaBggrBgEFBQcBAQSCAQwwggEIMIGqBggrBgEFBQcw
# AoaBnWxkYXA6Ly8vQ049ZnN1LUlUUy1QS0ktU1VCLENOPUFJQSxDTj1QdWJsaWMl
# MjBLZXklMjBTZXJ2aWNlcyxDTj1TZXJ2aWNlcyxDTj1Db25maWd1cmF0aW9uLERD
# PWZzdSxEQz1lZHU/Y0FDZXJ0aWZpY2F0ZT9iYXNlP29iamVjdENsYXNzPWNlcnRp
# ZmljYXRpb25BdXRob3JpdHkwWQYIKwYBBQUHMAKGTWh0dHA6Ly9pdHMtcGtpLXN1
# Yi5mc3UuZWR1L0NlcnRFbnJvbGwvaXRzLXBraS1zdWIuZnN1LmVkdV9mc3UtSVRT
# LVBLSS1TVUIuY3J0MCsGA1UdEQQkMCKgIAYKKwYBBAGCNxQCA6ASDBBtY25lbHNv
# bkBmc3UuZWR1MA0GCSqGSIb3DQEBCwUAA4IBAQAdLn1Fo5C5ebAEALH313N8v5Yz
# ctlp5ogVkejVFKBbaFfbywwPdqDnGWtwn8utSK7q1nOiNYQaqeXxS0q+2ITmYeLK
# Qn+qT8I6DLzD2TmqTdibALRwBZQ4elGEIjFhbJUU2qpML5w8DMItcYSC+q2U3jDw
# NdRLTrmZ71kyjs7Xka0KteP88xsLZs492JLcxs6u0XgUGzafWIuE0jhgNRDRuhVM
# z7U038CTFMtOGywPXSletjQdFqBWjVjzAP9TEtpuJYEhxmPMJ8suGLrIPNopYyaw
# ayFbpPhNrKoquVNS0QYmAFNe4AEVqSVo9vv3G8HvEmN1hiriBsoo3tOPgBMnMIIG
# WTCCBEGgAwIBAgINAewckkDe/S5AXXxHdDANBgkqhkiG9w0BAQwFADBMMSAwHgYD
# VQQLExdHbG9iYWxTaWduIFJvb3QgQ0EgLSBSNjETMBEGA1UEChMKR2xvYmFsU2ln
# bjETMBEGA1UEAxMKR2xvYmFsU2lnbjAeFw0xODA2MjAwMDAwMDBaFw0zNDEyMTAw
# MDAwMDBaMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNh
# MTEwLwYDVQQDEyhHbG9iYWxTaWduIFRpbWVzdGFtcGluZyBDQSAtIFNIQTM4NCAt
# IEc0MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEA8ALiMCP64BvhmnSz
# r3WDX6lHUsdhOmN8OSN5bXT8MeR0EhmW+s4nYluuB4on7lejxDXtszTHrMMM64Bm
# bdEoSsEsu7lw8nKujPeZWl12rr9EqHxBJI6PusVP/zZBq6ct/XhOQ4j+kxkX2e4x
# z7yKO25qxIjw7pf23PMYoEuZHA6HpybhiMmg5ZninvScTD9dW+y279Jlz0ULVD2x
# VFMHi5luuFSZiqgxkjvyen38DljfgWrhsGweZYIq1CHHlP5CljvxC7F/f0aYDoc9
# emXr0VapLr37WD21hfpTmU1bdO1yS6INgjcZDNCr6lrB7w/Vmbk/9E818ZwP0zcT
# UtklNO2W7/hn6gi+j0l6/5Cx1PcpFdf5DV3Wh0MedMRwKLSAe70qm7uE4Q6sbw25
# tfZtVv6KHQk+JA5nJsf8sg2glLCylMx75mf+pliy1NhBEsFV/W6RxbuxTAhLntRC
# Bm8bGNU26mSuzv31BebiZtAOBSGssREGIxnk+wU0ROoIrp1JZxGLguWtWoanZv0z
# AwHemSX5cW7pnF0CTGA8zwKPAf1y7pLxpxLeQhJN7Kkm5XcCrA5XDAnRYZ4miPzI
# sk3bZPBFn7rBP1Sj2HYClWxqjcoiXPYMBOMp+kuwHNM3dITZHWarNHOPHn18XpbW
# PRmwl+qMUJFtr1eGfhA3HWsaFN8CAwEAAaOCASkwggElMA4GA1UdDwEB/wQEAwIB
# hjASBgNVHRMBAf8ECDAGAQH/AgEAMB0GA1UdDgQWBBTqFsZp5+PLV0U5M6TwQL7Q
# w71lljAfBgNVHSMEGDAWgBSubAWjkxPioufi1xzWx/B/yGdToDA+BggrBgEFBQcB
# AQQyMDAwLgYIKwYBBQUHMAGGImh0dHA6Ly9vY3NwMi5nbG9iYWxzaWduLmNvbS9y
# b290cjYwNgYDVR0fBC8wLTAroCmgJ4YlaHR0cDovL2NybC5nbG9iYWxzaWduLmNv
# bS9yb290LXI2LmNybDBHBgNVHSAEQDA+MDwGBFUdIAAwNDAyBggrBgEFBQcCARYm
# aHR0cHM6Ly93d3cuZ2xvYmFsc2lnbi5jb20vcmVwb3NpdG9yeS8wDQYJKoZIhvcN
# AQEMBQADggIBAH/iiNlXZytCX4GnCQu6xLsoGFbWTL/bGwdwxvsLCa0AOmAzHznG
# FmsZQEklCB7km/fWpA2PHpbyhqIX3kG/T+G8q83uwCOMxoX+SxUk+RhE7B/CpKzQ
# ss/swlZlHb1/9t6CyLefYdO1RkiYlwJnehaVSttixtCzAsw0SEVV3ezpSp9eFO1y
# EHF2cNIPlvPqN1eUkRiv3I2ZOBlYwqmhfqJuFSbqtPl/KufnSGRpL9KaoXL29yRL
# dFp9coY1swJXH4uc/LusTN763lNMg/0SsbZJVU91naxvSsguarnKiMMSME6yCHOf
# XqHWmc7pfUuWLMwWaxjN5Fk3hgks4kXWss1ugnWl2o0et1sviC49ffHykTAFnM57
# fKDFrK9RBvARxx0wxVFWYOh8lT0i49UKJFMnl4D6SIknLHniPOWbHuOqhIKJPsBK
# 9SH+YhDtHTD89szqSCd8i3VCf2vL86VrlR8EWDQKie2CUOTRe6jJ5r5IqitV2Y23
# JSAOG1Gg1GOqg+pscmFKyfpDxMZXxZ22PLCLsLkcMe+97xTYFEBsIB3CLegLxo1t
# jLZx7VIh/j72n585Gq6s0i96ILH0rKod4i0UnfqWah3GPMrz2Ry/U02kR1l8lcRD
# Qfkl4iwQfoH5DZSnffK1CfXYYHJAUJUg1ENEvvqglecgWbZ4xqRqqiKbMIIGaDCC
# BFCgAwIBAgIQAUiQPcKKvKehGU0MHFe4KTANBgkqhkiG9w0BAQsFADBbMQswCQYD
# VQQGEwJCRTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTExMC8GA1UEAxMoR2xv
# YmFsU2lnbiBUaW1lc3RhbXBpbmcgQ0EgLSBTSEEzODQgLSBHNDAeFw0yMjA0MDYw
# NzQxNThaFw0zMzA1MDgwNzQxNThaMGMxCzAJBgNVBAYTAkJFMRkwFwYDVQQKDBBH
# bG9iYWxTaWduIG52LXNhMTkwNwYDVQQDDDBHbG9iYWxzaWduIFRTQSBmb3IgTVMg
# QXV0aGVudGljb2RlIEFkdmFuY2VkIC0gRzQwggGiMA0GCSqGSIb3DQEBAQUAA4IB
# jwAwggGKAoIBgQDCydwDthtQ+ioN6JykIdsopx31gLUSdCP+Xi/DGl2WsiAZGVBf
# diMmNcYh7JTvtaI6xZCBmyHvCyek4xdkO9qT1FYvPNdY+W2swC+QeCNJwPjBj3AT
# 1GvfJohadntI9+Gkpu8LGvMlVA+AniMSEhPRsPcC4ysN/0A+AEJD3hrvTPSHqfKe
# PNAG5+Jj0utMW91dWJTT5aU5KKoHXnYjMPz8f5gNxWVtG9V0RTpGsKIWdd6iwipw
# fLZ2vNkbrrpdnPaHlc6qqOK1o7GTbkClmxCIdhZONKH8nvHhGlTRyCRXlHatwsfs
# o6OWdeLGKGsCBehLubXgUit4AYwqMSxM6AXlb58PhCYuaGz6y00ZfBjB/2oaqcu+
# o3X46cgYsszdL0FAIBzPiAsXybCKQ8via5NR8RG+Qrz4UfLaAAK+CBgoBSfE3Dtd
# dykeGdRBKmZ9tFJzXEKlkNONxaOqN85zAZQkGUJD0ZSPS37dy228G057+aoLIktJ
# gElwGy1P3jRgPr0CAwEAAaOCAZ4wggGaMA4GA1UdDwEB/wQEAwIHgDAWBgNVHSUB
# Af8EDDAKBggrBgEFBQcDCDAdBgNVHQ4EFgQUW2t79HB0CMENKsjv8cS5QNJKxv0w
# TAYDVR0gBEUwQzBBBgkrBgEEAaAyAR4wNDAyBggrBgEFBQcCARYmaHR0cHM6Ly93
# d3cuZ2xvYmFsc2lnbi5jb20vcmVwb3NpdG9yeS8wDAYDVR0TAQH/BAIwADCBkAYI
# KwYBBQUHAQEEgYMwgYAwOQYIKwYBBQUHMAGGLWh0dHA6Ly9vY3NwLmdsb2JhbHNp
# Z24uY29tL2NhL2dzdHNhY2FzaGEzODRnNDBDBggrBgEFBQcwAoY3aHR0cDovL3Nl
# Y3VyZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvZ3N0c2FjYXNoYTM4NGc0LmNydDAf
# BgNVHSMEGDAWgBTqFsZp5+PLV0U5M6TwQL7Qw71lljBBBgNVHR8EOjA4MDagNKAy
# hjBodHRwOi8vY3JsLmdsb2JhbHNpZ24uY29tL2NhL2dzdHNhY2FzaGEzODRnNC5j
# cmwwDQYJKoZIhvcNAQELBQADggIBAC5rPo9/sLBg2fGdhNyVtt9fDb8kUeMaBqpV
# BMthwe9lca4L/ZQkVwDH5PYMvBiVfS8ZamAzpr7QCFVWBLbj/h675RB2VDurXCFe
# KjVNRsumTLoEQGBgLNvT9p3eyjIQDHiwu1bFB0twvKcPq3K8jcvr7sFMa9n6mKF0
# PumoyHl8dndI/c/j8A3B6cOS4AcMEy8/a3812dW37m98WMDxPwwZsgKjSUycBMPw
# tJen4E1qJbo0FmJmyHi8aXOqX3KiNVgeJuu/MhSqEnrr9JZrf3Ks6qc5CDMBNj5h
# JH4RnREediJU40C7LoYMdp5p0sQcPaILjIgEA1Te6RsX/iwrntnWWyI4/GRAhs0X
# f+Gpn7m/kkGobyZq9A8osECRkC9OtnZQvE0j2X9Pa5Mpp2zn0DA+qZMfwlArOcWy
# +E0nJNH9dti++ZP0qVQK1XZY0Tye6hroJMT7NvEvWdOSw+zLYFIeHEYlCP9+2ZOu
# FJWohooHLlSLc0w3FThQVofxT64cj8mhbC8L/Lscby29qrbraCPw7ZQnFGPLrPRn
# iiyB0xQSGAE/hHqu7EdgP2hYmclKwqGZFQXCrd6i79enVXy8hBtNlLuOSoVE2YE9
# qqMlVV+ka802bAD5/3LeWuz/yaBBlhpAaoWRHK91Y6jLWjO1lDN+so0Pc76H/K86
# cx97INtyMYIEpzCCBKMCAQEwWzBEMRMwEQYKCZImiZPyLGQBGRYDZWR1MRMwEQYK
# CZImiZPyLGQBGRYDZnN1MRgwFgYDVQQDEw9mc3UtSVRTLVBLSS1TVUICE1AAAQpQ
# mI5pIuYPsboAAAABClAwDQYJYIZIAWUDBAIBBQCgTDAZBgkqhkiG9w0BCQMxDAYK
# KwYBBAGCNwIBBDAvBgkqhkiG9w0BCQQxIgQg9Ri6xRIvhbmrazAtNNmIagHtTFc8
# MtcHrBQZTfnyW7AwCwYHKoZIzj0CAQUABGcwZQIwWnsUiNfjxAWH6rMR8oM41q0e
# j0jZuslrBFuLTLik3dWvR5FpQENQaIJswY4KQNvFAjEA4LwZ+4OOJvaQu39j1C3h
# Xbu9ViSHgTOjjOb6lZSq+E+Y4eBQGThV5MqC4cnSitGRoYIDbDCCA2gGCSqGSIb3
# DQEJBjGCA1kwggNVAgEBMG8wWzELMAkGA1UEBhMCQkUxGTAXBgNVBAoTEEdsb2Jh
# bFNpZ24gbnYtc2ExMTAvBgNVBAMTKEdsb2JhbFNpZ24gVGltZXN0YW1waW5nIENB
# IC0gU0hBMzg0IC0gRzQCEAFIkD3CirynoRlNDBxXuCkwCwYJYIZIAWUDBAIBoIIB
# PTAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0yMjEx
# MjExOTQ5MzRaMCsGCSqGSIb3DQEJNDEeMBwwCwYJYIZIAWUDBAIBoQ0GCSqGSIb3
# DQEBCwUAMC8GCSqGSIb3DQEJBDEiBCDxVkmcRoNM5hC1UuMcijXQhm0bvuz4bmfR
# C/hfyu4pwTCBpAYLKoZIhvcNAQkQAgwxgZQwgZEwgY4wgYsEFDEDDhdqpFkuqyyL
# regymfy1WF3PMHMwX6RdMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxT
# aWduIG52LXNhMTEwLwYDVQQDEyhHbG9iYWxTaWduIFRpbWVzdGFtcGluZyBDQSAt
# IFNIQTM4NCAtIEc0AhABSJA9woq8p6EZTQwcV7gpMA0GCSqGSIb3DQEBCwUABIIB
# gAYEu8ueeVkCV1O4nlgkKgrX/xhTRJlTkmV5t714dgMTlO4+Cr5bgM2uyAV3KyiP
# mu/1uJPma2t4af6wfzJsxddwwf6XxQCwkYiwG5bqRFs74VlAIY9VwHHpOShzjE7H
# seiXKuC//okdUbutmSsc5kI2XW4FtJO+sY6u0LXyT1HRIakHeZ2cyuTr6nvtJR2e
# gJbkt2yag2bNJonIX4VMqUJIFtHSu8Yvt1+uUEQH/xwuZiGwRd+uSKRafNC5m3g4
# wkkBW88ErjWD9GfuxYJWNmVvBzEAg7b2vVYOPMihBVEI1aWej//9uUQxGo7ch2tL
# yNZBzJogGk/nE/JfAiZ3B+JzAR/piDQHnKhvVc+xqE/jevrNc8O8kzlDcoCtM+ZJ
# DNbmOVlxBXkCvFiuxSl0xCE+7leJdrkZDW8IW4RAsZPwev92PT8BlWT5q89rpeeg
# MTM7CNNjkrtVWMljA6tiyTXKYgVqsN2pyiIZDWCJ53rGlykb45cBw0bC+Cv2r7HX
# DA==
# SIG # End signature block