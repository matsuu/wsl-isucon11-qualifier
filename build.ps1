Param(
  [parameter(mandatory=$true)][string]$Distro,
  [parameter(mandatory=$true)][string]$InstallLocation
)

$ErrorActionPreference = "Stop"

#$uri = "http://cdimage.ubuntu.com/ubuntu-base/releases/20.04.2/release/ubuntu-base-20.04.2-base-amd64.tar.gz"
$uri = "http://ftp.jaist.ac.jp/pub/Linux/ubuntu-cdimage/ubuntu-base/releases/20.04.2/release/ubuntu-base-20.04.2-base-amd64.tar.gz"
$sha256sum = "81010C61119D784B6A32B0638F9DBD9E22BAB2F3A4468ADF5939615225FE4BE0"
$tarball = Join-Path $PSScriptRoot ([System.IO.Path]::GetFileName($uri))

If (![System.IO.File]::Exists($tarball)) {
  Invoke-WebRequest -Uri $uri -OutFile $tarball
}

$hash = (Get-FileHash $tarball -Algorithm SHA256).Hash
If ($hash -ne $sha256sum) {
  Write-Error "Checksum failed. Please delete $tarball manually."
}

wsl.exe --import $Distro $InstallLocation $tarball --version 2

$scriptsdir = Join-Path $PSScriptRoot "scripts"
Get-ChildItem $scriptsdir -Filter *.sh | Sort-Object -Property FullName | Foreach-Object {
  (Get-Content $_.FullName) -join "`n" | wsl.exe -d $Distro /bin/bash -l
}

wsl.exe -t $Distro

Remove-Item $tarball
#
