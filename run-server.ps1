# Lightweight Local Web Server for Hearts Card Game
# Uses PowerShell's built-in HttpListener - No Node or Python required!

$port = 8080
$prefix = "http://localhost:$port/"
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add($prefix)

try {
    $listener.Start()
    Write-Host "=========================================" -ForegroundColor Green
    Write-Host " Hearts Card Game Server Running! " -ForegroundColor Yellow
    Write-Host " URL: $prefix" -ForegroundColor Cyan
    Write-Host " Press Ctrl+C in this terminal to stop." -ForegroundColor Gray
    Write-Host "=========================================" -ForegroundColor Green
    
    Start-Process $prefix

    while ($listener.IsListening) {
        $context = $listener.GetContext()
        $request = $context.Request
        $response = $context.Response

        $urlPath = $request.Url.LocalPath.TrimStart('/')
        if ([string]::IsNullOrEmpty($urlPath) -or $urlPath -eq "/") {
            $urlPath = "index.html"
        }

        $localPath = Join-Path $PSScriptRoot $urlPath

        if (Test-Path $localPath -PathType Leaf) {
            $contentBytes = [System.IO.File]::ReadAllBytes($localPath)
            
            # Simple content types
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
} finally {
    $listener.Stop()
}
