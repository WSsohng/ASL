param(
  [string]$SupabaseUrl = "",
  [string]$ServiceRoleKey = "",
  [string]$Bucket = "asl-gallery",
  [string]$GalleryJson = "data/gallery_migration/gallery-data.json",
  [string]$Manifest = "data/gallery_migration/supabase_upload_manifest.json",
  [string]$SupabaseOut = "data/gallery_migration/gallery-data.supabase.json",
  [string]$RuntimeOut = "data/gallery_migration/gallery-data.runtime.json",
  [int]$Retries = 6
)

$ErrorActionPreference = "Stop"

function Write-Step([string]$Message) {
  Write-Host ""
  Write-Host "[STEP] $Message" -ForegroundColor Cyan
}

function Ensure-Env([string]$Name, [string]$Value) {
  if (-not [string]::IsNullOrWhiteSpace($Value)) {
    Set-Item -Path "Env:$Name" -Value $Value
    return
  }
  if ([string]::IsNullOrWhiteSpace((Get-Item -Path "Env:$Name" -ErrorAction SilentlyContinue).Value)) {
    throw "$Name is missing. Pass it as a parameter or set environment variable before running."
  }
}

function Get-ErrorBody($Exception) {
  try {
    if ($Exception.Response -and $Exception.Response.GetResponseStream) {
      $reader = New-Object System.IO.StreamReader($Exception.Response.GetResponseStream())
      $body = $reader.ReadToEnd()
      if (-not [string]::IsNullOrWhiteSpace($body)) { return $body }
    }
  } catch {}
  return $Exception.Message
}

function Ensure-Bucket([string]$Url, [string]$Key, [string]$BucketName) {
  $baseUrl = $Url.TrimEnd('/')
  $checkUrl = "{0}/storage/v1/bucket/{1}" -f $baseUrl, $BucketName
  $listUrl = "{0}/storage/v1/bucket" -f $baseUrl
  $createUrl = "{0}/storage/v1/bucket" -f $baseUrl
  $headers = @{
    "apikey"        = $Key
    "Authorization" = "Bearer $Key"
  }

  try {
    $resp = Invoke-RestMethod -Uri $checkUrl -Method Get -Headers $headers -TimeoutSec 30
    if ($resp) {
      Write-Host "Bucket '$BucketName' exists." -ForegroundColor Green
      return
    }
  } catch {
    $errBody = Get-ErrorBody $_.Exception

    # Try list to validate credentials quickly.
    try {
      $listResp = Invoke-RestMethod -Uri $listUrl -Method Get -Headers $headers -TimeoutSec 30
      $exists = $false
      foreach ($b in $listResp) {
        if ($b.name -eq $BucketName -or $b.id -eq $BucketName) { $exists = $true; break }
      }
      if ($exists) {
        Write-Host "Bucket '$BucketName' exists (detected from list)." -ForegroundColor Green
        return
      }
    } catch {
      $listErr = Get-ErrorBody $_.Exception
      throw "Supabase credential check failed while listing buckets. Verify SERVICE ROLE key. Details: $listErr"
    }

    # Bucket absent: try create as public.
    try {
      $createHeaders = @{
        "apikey"        = $Key
        "Authorization" = "Bearer $Key"
        "Content-Type"  = "application/json"
      }
      $payload = @{
        id = $BucketName
        name = $BucketName
        public = $true
      } | ConvertTo-Json

      Invoke-RestMethod -Uri $createUrl -Method Post -Headers $createHeaders -Body $payload -TimeoutSec 30 | Out-Null
      Write-Host "Bucket '$BucketName' created (public)." -ForegroundColor Green
      return
    } catch {
      $createErr = Get-ErrorBody $_.Exception
      throw "Supabase bucket '$BucketName' not reachable and auto-create failed. Initial check: $errBody | create: $createErr"
    }
  }
}

Write-Step "Preparing environment"
Set-Location -LiteralPath (Resolve-Path "$PSScriptRoot\..\..")
Remove-Item Env:HTTP_PROXY -ErrorAction SilentlyContinue
Remove-Item Env:HTTPS_PROXY -ErrorAction SilentlyContinue
Remove-Item Env:http_proxy -ErrorAction SilentlyContinue
Remove-Item Env:https_proxy -ErrorAction SilentlyContinue
Remove-Item Env:ALL_PROXY -ErrorAction SilentlyContinue
Remove-Item Env:all_proxy -ErrorAction SilentlyContinue

Ensure-Env -Name "SUPABASE_URL" -Value $SupabaseUrl
Ensure-Env -Name "SUPABASE_SERVICE_ROLE_KEY" -Value $ServiceRoleKey

$finalUrl = (Get-Item -Path Env:SUPABASE_URL).Value
$finalKey = (Get-Item -Path Env:SUPABASE_SERVICE_ROLE_KEY).Value

Write-Step "Checking Supabase bucket '$Bucket'"
Ensure-Bucket -Url $finalUrl -Key $finalKey -BucketName $Bucket

Write-Step "Uploading gallery assets to Supabase Storage"
python tools/gallery_migration/upload_gallery_to_supabase.py `
  --bucket $Bucket `
  --gallery-json $GalleryJson `
  --manifest $Manifest `
  --retries $Retries `
  --optimize-large

Write-Step "Rewriting gallery-data.json with Supabase public URLs"
python tools/gallery_migration/rewrite_gallery_urls.py `
  --gallery-json $GalleryJson `
  --manifest $Manifest `
  --out $SupabaseOut `
  --strict

Write-Step "Switching runtime dataset"
Copy-Item -LiteralPath $SupabaseOut -Destination $RuntimeOut -Force

Write-Step "Validating runtime dataset"
python -c "import json; d=json.load(open(r'$RuntimeOut', encoding='utf-8')); print(f'rows={len(d)} images={sum(len(x.get(\"images\",[])) for x in d)} sample={d[0][\"images\"][0] if d and d[0].get(\"images\") else \"none\"}')" 

Write-Host ""
Write-Host "[DONE] Supabase migration complete." -ForegroundColor Green
Write-Host "Runtime dataset: $RuntimeOut"
