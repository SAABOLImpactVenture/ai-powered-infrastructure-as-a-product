param(
  [string]$Operation = "inference",
  [string]$Model = "gpt-4o-mini",
  [int]$LatencyMs = 120,
  [string]$Status = "success",
  [int]$TokensIn = 0,
  [int]$TokensOut = 0,
  [string]$UserId = "",
  [string]$CorrelationId = ""
)

function New-Guid { [guid]::NewGuid().ToString() }

$payload = [ordered]@{
  id = (New-Guid)
  timestamp_utc = (Get-Date).ToUniversalTime().ToString("o")
  operation = $Operation
  model = $Model
  latency_ms = $LatencyMs
  status = $Status
  tokens = @{ input = $TokensIn; output = $TokensOut }
  user_id = $UserId
  correlation_id = (if ($CorrelationId) { $CorrelationId } else { (New-Guid) })
}

$ws = $env:LA_WORKSPACE_ID
$key = $env:LA_SHARED_KEY
$logType = if ($env:LA_LOG_TYPE) { $env:LA_LOG_TYPE } else { "AoaiRequests_CL" }
$endpoint = if ($env:LA_ENDPOINT) { $env:LA_ENDPOINT } else { "https://$ws.ods.opinsights.azure.com/api/logs?api-version=2016-04-01" }

if (-not $ws -or -not $key) {
  $outDir = ".local-outbox"
  New-Item -ItemType Directory -Force -Path $outDir | Out-Null
  $file = Join-Path $outDir ("aoai-requests-{0}.json" -f [int][double]::Parse((Get-Date -UFormat %s)))
  $payload | ConvertTo-Json -Depth 6 | Set-Content -Path $file -Encoding UTF8
  $res = @{ mode = "local"; saved = $file; payload = $payload } | ConvertTo-Json -Depth 6
  $res
  exit 0
}

$body = @($payload) | ConvertTo-Json -Depth 6
$date = [DateTime]::UtcNow.ToString("r")
$resource = "/api/logs"
$stringToHash = "POST`n{0}`napplication/json`nx-ms-date:{1}`n{2}" -f ($body.Length), $date, $resource
$bytesToHash = [Text.Encoding]::UTF8.GetBytes($stringToHash)
$decodedKey = [Convert]::FromBase64String($key)
$encodedHash = [Convert]::ToBase64String((New-Object System.Security.Cryptography.HMACSHA256($decodedKey)).ComputeHash($bytesToHash))
$signature = "SharedKey {0}:{1}" -f $ws, $encodedHash

$headers = @{
  "Content-Type" = "application/json"
  "Log-Type" = $logType
  "x-ms-date" = $date
  "Authorization" = $signature
}

try {
  $resp = Invoke-WebRequest -Uri $endpoint -Method POST -Headers $headers -Body $body -TimeoutSec 30
  $code = $resp.StatusCode
  @{ mode = "cloud"; status = $code; payload = $payload } | ConvertTo-Json -Depth 6
} catch {
  Write-Error $_.Exception.Message
  exit 1
}
