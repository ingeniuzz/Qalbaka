# ==============================================================================
# Hearts Card Game - 10-Second Free Web Deployment Helper (.io Style)
# Creates a clean Linux-ready zip and standalone single-file HTML
# for 1-click drag-and-drop hosting on Tiiny.host or Netlify Drop
# ==============================================================================

$ProgressPreference = 'SilentlyContinue'
$root = $PSScriptRoot
$zipPath = Join-Path $root "hearts-online-game.zip"
$singleFilePath = Join-Path $root "hearts-single-file.html"

Write-Host ""
Write-Host "=========================================================" -ForegroundColor Green
Write-Host "       ♥ HEARTS FREE WEB HOSTING HELPER (.IO STYLE) ♥     " -ForegroundColor Yellow
Write-Host "=========================================================" -ForegroundColor Green
Write-Host ""
Write-Host "1. Building clean web deployment packages..." -ForegroundColor Cyan

# 1. Build forward-slash zip for Linux web servers
Add-Type -AssemblyName System.IO.Compression.FileSystem
if (Test-Path $zipPath) { Remove-Item $zipPath -Force }
$zip = [System.IO.Compression.ZipFile]::Open($zipPath, 'Create')
[System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile($zip, "$root\index.html", "index.html")
Get-ChildItem -Path "$root\css" -File | ForEach-Object {
    [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile($zip, $_.FullName, "css/$($_.Name)")
}
Get-ChildItem -Path "$root\js" -File | ForEach-Object {
    [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile($zip, $_.FullName, "js/$($_.Name)")
}
$zip.Dispose()

# 2. Build single-file standalone HTML
$indexContent = Get-Content "$root\index.html" -Raw
$cssContent = Get-Content "$root\css\styles.css" -Raw
$jsFiles = @("audio.js", "cards.js", "rules.js", "ai.js", "stats.js", "network.js", "game.js", "ui.js", "app.js")
$jsContent = ""
foreach ($f in $jsFiles) {
    $jsContent += "`n/* === $f === */`n" + (Get-Content "$root\js\$f" -Raw)
}
$single = $indexContent -replace '<link rel="stylesheet" href="css/styles.css">', "<style>`n$cssContent`n</style>"
$scriptPattern = '(?s)<script src="js/audio\.js"></script>.*?<script src="js/app\.js"></script>'
$single = $single -replace $scriptPattern, "<script>`n$jsContent`n</script>"
Set-Content -Path $singleFilePath -Value $single -Encoding UTF8

Write-Host "✓ Zip Package ready: $zipPath" -ForegroundColor Green
Write-Host "✓ Standalone HTML ready: $singleFilePath" -ForegroundColor Green
Write-Host ""
Write-Host "---------------------------------------------------------" -ForegroundColor Yellow
Write-Host " [BEST & EASIEST OPTION FOR A .IO STYLE LINK] " -ForegroundColor Yellow
Write-Host "---------------------------------------------------------" -ForegroundColor Yellow
Write-Host "Option 1: Tiiny Host (100% Free, NO account or login required!)" -ForegroundColor White
Write-Host "  1. Browser opened to: https://tiiny.host/" -ForegroundColor White
Write-Host "  2. Drag 'hearts-single-file.html' into the box on the page." -ForegroundColor White
Write-Host "  3. Type a link name and click Launch!" -ForegroundColor Green
Write-Host "  4. You immediately get a public link like: https://my-hearts.tiiny.site" -ForegroundColor Green
Write-Host ""
Write-Host "Option 2: Direct File (Even faster!)" -ForegroundColor White
Write-Host "  Send 'hearts-single-file.html' directly to your friend on Discord/WhatsApp." -ForegroundColor White
Write-Host "  Both open it in your browser and enter the room code to play!" -ForegroundColor White
Write-Host "---------------------------------------------------------" -ForegroundColor Yellow
Write-Host ""

# Open folder in Explorer and select the single file
explorer.exe "/select,$singleFilePath"

# Open Tiiny Host
Start-Process "https://tiiny.host/"
