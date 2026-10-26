$ErrorActionPreference = 'Stop'
Set-Location (Split-Path $PSScriptRoot -Parent)

if (-not (Test-Path '.env')) {
    throw 'Falta .env. Copia compose.env.example, reemplaza los valores de ejemplo y mantenlo fuera de Git.'
}

Get-Content '.env' | ForEach-Object {
    if ($_ -match '^\s*([A-Za-z_][A-Za-z0-9_]*)=(.*)$') {
        Set-Item -Path "Env:$($Matches[1])" -Value $Matches[2]
    }
}

docker compose up -d mysql mailpit
if ($LASTEXITCODE -ne 0) { throw 'Docker Compose no pudo iniciar MySQL y Mailpit.' }

$env:DB_HOST = '127.0.0.1'
$env:DB_PORT = '3306'
$env:DB_NAME = 'crud_usuarios'
$env:DB_USERNAME = 'users_app'
$env:DB_SSL_MODE = 'DISABLED'
$env:SMTP_HOST = '127.0.0.1'
$env:SMTP_PORT = '1025'
$env:SMTP_USERNAME = ''
$env:SMTP_PASSWORD = ''

& .\mvnw.cmd spring-boot:run
exit $LASTEXITCODE
