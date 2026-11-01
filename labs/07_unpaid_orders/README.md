# Лаба 07. Замовлення без успішної оплати

Типовий антифрод / бухгалтерія: знайти `paid`, для яких немає `captured` платежу.

**Антипатерн:** `NOT IN (SELECT order_id ...)` погано переносить `NULL` і часто гірше планується.

**Оптимізація:** anti-join `LEFT JOIN ... WHERE p.order_id IS NULL` і частковий індекс `payments(order_id) WHERE status = 'captured'`.
