param(
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$PsqlArgs
)

$Root = Split-Path -Parent $PSScriptRoot
Set-Location $Root

if ($PsqlArgs.Count -eq 0) {
    docker compose exec postgres psql -U shop -d shop
} else {
    docker compose exec -T postgres psql -U shop -d shop @PsqlArgs
}
