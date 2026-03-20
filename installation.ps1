# --- CONFIGURATION ---
$ProgressPreference = 'SilentlyContinue'
$githubUser = "WinGuySol"
$githubRepo = "MS-Store-Installer"
$branch = "main"

$installOrder = @(
    "*VCLibs.140.00_14*",
    "*NET.Native.Runtime*",
    "*NET.Native.Framework*",
    "*UI.Xaml*",
    "*VCLibs.140.00.UWPDesktop*",
    "*WindowsStore*",
    "*DesktopAppInstaller*"
)

$tempDir = Join-Path $env:TEMP "MSStoreInstall"
if (!(Test-Path $tempDir)) { New-Item -ItemType Directory -Path $tempDir }
Set-Location $tempDir

Write-Host "--- Microsoft Store Online Installer for LTSC ---" -ForegroundColor Cyan
Write-Host "Fetching file list from GitHub..." -ForegroundColor Gray

$apiUrl = "https://api.github.com/repos/$githubUser/$githubRepo/contents?ref=$branch"
$files = Invoke-RestMethod -Uri $apiUrl

foreach ($pattern in $installOrder) {
    $targetFile = $files | Where-Object { $_.name -like $pattern } | Select-Object -First 1
    
    if ($targetFile) {
        $localPath = Join-Path $tempDir $targetFile.name
        Write-Host "Found: $($targetFile.name)" -ForegroundColor Gray
        Write-Host "Downloading..." -ForegroundColor Yellow
        Invoke-WebRequest -Uri $targetFile.download_url -OutFile $localPath
        
        Write-Host "Installing..." -ForegroundColor Green
        try {
            Add-AppxPackage -Path $localPath -ErrorAction Stop
        } catch {
            Write-Host "Notice: Skipping $($targetFile.name) (might be already installed)." -ForegroundColor Gray
        }
    } else {
        Write-Host "Warning: Could not find file matching $pattern" -ForegroundColor Red
    }
}

Write-Host "--- DONE! Cleaning up... ---" -ForegroundColor Cyan

Set-Location $env:USERPROFILE 

Remove-Item -Recurse -Force $tempDir

Write-Host "Microsoft Store should now be available in your Start Menu." -ForegroundColor White
pause
