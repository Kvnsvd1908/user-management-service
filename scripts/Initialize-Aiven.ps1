$ErrorActionPreference = 'Stop'
Set-Location (Split-Path $PSScriptRoot -Parent)

$privatePath = '.environments/aiven.env'
if (-not (Test-Path $privatePath)) {
    throw "Falta $privatePath. Consulta docs/AIVEN_SETUP.md."
}

$values = @{}
Get-Content $privatePath | ForEach-Object {
    if ($_ -match '^\s*([A-Za-z_][A-Za-z0-9_]*)=(.*)$') {
        $values[$Matches[1]] = $Matches[2]
    }
}

foreach ($key in @('DB_HOST', 'DB_PORT', 'DB_NAME', 'DB_USERNAME', 'DB_PASSWORD', 'DB_SSL_MODE')) {
    if (-not $values.ContainsKey($key) -or -not $values[$key]) {
        throw "Falta $key en $privatePath."
    }
}
if ($values.DB_HOST -notmatch '^[A-Za-z0-9.-]+\.aivencloud\.com$') {
    throw 'DB_HOST no parece ser un host de Aiven MySQL.'
}
if ($values.DB_PORT -notmatch '^\d{2,5}$') { throw 'DB_PORT debe ser numérico.' }
if ($values.DB_NAME -ne 'crud_usuarios') { throw 'DB_NAME debe ser crud_usuarios para este esquema.' }
if ($values.DB_SSL_MODE -ne 'REQUIRED') {
    throw 'Este inicializador usa DB_SSL_MODE=REQUIRED. Consulta docs/AIVEN_SETUP.md para otros modos TLS.'
}

$priorPassword = $env:MYSQL_PWD
try {
    $env:MYSQL_PWD = $values.DB_PASSWORD
    $client = @(
        'run', '--rm', '-i', '--env', 'MYSQL_PWD',
        'mysql:8.4', 'mysql',
        "--host=$($values.DB_HOST)",
        "--port=$($values.DB_PORT)",
        "--user=$($values.DB_USERNAME)",
        '--ssl-mode=REQUIRED', '--batch', '--skip-column-names'
    )

    'SELECT 1;' | & docker @client
    if ($LASTEXITCODE -ne 0) { throw 'No se pudo conectar a MySQL de Aiven.' }

    Get-Content 'src/main/resources/schema.sql' -Raw | & docker @client
    if ($LASTEXITCODE -ne 0) { throw 'La conexión funcionó, pero no se pudo inicializar el esquema.' }

    $columnCount = 'SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = ''crud_usuarios'' AND table_name = ''users'';' | & docker @client
    if ($LASTEXITCODE -ne 0) { throw 'No se pudo verificar la tabla users.' }
    if ($columnCount[-1] -ne '8') {
        throw "La tabla users no tiene las 8 columnas esperadas (resultado: $($columnCount[-1]))."
    }
    'Conexión TLS y esquema crud_usuarios.users verificados.'
}
finally {
    if ($null -eq $priorPassword) {
        Remove-Item Env:MYSQL_PWD -ErrorAction SilentlyContinue
    } else {
        $env:MYSQL_PWD = $priorPassword
    }
}
