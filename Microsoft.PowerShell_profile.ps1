###* Environment *###

# PSReadLine preferences
Set-PSReadLineKeyHandler -Key Tab -Function Complete
Set-PSReadLineKeyHandler -Key ctrl+d -Function ViExit
Set-PSReadLineKeyHandler -key ctrl+l -Function ClearScreen
Set-PSReadLineOption -ShowToolTips
Set-PSReadLineOption -BellStyle None

# Custom prompt
$prompt = "C:\Users\$ENV:USERNAME\Development\steveharsant\powershell_prompt\Set-Prompt.ps1"
if (Test-Path $prompt) { . $prompt }

# Set Dracula text theme
Set-PSReadLineOption -Color @{
  'Command'   = [ConsoleColor]::Green
  'Parameter' = [ConsoleColor]::Gray
  'Operator'  = [ConsoleColor]::Magenta
  'Variable'  = [ConsoleColor]::Yellow
  'String'    = [ConsoleColor]::DarkGray
  'Number'    = [ConsoleColor]::Blue
  'Type'      = [ConsoleColor]::Cyan
  'Comment'   = [ConsoleColor]::DarkCyan
}

# Remove curl alias to enable curl for Windows.
# Silently continue as pwsh7 does not have this alias
Remove-Item alias:curl -ErrorAction SilentlyContinue

###* Functions *###

function ConvertFrom-Base64 {
  param([Parameter(ValueFromPipeline)] $in)
  return [System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String($in))
}


function ConvertTo-Base64 {
  param([Parameter(ValueFromPipeline)] $in)
  return [Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes($in))
}


function Get-PersistentHistory {
  param(
    [Parameter(Position = 0)][int] $head,
    [Parameter(Position = 0)][int] $tail
  )

  if (![string]::IsNullOrEmpty($head) -and ![string]::IsNullOrEmpty($tail))
  { Write-Output 'Conflicting arguements passed. Pass either head or tail, no both.'; return }

  $historyFilePath = "$env:HOMEDRIVE\$env:HOMEPATH\appdata\Roaming\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt"
  if ( ! (Test-Path -Path $historyFilePath) ) { return }

  elseif ( ![string]::IsNullOrEmpty($head) ) { return Get-Content $historyFilePath | Select-Object -First $head }
  elseif ( ![string]::IsNullOrEmpty($tail) ) { return Get-Content $historyFilePath | Select-Object -Last $tail }
  else { return Get-Content $historyFilePath }
}

Remove-Item alias:history -Force
New-Alias history -Value Get-PersistentHistory


function Invoke-HistorySearch {
  param ([Parameter(Position = 0)][string] $search)
  return Get-PersistentHistory | Where-Object { $_ -match $search }
}

New-Alias -Name search -Value Invoke-HistorySearch


function Invoke-Tldr {
  param(
    [Parameter(Position = 0)]         $command,
    [Parameter(Position = 1)][switch] $cheat
  )
  if ($cheat.IsPresent) { $source = 'cheat' } else { $source = 'tldr' }
  (Invoke-WebRequest -Uri "https://cheat.sh/$source`:$command").content
}

New-Alias -Name tldr -Value Invoke-Tldr


function New-Symlink {
  param (
    [Parameter(Position = 0)][String[]] $objectPath,
    [Parameter(Position = 1)][String[]] $symlinkPath
  )
  New-Item -Type SymbolicLink -Path $symlinkPath -Target $objectPath
}

New-Alias -Name ln -Value New-Symlink


function Remove-Object ($path) {
  Remove-Item $path -Recurse -Confirm:$false -Force
}

Remove-Item Alias:rm -Force
New-Alias rm Remove-Object


function Set-ParentLocation ($path) {
  $fullPath = (Get-Location).path
  if ([string]::IsNullOrEmpty($path)) { Set-Location .. }
  $fullPath -match "(.*$path[^\\]*)" | Out-Null
  if ($fullPath -eq $Matches[0]) { Write-Output 'Unable to guess the path. Be more specific' }
  else { Set-Location $Matches[0] }
}

New-Alias -Name bd -Value Set-ParentLocation


function Set-PersistentEnvVar($key, $value) {
  [System.Environment]::SetEnvironmentVariable($key, $value, 'User')
}
New-Alias -Name setenv -Value Set-PersistentEnvVar


function Watch-Command ($command) {
  while ($true) { Clear-Host; & $command; Start-Sleep 1 }
}

New-Alias -Name watch -Value Watch-Command


###* Simple Aliases *###

New-Alias -Name wh -Value Write-Host
New-Alias -Name which -Value get-command
New-Alias -Name wo -Value Write-Output


###* Advanced Aliases (functions) *###

# General
function mkcd ($path) { New-Item -ItemType Directory -Path $path; Set-Location $path | Out-Null }
function pg { ping google.com }
function pgd { ping 8.8.8.8 }
function py { python3 $args }
function touch ($path) { New-Item -ItemType File -Path $path | Out-Null }
function xip { (Invoke-WebRequest 'https://api.ipify.org').content }

# AWS
function ec2 { (Get-EC2Instance).Instances }
function ecr { Invoke-AwsEcrConnection -accessKey $env:AWS_ECR_KEY -profileName 'default' -region $region -secret $env:AWS_ECR_SECRETKEY }

# Docker
function dk { docker.exe $args }
function dkc { docker.exe container $args }
function dkcip { docker.exe inspect --format '{{ .NetworkSettings.IPAddress }}' $args }
function dkcll { docker.exe ps --format 'Name:         {{.Names}}\n└─Status:       {{.Status}}\n└─Container ID: {{.ID}}\n└─Image:        {{.Image}}\n└─Command:      {{.Command}}\n└─Ports:        {{.Ports}}\n└─Mounts:       {{.Mounts}}\n└─Networks:     {{.Networks}}\n└─Created:      {{.RunningFor}}\n' $args }
function dkcls { docker.exe ps --format 'Name:         {{.Names}}\n└─Status:       {{.Status}}\n└─Container ID: {{.ID}}\n└─Image:        {{.Image}}\n└─Ports:        {{.Ports}}\n' $args }
function dkclss { docker.exe ps --filter 'status=exited' --format 'Name:         {{.Names}}\n└─Status:       {{.Status}}\n└─Container ID: {{.ID}}\n└─Image:        {{.Image}}\n└─Ports:        {{.Ports}}\n' $args }
function dkcx { docker.exe exec -it $args }
function dki { docker.exe image $args }
function dkils { docker.exe image ls $args }
function dkix { docker.exe run -it $args }

# Octopus Deploy
# Functions to emulate Octopus Deploy functions so copy/pasting from scripts do not error
function Update-Progress { Write-Host $args -ForegroundColor Black -BackgroundColor Green }
function Write-Highlight { Write-Host $args -ForegroundColor White -BackgroundColor Blue }

# Hashicorp
function tf { terraform.exe $args }
function vg { vagrant.exe $args }
function vl { vault.exe $args }


###* Directory Shortcuts *###

function cdd { Set-Location C:\Users\$ENV:USERNAME\Development }
function cdr { Set-Location C:\Users\$ENV:USERNAME\Repositories }
function cdt { Set-Location T:\ } # temp drive


###* Additional Profiles *###

# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}
