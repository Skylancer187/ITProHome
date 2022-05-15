<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2022 v5.8.206
	 Created on:   	5/12/2022 10:02 PM
	 Created by:   	Skylancer
	 Organization: 	
	 Filename:     	Install-PatchMyPCHome.ps1
	===========================================================================
	.DESCRIPTION
		Download and setup scheduled task for PatchMyPC Home.
		Just a handy tool to help home users and IT Professionals to get users updated and secured at home.
#>

$URI = "https://patchmypc.com/freeupdater/PatchMyPC.exe"
$xml = "//48AD8AeABtAGwAIAB2AGUAcgBzAGkAbwBuAD0AIgAxAC4AMAAiACAAZQBuAGMAbwBkAGkAbgBnAD0AIgBVAFQARgAtADEANgAiAD8APgANAAoAPABUAGEAcwBrACAAdgBlAHIAcwBpAG8AbgA9ACIAMQAuADIAIgAgAHgAbQBsAG4AcwA9ACIAaAB0AHQAcAA6AC8ALwBzAGMAaABlAG0AYQBzAC4AbQBpAGMAcgBvAHMAbwBmAHQALgBjAG8AbQAvAHcAaQBuAGQAbwB3AHMALwAyADAAMAA0AC8AMAAyAC8AbQBpAHQALwB0AGEAcwBrACIAPgANAAoAIAAgADwAUgBlAGcAaQBzAHQAcgBhAHQAaQBvAG4ASQBuAGYAbwA+AA0ACgAgACAAIAAgADwARABhAHQAZQA+ADIAMAAyADIALQAwADUALQAwADYAVAAxADEAOgA1ADQAOgAxADcALgAxADkAMQAtADAANAA6ADAAMAA8AC8ARABhAHQAZQA+AA0ACgAgACAAIAAgADwARABlAHMAYwByAGkAcAB0AGkAbwBuAD4AVABhAHMAawAgAHQAbwAgAGwAYQB1AG4AYwBoACAAUABhAHQAYwBoACAATQB5ACAAUABDACAAdABvACAAdQBwAGQAYQB0AGUAIAB5AG8AdQByACAAcwB5AHMAdABlAG0ALgA8AC8ARABlAHMAYwByAGkAcAB0AGkAbwBuAD4ADQAKACAAIAAgACAAPABVAFIASQA+AFwAUABhAHQAYwBoACAATQB5ACAAUABDADwALwBVAFIASQA+AA0ACgAgACAAPAAvAFIAZQBnAGkAcwB0AHIAYQB0AGkAbwBuAEkAbgBmAG8APgANAAoAIAAgADwAVAByAGkAZwBnAGUAcgBzAD4ADQAKACAAIAAgACAAPABDAGEAbABlAG4AZABhAHIAVAByAGkAZwBnAGUAcgA+AA0ACgAgACAAIAAgACAAIAA8AFMAdABhAHIAdABCAG8AdQBuAGQAYQByAHkAPgAyADAAMgAyAC0AMAA1AC0AMAA2AFQAMAA0ADoAMAAwADoAMAAwAC0AMAA0ADoAMAAwADwALwBTAHQAYQByAHQAQgBvAHUAbgBkAGEAcgB5AD4ADQAKACAAIAAgACAAIAAgADwARQBuAGEAYgBsAGUAZAA+AHQAcgB1AGUAPAAvAEUAbgBhAGIAbABlAGQAPgANAAoAIAAgACAAIAAgACAAPABTAGMAaABlAGQAdQBsAGUAQgB5AEQAYQB5AD4ADQAKACAAIAAgACAAIAAgACAAIAA8AEQAYQB5AHMASQBuAHQAZQByAHYAYQBsAD4AMQA8AC8ARABhAHkAcwBJAG4AdABlAHIAdgBhAGwAPgANAAoAIAAgACAAIAAgACAAPAAvAFMAYwBoAGUAZAB1AGwAZQBCAHkARABhAHkAPgANAAoAIAAgACAAIAA8AC8AQwBhAGwAZQBuAGQAYQByAFQAcgBpAGcAZwBlAHIAPgANAAoAIAAgADwALwBUAHIAaQBnAGcAZQByAHMAPgANAAoAIAAgADwAUAByAGkAbgBjAGkAcABhAGwAcwA+AA0ACgAgACAAIAAgADwAUAByAGkAbgBjAGkAcABhAGwAIABpAGQAPQAiAEEAdQB0AGgAbwByACIAPgANAAoAIAAgACAAIAAgACAAPABVAHMAZQByAEkAZAA+AFMALQAxAC0ANQAtADEAOAA8AC8AVQBzAGUAcgBJAGQAPgANAAoAIAAgACAAIAAgACAAPABSAHUAbgBMAGUAdgBlAGwAPgBIAGkAZwBoAGUAcwB0AEEAdgBhAGkAbABhAGIAbABlADwALwBSAHUAbgBMAGUAdgBlAGwAPgANAAoAIAAgACAAIAA8AC8AUAByAGkAbgBjAGkAcABhAGwAPgANAAoAIAAgADwALwBQAHIAaQBuAGMAaQBwAGEAbABzAD4ADQAKACAAIAA8AFMAZQB0AHQAaQBuAGcAcwA+AA0ACgAgACAAIAAgADwATQB1AGwAdABpAHAAbABlAEkAbgBzAHQAYQBuAGMAZQBzAFAAbwBsAGkAYwB5AD4ASQBnAG4AbwByAGUATgBlAHcAPAAvAE0AdQBsAHQAaQBwAGwAZQBJAG4AcwB0AGEAbgBjAGUAcwBQAG8AbABpAGMAeQA+AA0ACgAgACAAIAAgADwARABpAHMAYQBsAGwAbwB3AFMAdABhAHIAdABJAGYATwBuAEIAYQB0AHQAZQByAGkAZQBzAD4AZgBhAGwAcwBlADwALwBEAGkAcwBhAGwAbABvAHcAUwB0AGEAcgB0AEkAZgBPAG4AQgBhAHQAdABlAHIAaQBlAHMAPgANAAoAIAAgACAAIAA8AFMAdABvAHAASQBmAEcAbwBpAG4AZwBPAG4AQgBhAHQAdABlAHIAaQBlAHMAPgBmAGEAbABzAGUAPAAvAFMAdABvAHAASQBmAEcAbwBpAG4AZwBPAG4AQgBhAHQAdABlAHIAaQBlAHMAPgANAAoAIAAgACAAIAA8AEEAbABsAG8AdwBIAGEAcgBkAFQAZQByAG0AaQBuAGEAdABlAD4AdAByAHUAZQA8AC8AQQBsAGwAbwB3AEgAYQByAGQAVABlAHIAbQBpAG4AYQB0AGUAPgANAAoAIAAgACAAIAA8AFMAdABhAHIAdABXAGgAZQBuAEEAdgBhAGkAbABhAGIAbABlAD4AdAByAHUAZQA8AC8AUwB0AGEAcgB0AFcAaABlAG4AQQB2AGEAaQBsAGEAYgBsAGUAPgANAAoAIAAgACAAIAA8AFIAdQBuAE8AbgBsAHkASQBmAE4AZQB0AHcAbwByAGsAQQB2AGEAaQBsAGEAYgBsAGUAPgB0AHIAdQBlADwALwBSAHUAbgBPAG4AbAB5AEkAZgBOAGUAdAB3AG8AcgBrAEEAdgBhAGkAbABhAGIAbABlAD4ADQAKACAAIAAgACAAPABJAGQAbABlAFMAZQB0AHQAaQBuAGcAcwA+AA0ACgAgACAAIAAgACAAIAA8AEQAdQByAGEAdABpAG8AbgA+AFAAVAAxADAATQA8AC8ARAB1AHIAYQB0AGkAbwBuAD4ADQAKACAAIAAgACAAIAAgADwAVwBhAGkAdABUAGkAbQBlAG8AdQB0AD4AUABUADEASAA8AC8AVwBhAGkAdABUAGkAbQBlAG8AdQB0AD4ADQAKACAAIAAgACAAIAAgADwAUwB0AG8AcABPAG4ASQBkAGwAZQBFAG4AZAA+AHQAcgB1AGUAPAAvAFMAdABvAHAATwBuAEkAZABsAGUARQBuAGQAPgANAAoAIAAgACAAIAAgACAAPABSAGUAcwB0AGEAcgB0AE8AbgBJAGQAbABlAD4AZgBhAGwAcwBlADwALwBSAGUAcwB0AGEAcgB0AE8AbgBJAGQAbABlAD4ADQAKACAAIAAgACAAPAAvAEkAZABsAGUAUwBlAHQAdABpAG4AZwBzAD4ADQAKACAAIAAgACAAPABBAGwAbABvAHcAUwB0AGEAcgB0AE8AbgBEAGUAbQBhAG4AZAA+AHQAcgB1AGUAPAAvAEEAbABsAG8AdwBTAHQAYQByAHQATwBuAEQAZQBtAGEAbgBkAD4ADQAKACAAIAAgACAAPABFAG4AYQBiAGwAZQBkAD4AdAByAHUAZQA8AC8ARQBuAGEAYgBsAGUAZAA+AA0ACgAgACAAIAAgADwASABpAGQAZABlAG4APgBmAGEAbABzAGUAPAAvAEgAaQBkAGQAZQBuAD4ADQAKACAAIAAgACAAPABSAHUAbgBPAG4AbAB5AEkAZgBJAGQAbABlAD4AZgBhAGwAcwBlADwALwBSAHUAbgBPAG4AbAB5AEkAZgBJAGQAbABlAD4ADQAKACAAIAAgACAAPABXAGEAawBlAFQAbwBSAHUAbgA+AGYAYQBsAHMAZQA8AC8AVwBhAGsAZQBUAG8AUgB1AG4APgANAAoAIAAgACAAIAA8AEUAeABlAGMAdQB0AGkAbwBuAFQAaQBtAGUATABpAG0AaQB0AD4AUABUADMASAA8AC8ARQB4AGUAYwB1AHQAaQBvAG4AVABpAG0AZQBMAGkAbQBpAHQAPgANAAoAIAAgACAAIAA8AFAAcgBpAG8AcgBpAHQAeQA+ADcAPAAvAFAAcgBpAG8AcgBpAHQAeQA+AA0ACgAgACAAPAAvAFMAZQB0AHQAaQBuAGcAcwA+AA0ACgAgACAAPABBAGMAdABpAG8AbgBzACAAQwBvAG4AdABlAHgAdAA9ACIAQQB1AHQAaABvAHIAIgA+AA0ACgAgACAAIAAgADwARQB4AGUAYwA+AA0ACgAgACAAIAAgACAAIAA8AEMAbwBtAG0AYQBuAGQAPgBDADoAXABUAGUAYwBoAFwAUABhAHQAYwBoAE0AeQBQAEMAXABQAGEAdABjAGgATQB5AFAAQwAuAGUAeABlADwALwBDAG8AbQBtAGEAbgBkAD4ADQAKACAAIAAgACAAIAAgADwAQQByAGcAdQBtAGUAbgB0AHMAPgAvAHMAaQBsAGUAbgB0ADwALwBBAHIAZwB1AG0AZQBuAHQAcwA+AA0ACgAgACAAIAAgADwALwBFAHgAZQBjAD4ADQAKACAAIAA8AC8AQQBjAHQAaQBvAG4AcwA+AA0ACgA8AC8AVABhAHMAawA+AA=="
$localPath = "$env:SystemDrive\Tech\PatchMyPC"
$TempDir = "$localPath\Download"
$internet = [bool]((Get-NetConnectionProfile).IPv4Connectivity -contains "Internet")

function Create-Shortcut
{
	param ([string]$SourceExe,
		[string]$DestinationPath)
	
	$WshShell = New-Object -comObject WScript.Shell
	$Shortcut = $WshShell.CreateShortcut($DestinationPath)
	$Shortcut.TargetPath = $SourceExe
	$Shortcut.Save()
}

function Get-ScriptDirectory
{
<#
	.SYNOPSIS
		Get-ScriptDirectory returns the proper location of the script.

	.OUTPUTS
		System.String
	
	.NOTES
		Returns the correct path within a packaged executable.
#>
	[OutputType([string])]
	param ()
	if ($null -ne $hostinvocation)
	{
		Split-Path $hostinvocation.MyCommand.path
	}
	else
	{
		Split-Path $script:MyInvocation.MyCommand.Path
	}
}
#Check local path directories and create them
if (!(Test-Path $localPath))
{
	New-Item -Path $localPath -ItemType Directory -Force -Verbose -Confirm:$false
	New-Item -Path $TempDir -ItemType Directory -Force -Verbose -Confirm:$false
}
#Download/Update location files
If ($internet)
{
	if (!(Test-Path -Path $TempDir))
	{
		New-Item -Path $TempDir -ItemType Directory -Force -Verbose -Confirm:$false
	}
	
	if (Test-Path -Path $TempDir\PatchMyPC.exe)
	{
		Remove-Item -Path $TempDir\PatchMyPC.exe -Force -Confirm:$false
	}
	
	Invoke-WebRequest -Uri "$URI" -OutFile "$TempDir\PatchMyPC.exe"
	
	Start-Sleep -Seconds 10
	
	[version]$tempfile = (Get-ChildItem -Path $TempDir\PatchMyPC.exe).VersionInfo.FileVersion
	[version]$currentfile = (Get-ChildItem -Path $localPath\PatchMyPC.exe).VersionInfo.FileVersion
	
	if ($currentfile -eq $null)
	{
		if ($tempfile -gt $currentfile)
		{
			Remove-Item -Path $localPath\PatchMyPC.exe -Force -Confirm:$false
			Move-Item -Path $TempDir\PatchMyPC.exe -Destination $localPath -Force -Confirm:$false
		}
	}
	else
	{
		Move-Item -Path $TempDir\PatchMyPC.exe -Destination $localPath -Force -Confirm:$false
	}
}
else #Try using script directory if Internet not present
{
	$scriptdir = Get-ScriptDirectory
	if (Test-Path $scriptdir\PatchMyPC.exe)
	{
		Copy-Item -Path $scriptdir\PatchMyPC.exe -Destination $localPath -Force -Confirm:$false
	}
}
#XML Content and Task Scheduler
if (Test-Path $localPath\PatchMyPC.exe -ErrorAction Ignore)
{
	
	if (!(Test-Path -Path $localPath\PatchMyPC.xml))
	{
		$base64 = [System.Convert]::FromBase64String($xml)
		Set-Content -Path $localPath\PatchMyPC.xml -Value $base64 -Encoding Byte
	}
	if (!(Get-ScheduledTask -TaskName "Patch My PC - Daily 4AM Update" -ErrorAction Ignore))
	{
		[string]$xml = Get-Content -Path "$localPath\PatchMyPC.xml"
		Register-ScheduledTask -Xml "$xml" -TaskName "Patch My PC - Daily 4AM Update"
	}
	
	Start-Sleep -Seconds 10
	
	Create-Shortcut -SourceExe "$localPath\PatchMyPC.exe" -DestinationPath "$env:ALLUSERSPROFILE\Desktop\PatchMyPC.lnk"
	
	Get-ScheduledTask -TaskName "Patch My PC - Daily 4AM Update" | Start-ScheduledTask
}
#Check Install
If ((Get-ChildItem -Path $localPath\PatchMyPC.exe) -and (Get-ScheduledTask -TaskName "Patch My PC - Daily 4AM Update") -and (Get-ChildItem -Path "$env:ALLUSERSPROFILE\Desktop\PatchMyPC.lnk"))
{
	Write-Host "Install and Schedule Completed!" -ForegroundColor Green
}
else
{
	Write-Host "Setup did not complete correctly, double-check installation or logs.`nLogs stored in: $localpath\Install.log" -ForegroundColor DarkYellow
}