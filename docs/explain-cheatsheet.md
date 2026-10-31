# Як читати EXPLAIN ANALYZE

У кожній лабі запит обгорнутий у `EXPLAIN (ANALYZE, BUFFERS)`.
Це не «результат для UI», а план виконання — головний інструмент оптимізації.

## Що дивитися першим

| Поле | На що вказує |
| --- | --- |
| `Execution Time` | Реальний час. Це головна метрика «було / стало». |
| `Seq Scan` | Повний прохід таблиці. Нормально на 100 рядках, погано на 120 000. |
| `Index Scan` / `Index Only Scan` | Планувальник пішов по індексу. |
| `Bitmap Heap Scan` | Компроміс: індекс знайшов багато рядків, далі читає сторінки купи. |
| `Nested Loop` + великий inner | Часто наслідок корельованого підзапиту. |
| `Hash Join` / `Merge Join` | Звичайні плани для звітів; дивіться на обсяг рядків, не на назву. |
| `actual rows` vs `planned rows` | Крива статистика. Лікується `ANALYZE` / свіжішим `autovacuum`. |
| `Buffers: shared read` | Читання з диска. Після прогріву має впасти `read`, лишитися `hit`. |

## Типові антипатерни з цього проєкту

1. Немає індексу під `WHERE` + `ORDER BY` → Seq Scan + Sort.
2. Корельований підзапит у `SELECT` → Nested Loop × N клієнтів.
3. `OFFSET 40000` → прочитати 40 050 рядків, відкинути 40 000.
4. `LIKE '%текст%'` без `pg_trgm` → Seq Scan.
5. `created_at::date = ...` → індекс по `created_at` не використовується.
6. `NOT IN (SELECT ...)` → гірший план і сюрпризи з `NULL`.
7. `SELECT *` у списках адмінки → зайві сторінки з купи, немає Index Only Scan.

## Корисні команди

```sql
-- Які індекси вже є
SELECT indexname, indexdef
FROM pg_indexes
WHERE tablename = 'orders';

-- Чи індекс взагалі читають
SELECT relname, idx_scan, seq_scan
FROM pg_stat_user_tables
WHERE relname IN ('orders', 'order_items', 'products');

-- Оновити статистику після великого seed
ANALYZE;
```
