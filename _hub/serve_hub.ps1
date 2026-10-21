# Fallback local server for Windows PCs without Python.
# Same job as serve_hub.py: serves the project on http://127.0.0.1:8765 and adds
# "show in folder", "open with default app" and "gather files" actions.
param([int]$Port = 8765)

$Root = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..')).TrimEnd('\')
$Jobs = Join-Path $Root '_Print Jobs'
$Latin1 = [Text.Encoding]::GetEncoding(28591)
$Types = @{
  '.html' = 'text/html; charset=utf-8'; '.js' = 'text/javascript'; '.mjs' = 'text/javascript'
  '.css' = 'text/css'; '.json' = 'application/json'; '.svg' = 'image/svg+xml'
  '.png' = 'image/png'; '.jpg' = 'image/jpeg'; '.jpeg' = 'image/jpeg'; '.webp' = 'image/webp'
  '.pdf' = 'application/pdf'; '.stl' = 'model/stl'
}
$Status = @{ 200 = 'OK'; 400 = 'Bad Request'; 403 = 'Forbidden'; 404 = 'Not Found' }

function Resolve-HubPath([string]$rel) {
  $full = [IO.Path]::GetFullPath((Join-Path $Root ($rel -replace '/', '\')))
  if (-not $full.StartsWith($Root + '\', [StringComparison]::OrdinalIgnoreCase)) { throw 'outside project' }
  if (-not (Test-Path -LiteralPath $full)) { throw "not found: $rel" }
  return $full
}

function Send-Head($stream, [int]$code, [string]$type, [long]$length) {
  $head = "HTTP/1.1 $code $($Status[$code])`r`nContent-Type: $type`r`nContent-Length: $length`r`nCache-Control: no-cache`r`nConnection: close`r`n`r`n"
  $bytes = [Text.Encoding]::ASCII.GetBytes($head)
  $stream.Write($bytes, 0, $bytes.Length)
}

function Send-Json($stream, [int]$code, $obj) {
  $body = [Text.Encoding]::UTF8.GetBytes(($obj | ConvertTo-Json -Compress))
  Send-Head $stream $code 'application/json' $body.Length
  $stream.Write($body, 0, $body.Length)
}

function Show-InFolder([string]$full) {
  Start-Process -FilePath 'explorer.exe' -ArgumentList "/select,`"$full`""
}

function Invoke-Api($stream, [string]$route, $body) {
  switch ($route) {
    '/api/reveal' { Show-InFolder (Resolve-HubPath $body.path); Send-Json $stream 200 @{ ok = $true } }
    '/api/open' { Start-Process -FilePath (Resolve-HubPath $body.path); Send-Json $stream 200 @{ ok = $true } }
    '/api/gather' {
      $name = ($body.name -replace '[<>:"/\\|?*]', '').Trim()
      if (-not $name) { $name = 'Parts' }
      $dest = Join-Path $Jobs $name
      New-Item -ItemType Directory -Force -Path $dest | Out-Null
      foreach ($rel in $body.paths) {
        $src = Resolve-HubPath $rel
        $target = Join-Path $dest ([IO.Path]::GetFileName($src))
        if (-not (Test-Path -LiteralPath $target) -or (Get-Item -LiteralPath $target).Length -ne (Get-Item -LiteralPath $src).Length) {
          Copy-Item -LiteralPath $src -Destination $target -Force
        }
      }
      Start-Process -FilePath 'explorer.exe' -ArgumentList "`"$dest`""
      Send-Json $stream 200 @{ ok = $true; folder = $dest.Substring($Root.Length + 1) }
    }
    default { Send-Json $stream 404 @{ error = 'unknown route' } }
  }
}

function Handle-Client($client) {
  $stream = $client.GetStream()
  # Latin-1 maps bytes 1:1 to chars, so the UTF-8 request body survives the reader's buffering.
  $reader = New-Object IO.StreamReader($stream, $Latin1, $false, 65536, $true)
  $requestLine = $reader.ReadLine()
  if (-not $requestLine) { return }
  $method, $target = $requestLine.Split(' ')[0, 1]
  $headers = @{}
  while ($true) {
    $line = $reader.ReadLine()
    if ([string]::IsNullOrEmpty($line)) { break }
    $i = $line.IndexOf(':')
    if ($i -gt 0) { $headers[$line.Substring(0, $i).Trim().ToLower()] = $line.Substring($i + 1).Trim() }
  }
  $route = [Uri]::UnescapeDataString(($target -split '\?')[0])

  if ($method -eq 'POST') {
    if ($headers['x-vault-hub'] -ne '1') { Send-Json $stream 403 @{ error = 'forbidden' }; return }
    $length = [int]$headers['content-length']
    $buffer = New-Object char[] $length
    $read = 0
    while ($read -lt $length) {
      $n = $reader.Read($buffer, $read, $length - $read)
      if ($n -le 0) { break }
      $read += $n
    }
    $json = [Text.Encoding]::UTF8.GetString($Latin1.GetBytes($buffer, 0, $read))
    try { Invoke-Api $stream $route ($json | ConvertFrom-Json) }
    catch { Send-Json $stream 400 @{ error = $_.Exception.Message } }
    return
  }

  if ($route -eq '/api/ping') { Send-Json $stream 200 @{ ok = $true; platform = 'win32' }; return }
  if ($route -eq '/') { $route = '/index.html' }
  try { $full = Resolve-HubPath $route.TrimStart('/') } catch { $full = $null }
  if (-not $full -or (Test-Path -LiteralPath $full -PathType Container)) {
    $body = [Text.Encoding]::UTF8.GetBytes('Not found')
    Send-Head $stream 404 'text/plain' $body.Length
    $stream.Write($body, 0, $body.Length)
    return
  }
  $type = $Types[[IO.Path]::GetExtension($full).ToLower()]
  if (-not $type) { $type = 'application/octet-stream' }
  $file = [IO.File]::OpenRead($full)
  try {
    Send-Head $stream 200 $type $file.Length
    if ($method -ne 'HEAD') { $file.CopyTo($stream, 1048576) }
  } finally { $file.Dispose() }
}

$url = "http://127.0.0.1:$Port/index.html"
$listener = New-Object Net.Sockets.TcpListener([Net.IPAddress]::Loopback, $Port)
try { $listener.Start() }
catch {
  Write-Host "Port $Port is busy - the hub is probably already running. Opening it."
  Start-Process $url
  exit
}
Write-Host "VAULT hub running at $url"
Write-Host 'Leave this window open while you use the hub. Close it to stop.'
Start-Process $url
while ($true) {
  $client = $listener.AcceptTcpClient()
  try { Handle-Client $client }
  catch { }  # browser cancelled a request (e.g. closed the 3D preview mid-load)
  finally { $client.Close() }
}
