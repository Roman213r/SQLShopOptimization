#Requires -Version 5.1
param(
    [ValidateSet("up", "init", "slow", "index", "fast", "all", "reset", "down")]
    [string]$Step = "all"
)

$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent $PSScriptRoot
Set-Location $Root

function Wait-Postgres {
    for ($i = 0; $i -lt 40; $i++) {
        docker compose exec -T postgres pg_isready -U shop -d shop 2>$null | Out-Null
        if ($LASTEXITCODE -eq 0) {
            return
        }
        Start-Sleep -Seconds 2
    }
    throw "PostgreSQL не піднявся. Перевірте Docker Desktop."
}

function Invoke-Sql([string]$PathInContainer, [string]$Title) {
    Write-Host ""
    Write-Host "======== $Title ========" -ForegroundColor Cyan
    Write-Host $PathInContainer -ForegroundColor DarkGray
    docker compose exec -T postgres psql -U shop -d shop -v ON_ERROR_STOP=1 -f $PathInContainer
    if ($LASTEXITCODE -ne 0) {
        throw "Помилка SQL: $PathInContainer"
    }
}

function Invoke-SqlString([string]$Sql, [string]$Title) {
    Write-Host ""
    Write-Host "======== $Title ========" -ForegroundColor Cyan
    docker compose exec -T postgres psql -U shop -d shop -v ON_ERROR_STOP=1 -c $Sql
}

$labs = @(
    "01_customer_orders",
    "02_top_customers",
    "03_admin_pagination",
    "04_low_stock",
    "05_product_search",
    "06_last_order",
    "07_unpaid_orders",
    "08_sales_report"
)

switch ($Step) {
    "up" {
        docker compose up -d
        Wait-Postgres
    }
    "init" {
        docker compose up -d
        Wait-Postgres
        Invoke-Sql "/sql/01_schema.sql" "Схема"
        Invoke-Sql "/sql/02_seed.sql" "Тестові дані (1-2 хв)"
        Invoke-SqlString "SELECT 'customers' AS t, count(*) FROM customers UNION ALL SELECT 'products', count(*) FROM products UNION ALL SELECT 'orders', count(*) FROM orders UNION ALL SELECT 'order_items', count(*) FROM order_items UNION ALL SELECT 'payments', count(*) FROM payments;" "Обсяг даних"
    }
    "slow" {
        foreach ($lab in $labs) {
            Invoke-Sql "/labs/$lab/slow.sql" "$lab / SLOW"
        }
    }
    "index" {
        Invoke-Sql "/sql/03_indexes.sql" "Робочі індекси"
    }
    "fast" {
        foreach ($lab in $labs) {
            Invoke-Sql "/labs/$lab/fast.sql" "$lab / FAST"
        }
        Invoke-Sql "/sql/05_materialized_view.sql" "Materialized view для дашборда"
    }
    "reset" {
        Invoke-Sql "/sql/04_reset_indexes.sql" "Прибрати робочі індекси"
        docker compose exec -T postgres psql -U shop -d shop -c "DROP MATERIALIZED VIEW IF EXISTS mv_daily_sales;"
    }
    "down" {
        docker compose down -v
    }
    "all" {
        docker compose up -d
        Wait-Postgres
        Invoke-Sql "/sql/01_schema.sql" "Схема"
        Invoke-Sql "/sql/02_seed.sql" "Тестові дані (1-2 хв)"
        foreach ($lab in $labs) {
            Invoke-Sql "/labs/$lab/slow.sql" "$lab / SLOW (без індексів)"
        }
        Invoke-Sql "/sql/03_indexes.sql" "Робочі індекси"
        foreach ($lab in $labs) {
            Invoke-Sql "/labs/$lab/fast.sql" "$lab / FAST"
        }
        Invoke-Sql "/sql/05_materialized_view.sql" "Materialized view для дашборда"
        Write-Host ""
        Write-Host "Готово. Порівняйте Execution Time і тип скану в планах вище." -ForegroundColor Green
        Write-Host "Повторити з чистими індексами: .\scripts\demo.ps1 -Step reset" -ForegroundColor Green
    }
}
