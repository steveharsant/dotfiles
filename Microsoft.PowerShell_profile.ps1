#
# Shell environment
#

# PSReadLine preferences
Set-PSReadLineKeyHandler -Key Tab -Function Complete
Set-PSReadLineOption -ShowToolTips
Set-PSReadLineOption -BellStyle None

# Custom prompt
$prompt = "C:\Users\$ENV:USERNAME\Development\powershell_prompt\Set-Prompt.ps1"
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

# Remove curl alias to enable curl for Windows. Silently continue as pwsh7 does not have this alias
Remove-Item alias:curl -ErrorAction SilentlyContinue

#
# Functions
#

function New-Symlink {
  param (
    [Parameter(Position = 0)][String[]] $objectPath,
    [Parameter(Position = 1)][String[]] $symlinkPath
  )
  New-Item -Type SymbolicLink -Path $symlinkPath -Value $objectPath
}

#
# Simple aliases
#

New-Alias -Name ln -Value New-Symlink
New-Alias -Name wh -Value Write-Host
New-Alias -Name which -Value get-command
New-Alias -Name wo -Value Write-Output

#
# Advanced aliases (Functions)
#

# General

function mkcd ($path) { New-Item -ItemType Directory -Path $path; Set-Location $path | Out-Null }
function search { param ([Parameter(Position = 0)][string] $search); $history = Get-History | Where-Object { $_ -match $search }; $history }
function seft { wsl seft $args } # https://github.com/steveharsant/seft
function tldr { wsl tldr $args } # Alternative native package is nodejs. Install with `npm install tldr -g`
function touch ($path) { New-Item -ItemType File -Path $path | Out-Null }
function xip { (Invoke-WebRequest 'https://api.ipify.org').content }

# Applications

## AWS
function cm { wsl cloudman --disable-dry-run } # https://github.com/dutchcoders/cloudman
function ec2 { (Get-EC2Instance).Instances }
function ecr { Invoke-AwsEcrConnection -accessKey $env:AWS_ECR_KEY -profileName 'default' -region $region -secret $env:AWS_ECR_SECRETKEY }

## Docker
function dk { docker.exe $args }
function dkc { docker.exe container $args }
function dkcip { docker.exe inspect --format '{{ .NetworkSettings.IPAddress }}' $args }
function dkcll { docker.exe ps --format 'Name:         {{.Names}}\n└─Status:       {{.Status}}\n└─Container ID: {{.ID}}\n└─Image:        {{.Image}}\n└─Command:      {{.Command}}\n└─Ports:        {{.Ports}}\n└─Mounts:       {{.Mounts}}\n└─Networks:     {{.Networks}}\n└─Created:      {{.RunningFor}}\n' $args }
function dkcls { docker.exe ps --format 'Name:         {{.Names}}\n└─Status:       {{.Status}}\n└─Container ID: {{.ID}}\n└─Image:        {{.Image}}\n└─Ports:        {{.Ports}}\n' $args }
function dkcx { docker.exe exec -it $args }
function dkcxb { docker.exe exec -it $args bash }
function dki { docker.exe image $args }
function dkils { docker.exe image ls $args }
function dkix { docker.exe run -it $args }

## Heroku
function hk { heroku.cmd $args }

## Terraform
function tf { terraform.exe $args }

## Vagrant
function vg { vagrant.exe $args }

## Vim
function vi { vim.bat $args }

# directory shortcuts
function cdd { Set-Location C:\Users\$ENV:USERNAME\Development }

#
# Custom alias overrides
#

# Remap history to custom module
Remove-Item alias:history -Force
New-Alias history Get-PersistentHistory

# Remap rm to custom module
Remove-Item Alias:rm -Force
New-Alias rm Remove-Object

#
# Autocomplete
#

# Octopus CLI autocomplete
Register-ArgumentCompleter -Native -CommandName octo -ScriptBlock {
  param($wordToComplete, $commandAst, $cursorPosition)
  $parms = $commandAst.ToString().Split(' ') | Select-Object -Skip 1
  octo complete $parms | ForEach-Object {
    [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterName', $_)
  }
}

#
# Additional Profiles
#

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

# Set-Location $env:USERPROFILE
Clear-Host
