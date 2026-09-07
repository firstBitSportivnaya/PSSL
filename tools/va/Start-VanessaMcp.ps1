# Thin client as TestManager + Vanessa Automation MCP.
# Machine pins and credentials: .dev.env only (gitignored). Do not print them.
[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
$envFile = Join-Path $repoRoot '.dev.env'
if (-not (Test-Path -LiteralPath $envFile)) {
    throw ".dev.env not found"
}

function Get-DevEnvValue {
    param([Parameter(Mandatory = $true)][string]$Name)
    foreach ($line in Get-Content -LiteralPath $envFile -Encoding UTF8) {
        if ([string]::IsNullOrWhiteSpace($line)) { continue }
        $trim = $line.TrimStart()
        if ($trim.StartsWith('#')) { continue }
        if ($trim -match '^([A-Za-z_][A-Za-z0-9_]*)\s*=\s*(.*)$' -and $Matches[1] -eq $Name) {
            $val = $Matches[2].Trim()
            if ($val.Length -ge 2 -and
                (($val.StartsWith('"') -and $val.EndsWith('"')) -or
                 ($val.StartsWith("'") -and $val.EndsWith("'")))) {
                $val = $val.Substring(1, $val.Length - 2).Trim()
            }
            return $val
        }
    }
    return ''
}

function ConvertTo-JsonString {
    param([Parameter(Mandatory = $true)][AllowEmptyString()][string]$Value)
    return $Value.Replace('\', '\\').Replace('"', '\"')
}

function Get-TestClientLaunchKeys {
    param(
        [string]$UserName,
        [AllowEmptyString()][string]$Password
    )
    if (-not $UserName) { return '' }
    return '/P"' + $Password + '"'
}

$platformPath = Get-DevEnvValue 'PLATFORM_PATH'
$ibPath = Get-DevEnvValue 'INFOBASE_PATH'
$user = Get-DevEnvValue 'IB_USER'
$password = Get-DevEnvValue 'IB_PASSWORD'
$epf = Get-DevEnvValue 'VA_EPF_PATH'
$port = Get-DevEnvValue 'VA_MCP_PORT'
$paramsPath = Get-DevEnvValue 'VA_PARAMS'
if (-not $port) { $port = '9876' }
if (-not $paramsPath) { $paramsPath = Join-Path $repoRoot 'tools\va\VAParams.json' }

if (-not $platformPath) { throw "Set PLATFORM_PATH in .dev.env" }
if (-not $ibPath) { throw "Set INFOBASE_PATH in .dev.env" }
if (-not $epf) { throw "Set VA_EPF_PATH in .dev.env" }

$exe = Join-Path $platformPath 'bin\1cv8c.exe'
if (-not (Test-Path -LiteralPath $exe)) { $exe = Join-Path $platformPath '1cv8c.exe' }
if (-not (Test-Path -LiteralPath $exe)) { throw "1cv8c.exe not found near PLATFORM_PATH" }
if (-not (Test-Path -LiteralPath $ibPath)) { throw "Infobase not found: INFOBASE_PATH" }
if (-not (Test-Path -LiteralPath $epf)) { throw "Vanessa EPF not found: VA_EPF_PATH" }
if (-not (Test-Path -LiteralPath $paramsPath)) { throw "VAParams.json not found" }

$launchJson = Get-Content -LiteralPath $paramsPath -Raw -Encoding UTF8
$featuresDir = Join-Path $repoRoot 'features'
function ConvertTo-JsonPath([string]$Path) { $Path.Replace('\', '\\') }
$launchJson = $launchJson.Replace(': "features"', (': "' + (ConvertTo-JsonPath $featuresDir) + '"'))
$launchJson = $launchJson.Replace(': "."', (': "' + (ConvertTo-JsonPath $repoRoot) + '"'))

$testClientKeys = Get-TestClientLaunchKeys -UserName $user -Password $password
if ($testClientKeys) {
    $fragPath = Join-Path $PSScriptRoot 'VAParams.testclient.json'
    if (-not (Test-Path -LiteralPath $fragPath)) {
        throw "VAParams.testclient.json not found"
    }
    $frag = Get-Content -LiteralPath $fragPath -Raw -Encoding UTF8
    $frag = $frag.Replace('__TESTCLIENT_KEYS__', (ConvertTo-JsonString $testClientKeys)).Trim()
    if ($frag.StartsWith('{')) { $frag = $frag.Substring(1) }
    if ($frag.EndsWith('}')) { $frag = $frag.Substring(0, $frag.Length - 1) }
    $closeBrace = $launchJson.LastIndexOf('}')
    if ($closeBrace -lt 0) { throw "VAParams.json: no closing brace" }
    $launchJson = $launchJson.Substring(0, $closeBrace).TrimEnd() + ',' + $frag + "`r`n}`r`n"
}

$launchName = 'VAParams.pssl.json'
[System.IO.File]::WriteAllText((Join-Path $ibPath $launchName), $launchJson, (New-Object System.Text.UTF8Encoding $false))

$listening = Get-NetTCPConnection -LocalPort ([int]$port) -State Listen -ErrorAction SilentlyContinue
if ($listening) {
    $owner = Get-Process -Id ($listening | Select-Object -First 1).OwningProcess -ErrorAction SilentlyContinue
    if (-not $owner -or $owner.ProcessName -ne '1cv8c') {
        throw "Port $port is in use by a process that is not 1cv8c"
    }
    Write-Host "MCP Vanessa already listening on port $port. New session not started."
    Write-Host "VAParams.pssl.json refreshed. Restart VA to apply."
    exit 0
}

$c = "runMcp;mcpPort=$port;VAParams=$launchName;DisableLoadConfig;DisableFirstRunHelper"
$argList = @(
    'ENTERPRISE',
    '/TESTMANAGER',
    "/F`"$ibPath`"",
    "/Execute`"$epf`"",
    "/C`"$c`"",
    '/UsePrivilegedMode'
)
if ($user) { $argList += "/N`"$user`"" }
if ($password) { $argList += "/P`"$password`"" }

Write-Host "Starting Vanessa MCP: port $port VAParams=$launchName"
Start-Process -FilePath $exe -ArgumentList $argList -WorkingDirectory $ibPath
