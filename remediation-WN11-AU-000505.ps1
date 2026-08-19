<#
.SYNOPSIS
    Sets the maximum size of the Windows Security event log to at least 1024000 KB (1 GB).

.NOTES
    Author          : Harsh Sharma
    LinkedIn        : linkedin.com/in/harsh-sharma-hs33
    GitHub          : github.com/Harsh25s
    Date Created    : 2026-08-14
    Last Modified   : 2026-08-19
    Version         : 1.1
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-AU-000505
    Documentation   : https://stigaview.com/products/win11/v2r7/WN11-AU-000505/

.TESTED ON
    Date(s) Tested  : 2026-08-19
    Tested By       : Harsh Sharma
    Systems Tested  : Windows 11 Pro 23H2 (Azure VM)
    PowerShell Ver. : 5.1

.USAGE
    Run in an elevated PowerShell session, then reboot and rescan in Tenable.
    Example syntax:
    PS C:\> .\remediation-WN11-AU-000505.ps1

.NOTE ON THIS CONTROL
    Unlike the Application and System logs, setting the policy registry value alone did NOT
    satisfy the Tenable compliance check for the Security log. The Security channel is a
    protected Admin channel, so the running channel configuration must also be updated with
    wevtutil. Both steps are included below.
#>

$RegPath  = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\EventLog\Security"
$Name     = "MaxSize"
$Value    = 1024000
$Type     = "DWord"

# Step 1 - create the policy key if it does not exist
if (-not (Test-Path $RegPath)) {
    New-Item -Path $RegPath -Force | Out-Null
    Write-Host "Created registry key: $RegPath"
}

# Step 2 - apply the policy registry value
New-ItemProperty -Path $RegPath -Name $Name -Value $Value -PropertyType $Type -Force | Out-Null
Write-Host "WN11-AU-000505 applied: $Name = $Value"

# Step 3 - update the running Security channel configuration
# wevtutil expects the size in KB; it reports back in bytes (1024000 KB = 1048576000 bytes)
wevtutil sl Security /ms:$Value
Write-Host "Security channel maxSize set via wevtutil"

# Verify both the registry value and the live channel configuration
$Current = (Get-ItemProperty -Path $RegPath -Name $Name -ErrorAction SilentlyContinue).$Name
$Channel = (wevtutil gl Security | Select-String "maxSize").ToString().Trim()

if ($Current -eq $Value) {
    Write-Host "VERIFIED - WN11-AU-000505 registry value is compliant (current value: $Current)" -ForegroundColor Green
    Write-Host "VERIFIED - Live channel config: $Channel" -ForegroundColor Green
} else {
    Write-Host "FAILED - WN11-AU-000505 did not apply correctly (current value: $Current)" -ForegroundColor Red
}
