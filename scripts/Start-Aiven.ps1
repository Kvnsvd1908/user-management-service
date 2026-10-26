$ErrorActionPreference = 'Stop'
Set-Location (Split-Path $PSScriptRoot -Parent)

$aivenValues = @{}
foreach ($path in @('.env', '.environments/aiven.env')) {
    if (-not (Test-Path $path)) { throw "Falta $path. Consulta docs/AIVEN_SETUP.md." }
    Get-Content $path | ForEach-Object {
        if ($_ -match '^\s*([A-Za-z_][A-Za-z0-9_]*)=(.*)$') {
            Set-Item -Path "Env:$($Matches[1])" -Value $Matches[2]
            if ($path -eq '.environments/aiven.env') {
                $aivenValues[$Matches[1]] = $Matches[2]
            }
        }
    }
}

foreach ($key in @('DB_HOST', 'DB_PORT', 'DB_NAME', 'DB_USERNAME', 'DB_PASSWORD')) {
    if (-not $aivenValues.ContainsKey($key) -or -not $aivenValues[$key]) {
        throw "Falta $key en .environments/aiven.env."
    }
}
if ($env:DB_SSL_MODE -notin @('REQUIRED', 'VERIFY_CA', 'VERIFY_IDENTITY')) {
    throw 'DB_SSL_MODE debe exigir TLS (REQUIRED, VERIFY_CA o VERIFY_IDENTITY).'
}

docker compose up -d mailpit
if ($LASTEXITCODE -ne 0) { throw 'Docker Compose no pudo iniciar Mailpit.' }
$env:SMTP_HOST = '127.0.0.1'
$env:SMTP_PORT = '1025'
$env:SMTP_USERNAME = ''
$env:SMTP_PASSWORD = ''

& .\mvnw.cmd spring-boot:run
exit $LASTEXITCODE
