Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

choco install GoogleChrome -y
choco install vscode -y
choco install cmder -y
choco install git -y
