TRUNCATE
    payments, order_items, orders, inventory,
    products, categories, customers, warehouses
    RESTART IDENTITY CASCADE;

INSERT INTO warehouses (name, city) VALUES
    ('Центральний', 'Київ'),
    ('Західний',    'Львів'),
    ('Південний',   'Одеса'),
    ('Східний',     'Харків');

INSERT INTO categories (id, name, parent_id) VALUES
    (1,  'Електроніка',     NULL),
    (2,  'Одяг',            NULL),
    (3,  'Дім та сад',      NULL),
    (4,  'Спорт',           NULL),
    (5,  'Краса',           NULL),
    (6,  'Смартфони',       1),
    (7,  'Ноутбуки',        1),
    (8,  'Навушники',       1),
    (9,  'Чоловічий одяг',  2),
    (10, 'Жіночий одяг',    2),
    (11, 'Кухня',           3),
    (12, 'Спальня',         3),
    (13, 'Фітнес',          4),
    (14, 'Велоспорт',       4),
    (15, 'Догляд за шкірою', 5);

SELECT setval('categories_id_seq', 15);

INSERT INTO customers (email, full_name, city, registered_at, is_active)
SELECT
    'user' || i || '@shop.test',
    'Клієнт ' || i,
    (ARRAY['Київ', 'Львів', 'Одеса', 'Харків', 'Дніпро', 'Вінниця'])[1 + (i % 6)],
    TIMESTAMPTZ '2023-01-01' + (i || ' minutes')::interval,
    (i % 17) <> 0
FROM generate_series(1, 10000) AS i;

INSERT INTO products (sku, name, category_id, price, created_at)
SELECT
    'SKU-' || lpad(i::text, 6, '0'),
    (ARRAY[
        'Смартфон Nova', 'Ноутбук Pulse', 'Навушники Wave',
        'Футболка Urban', 'Кросівки Trail', 'Кавоварка Home',
        'Крем Daily', 'Велосипед City', 'Планшет Slim'
    ])[1 + (i % 9)] || ' ' || i,
    6 + (i % 10),
    round((20 + (i % 980) + random() * 50)::numeric, 2),
    TIMESTAMPTZ '2023-01-01' + (i || ' hours')::interval
FROM generate_series(1, 4000) AS i;

INSERT INTO inventory (product_id, warehouse_id, quantity, updated_at)
SELECT
    p.id,
    w.id,
    CASE
        WHEN (p.id + w.id) % 40 = 0 THEN (p.id % 4)
        ELSE 15 + ((p.id * w.id) % 200)
    END,
    TIMESTAMPTZ '2025-01-01' + ((p.id + w.id) || ' hours')::interval
FROM products p
CROSS JOIN warehouses w;

INSERT INTO orders (customer_id, status, created_at, total_amount, shipping_city)
SELECT
    1 + (i % 10000),
    (ARRAY['pending', 'paid', 'shipped', 'cancelled', 'paid', 'shipped', 'paid'])[1 + (i % 7)],
    CASE
        WHEN i % 3 = 0 THEN now() - ((i % 90) || ' days')::interval - ((i % 1440) || ' minutes')::interval
        ELSE now() - ((90 + (i % 640)) || ' days')::interval - ((i % 180) || ' minutes')::interval
    END,
    round((40 + (i % 900) + random() * 80)::numeric, 2),
    (ARRAY['Київ', 'Львів', 'Одеса', 'Харків', 'Дніпро', 'Вінниця'])[1 + (i % 6)]
FROM generate_series(1, 120000) AS i;

INSERT INTO order_items (order_id, product_id, quantity, unit_price)
SELECT
    o.id,
    1 + ((o.id + n) % 4000),
    1 + (n % 3),
    round((20 + ((o.id + n) % 400))::numeric, 2)
FROM orders o
CROSS JOIN generate_series(1, 3) AS n;

INSERT INTO payments (order_id, amount, method, status, paid_at)
SELECT
    o.id,
    o.total_amount,
    (ARRAY['card', 'apple_pay', 'google_pay', 'iban'])[1 + (o.id % 4)],
    CASE
        WHEN o.status IN ('paid', 'shipped') THEN 'captured'
        WHEN o.status = 'pending' THEN 'pending'
        ELSE 'failed'
    END,
    CASE
        WHEN o.status IN ('paid', 'shipped') THEN o.created_at + interval '7 minutes'
        ELSE NULL
    END
FROM orders o
WHERE o.id % 9 <> 0;

ANALYZE customers;
ANALYZE products;
ANALYZE orders;
ANALYZE order_items;
ANALYZE payments;
ANALYZE inventory;
ANALYZE categories;
