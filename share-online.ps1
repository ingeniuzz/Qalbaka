# ==============================================================================
# Hearts Card Game - Online Multiplayer Host & Sharing Helper
# Starts the local server and connects to a free public tunnel (Pinggy / Localhost.run)
# so your friend kilometers away can join with a single click!
# ==============================================================================

$port = 8080

Write-Host ""
Write-Host "=========================================================" -ForegroundColor Green
Write-Host "       ♥ HEARTS ONLINE MULTIPLAYER SHARING HELPER ♥       " -ForegroundColor Yellow
Write-Host "=========================================================" -ForegroundColor Green
Write-Host ""
Write-Host "1. Starting local Hearts web server on port $port..." -ForegroundColor Cyan

# Start the background local web server job
$serverScript = {
    param($port, $root)
    $prefix = "http://localhost:$port/"
    $listener = New-Object System.Net.HttpListener
    $listener.Prefixes.Add($prefix)
    try {
        $listener.Start()
        while ($listener.IsListening) {
            $context = $listener.GetContext()
            $request = $context.Request
            $response = $context.Response
            $urlPath = $request.Url.LocalPath.TrimStart('/')
            if ([string]::IsNullOrEmpty($urlPath) -or $urlPath -eq "/") { $urlPath = "index.html" }
            $localPath = Join-Path $root $urlPath

            if (Test-Path $localPath -PathType Leaf) {
                $contentBytes = [System.IO.File]::ReadAllBytes($localPath)
                $ext = [System.IO.Path]::GetExtension($localPath).ToLower()
                switch ($ext) {
                    ".html" { $response.ContentType = "text/html; charset=utf-8" }
                    ".css"  { $response.ContentType = "text/css; charset=utf-8" }
                    ".js"   { $response.ContentType = "application/javascript; charset=utf-8" }
                    ".svg"  { $response.ContentType = "image/svg+xml" }
                    ".png"  { $response.ContentType = "image/png" }
                    ".json" { $response.ContentType = "application/json" }
                    default { $response.ContentType = "application/octet-stream" }
                }
                $response.ContentLength64 = $contentBytes.Length
                $response.OutputStream.Write($contentBytes, 0, $contentBytes.Length)
            } else {
                $response.StatusCode = 404
                $msg = [System.Text.Encoding]::UTF8.GetBytes("404 Not Found")
                $response.OutputStream.Write($msg, 0, $msg.Length)
            }
            $response.Close()
        }
    } catch {}
}

$job = Start-Job -ScriptBlock $serverScript -ArgumentList $port, $PSScriptRoot

Write-Host "✓ Local server is running on http://localhost:$port/" -ForegroundColor Green
Write-Host ""
Write-Host "2. Creating a FREE public link for your friend..." -ForegroundColor Cyan
Write-Host "   Connecting to public tunnel via OpenSSH (built-in Windows SSH)..." -ForegroundColor Gray
Write-Host ""

# Open default browser for Host
Start-Process "http://localhost:$port/"

Write-Host "---------------------------------------------------------" -ForegroundColor Yellow
Write-Host " [OPTIONS TO SHARE WITH YOUR FRIEND] " -ForegroundColor Yellow
Write-Host "---------------------------------------------------------" -ForegroundColor Yellow
Write-Host "A. If Pinggy connects below, copy the 'https://...pinggy.link' URL" -ForegroundColor White
Write-Host "   and send it directly to your friend!" -ForegroundColor White
Write-Host "B. Or upload this folder to Netlify Drop (app.netlify.com/drop)" -ForegroundColor White
Write-Host "   or GitHub Pages for permanent 24/7 free hosting!" -ForegroundColor White
Write-Host "C. Or if your friend also has this game folder, they can open" -ForegroundColor White
Write-Host "   index.html and simply enter your Room Code & Password!" -ForegroundColor White
Write-Host "---------------------------------------------------------" -ForegroundColor Yellow
Write-Host ""
Write-Host "Starting tunnel now (Press Ctrl+C when finished playing)..." -ForegroundColor Green
Write-Host ""

try {
    # Run Pinggy tunnel with strict host key checking disabled
    & ssh -o StrictHostKeyChecking=no -p 443 -R0:localhost:$port a.pinggy.io
} finally {
    Stop-Job -Job $job -ErrorAction SilentlyContinue
    Remove-Job -Job $job -ErrorAction SilentlyContinue
    Write-Host "`nServer stopped. Thanks for playing!" -ForegroundColor Yellow
}
