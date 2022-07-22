### Shell environment ###

# PSReadLine preferences
Set-PSReadLineKeyHandler -Key Tab -Function Complete
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

# Remove curl alias to enable curl for Windows (Silently continue as pwsh7 does not have this alias)
if ( Get-Command curl -ErrorAction SilentlyContinue ) { Remove-Item alias:curl -ErrorAction SilentlyContinue }


### Simple aliases ###
New-Alias -Name wh -Value Write-Host
New-Alias -Name which -Value get-command
New-Alias -Name wo -Value Write-Output


### Functions ###

function Get-PersistentHistory ($head, $tail) {
  if (![string]::IsNullOrEmpty($head) -and ![string]::IsNullOrEmpty($tail))
  { Write-Output 'Conflicting arguements passed. Pass either head or tail, no both.'; return }
  $historyFilePath = "C:\Users\$env:UserName\appdata\Roaming\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt"
  if ( !Test-Path -Path $historyFilePath ) { return }
  elseif ( ![string]::IsNullOrEmpty($head) ) { return Get-Content $historyFilePath | Select-Object -First $head }
  elseif ( ![string]::IsNullOrEmpty($tail) ) { return Get-Content $historyFilePath | Select-Object -Last $tail }
  else { return Get-Content $historyFilePath }
}; Remove-Item alias:history -Force; New-Alias history -Value Get-PersistentHistory


function Get-VmIpAddress {
  (Get-VM | Where-Object { $_.state -eq 'Running' } | Get-VMNetworkAdapter) |
  Where-Object { $_.ipAddresses -like '*172.*' -or $_.ipAddresses -like '*192.*' } |
  Select-Object VMName, IpAddresses
}


function New-Symlink {
  param (
    [Parameter(Mandatory = $true, Position = 0)][String[]] $objectPath,
    [Parameter(Mandatory = $true, Position = 1)][String[]] $symlinkPath
  ) ; New-Item -Type SymbolicLink -Path $symlinkPath -Value $objectPath
} ; New-Alias -Name ln -Value New-Symlink


function Remove-Object ($path) {
  Remove-Item $path -Recurse -Confirm:$false -Force
}; Remove-Item Alias:rm -Force; New-Alias rm Remove-Object


function Set-NugetAuthentication ( $username = $env:GITHUB_USER, $token = $env:GITHUB_AUTH_TOKEN ) {
  return New-Object System.Management.Automation.PSCredential -ArgumentList $username,
    (ConvertTo-SecureString -AsPlainText $token -Force)
}


function Set-ParentLocation ($path) {
  $fullPath = (Get-Location).path
  if ([string]::IsNullOrEmpty($path)) { Set-Location .. }
  $fullPath -match "(.*$path[^\\]*)" | Out-Null
  if ($fullPath -eq $Matches[0]) { Write-Output 'Unable to guess the path. Be more specific' }
  else { Set-Location $Matches[0] }
}; New-Alias bd Set-ParentLocation


function Watch-Command ($command) {
  while ($true) { Clear-Host; & $command; Start-Sleep 1 }
}; New-Alias watch Watch-Command


### Advanced aliases (Functions) ###

# General
function ll { Get-ChildItem -Force $args }
function find { Get-ChildItem -Path . -Recurse -ErrorAction SilentlyContinue -Force -Filter "*$args*" }
function mkcd ($path) { New-Item -ItemType Directory -Path $path; Set-Location $path | Out-Null }
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
function dkcx { docker.exe exec -it $args }
function dki { docker.exe image $args }
function dkils { docker.exe image ls $args }
function dkix { docker.exe run -it $args }

# Other applications
function py { python.exe $args }
function tf { terraform.exe $args }
function vg { vagrant.exe $args }
function vi { vim.bat $args }


### directory shortcuts ###
function cdd { Set-Location C:\Users\$ENV:USERNAME\Development }
function cdt { Set-Location T:\ } # temp drive


### Autocomplete ###

# Octopus CLI autocomplete
Register-ArgumentCompleter -Native -CommandName octo -ScriptBlock {
  param($wordToComplete, $commandAst, $cursorPosition)
  $parms = $commandAst.ToString().Split(' ') | Select-Object -Skip 1
  octo complete $parms | ForEach-Object {
    [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterName', $_)
  }
}


### Additional Profiles ###

# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

# Work profile
$workProfile = "$( Split-Path -Parent $profile )\Set-WorkProfile.ps1"
if ( Test-Path -Path $workProfile ) {
  . $workProfile
}

Clear-Host
