# --- CONFIGURATION ---
$githubUser = "WinGuySol"
$githubRepo = "MS-Store-Installer"
$branch = "main"
$ProgressPreference = 'SilentlyContinue'

$installOrder = @(
    "*VCLibs.140.00_14*",
    "*NET.Native.Runtime*",
    "*NET.Native.Framework*",
    "*UI.Xaml*",
    "*VCLibs.140.00.UWPDesktop*",
    "*DesktopAppInstaller*"
)

$tempDir = Join-Path $env:TEMP "WinGetOnlyInstall"
if (!(Test-Path $tempDir)) { New-Item -ItemType Directory -Path $tempDir }
Set-Location $tempDir

Write-Host "--- WinGet-Only Installer for LTSC ---" -ForegroundColor Cyan
Write-Host "Fetching files from GitHub..." -ForegroundColor Gray

$apiUrl = "https://api.github.com/repos/$githubUser/$githubRepo/contents?ref=$branch"
$files = Invoke-RestMethod -Uri $apiUrl

foreach ($pattern in $installOrder) {
    $targetFile = $files | Where-Object { $_.name -like $pattern } | Select-Object -First 1
    
    if ($targetFile) {
        $localPath = Join-Path $tempDir $targetFile.name
        Write-Host "Downloading: $($targetFile.name)..." -ForegroundColor Yellow
        Invoke-WebRequest -Uri $targetFile.download_url -OutFile $localPath
        
        Write-Host "Installing..." -ForegroundColor Green
        try {
            Add-AppxPackage -Path $localPath -ErrorAction Stop
        } catch {
            Write-Host "Notice: Skipping (already installed or dependency met)." -ForegroundColor Gray
        }
    }
}

Write-Host "--- DONE! WinGet is ready. ---" -ForegroundColor Cyan
Write-Host "Checking version..." -ForegroundColor Gray

Set-Location $env:USERPROFILE
Remove-Item -Recurse -Force $tempDir

winget --version
Write-Host "Now you can use 'winget install <package>' in PowerShell." -ForegroundColor White
pause
