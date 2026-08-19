# DISA STIG Remediations — Windows 11 (v2r7)

PowerShell remediation scripts for ten Windows 11 DISA STIG findings, written for the
LogN Pacific Cyber Range Vulnerability Management internship track.

Each script is idempotent, creates the registry key if absent, applies the setting, and
verifies the result before exiting.

| # | STIG-ID | Control | Registry value |
|---|---------|---------|----------------|
| 1 | WN11-AU-000500 | Application event log ≥ 32 MB | `MaxSize = 32768` |
| 2 | WN11-AU-000505 | Security event log ≥ 1 GB | `MaxSize = 1024000` |
| 3 | WN11-AU-000510 | System event log ≥ 32 MB | `MaxSize = 32768` |
| 4 | WN11-CC-000005 | Camera disabled on lock screen | `NoLockScreenCamera = 1` |
| 5 | WN11-CC-000180 | AutoPlay off for non-volume devices | `NoAutoplayfornonVolume = 1` |
| 6 | WN11-CC-000185 | AutoRun commands blocked | `NoAutorun = 1` |
| 7 | WN11-CC-000190 | AutoPlay off for all drives | `NoDriveTypeAutoRun = 255` |
| 8 | WN11-CC-000310 | Users cannot change install options | `EnableUserControl = 0` |
| 9 | WN11-CC-000315 | AlwaysInstallElevated disabled | `AlwaysInstallElevated = 0` |
| 10 | WN11-CC-000326 | PowerShell script block logging on | `EnableScriptBlockLogging = 1` |

## Usage

Run elevated on the target VM:

```powershell
Get-ChildItem .\remediation-*.ps1 | ForEach-Object { & $_.FullName }
Restart-Computer
```

Then rescan in Tenable with the DISA Windows 11 STIG compliance policy to confirm the
findings move from Failed to Passed.

## Method

Per the internship methodology: baseline scan → manual remediation → rescan to confirm
pass → revert → rescan to confirm fail → automate in PowerShell → final rescan.
