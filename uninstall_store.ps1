$packagesToRemove = @(
    "*WindowsStore*",
    "*DesktopAppInstaller*",
    "*UI.Xaml*",
    "*NET.Native.Framework*",
    "*NET.Native.Runtime*",
    "*VCLibs.140.00*"
)

Write-Host "--- Microsoft Store & WinGet Uninstaller ---" -ForegroundColor Cyan

foreach ($pattern in $packagesToRemove) {
    $foundPackages = Get-AppxPackage -Name $pattern
    
    if ($foundPackages) {
        foreach ($pkg in $foundPackages) {
            Write-Host "Removing: $($pkg.PackageFullName)..." -ForegroundColor Yellow
            try {
                Remove-AppxPackage -Package $pkg.PackageFullName -ErrorAction Stop
                Write-Host "Done!" -ForegroundColor Green
            } catch {
                Write-Host "Could not remove $($pkg.Name). It might be a system dependency." -ForegroundColor Gray
            }
        }
    } else {
        Write-Host "No packages found for pattern: $pattern" -ForegroundColor Gray
    }
}

Write-Host "--- Cleanup Finished! ---" -ForegroundColor Cyan
pause