# Лабораторні

Кожна папка — окремий екран інтернет-магазину.

1. Відкрийте `README.md` у папці лаби — там антипатерн і лікування.
2. Запустіть `slow.sql` на базі **без** `sql/03_indexes.sql`.
3. Накладіть індекси, запустіть `fast.sql`.
4. Порівняйте `Execution Time` і тип скану.

Повний прогін: `.\scripts\demo.ps1 -Step all`.
Одна лаба вручну:

```powershell
.\scripts\psql.ps1 -f /labs/01_customer_orders/slow.sql
```
