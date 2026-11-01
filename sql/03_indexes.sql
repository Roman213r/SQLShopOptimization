DROP INDEX IF EXISTS idx_orders_customer_created;
CREATE INDEX idx_orders_customer_created
    ON orders (customer_id, created_at DESC)
    INCLUDE (status, total_amount, shipping_city);

DROP INDEX IF EXISTS idx_orders_status_created;
CREATE INDEX idx_orders_status_created
    ON orders (status, created_at DESC, id DESC)
    INCLUDE (customer_id, total_amount);

DROP INDEX IF EXISTS idx_orders_paid_customer;
CREATE INDEX idx_orders_paid_customer
    ON orders (customer_id)
    INCLUDE (total_amount, created_at)
    WHERE status IN ('paid', 'shipped');

DROP INDEX IF EXISTS idx_orders_paid_created;
CREATE INDEX idx_orders_paid_created
    ON orders (created_at, customer_id)
    INCLUDE (total_amount)
    WHERE status IN ('paid', 'shipped');

DROP INDEX IF EXISTS idx_orders_created_brin;
CREATE INDEX idx_orders_created_brin
    ON orders USING brin (created_at);

DROP INDEX IF EXISTS idx_order_items_order;
CREATE INDEX idx_order_items_order
    ON order_items (order_id)
    INCLUDE (product_id, quantity, unit_price);

DROP INDEX IF EXISTS idx_order_items_product;
CREATE INDEX idx_order_items_product
    ON order_items (product_id);

DROP INDEX IF EXISTS idx_payments_order;
CREATE INDEX idx_payments_order
    ON payments (order_id);

DROP INDEX IF EXISTS idx_payments_status;
CREATE INDEX idx_payments_status
    ON payments (status);

DROP INDEX IF EXISTS idx_payments_captured_order;
CREATE INDEX idx_payments_captured_order
    ON payments (order_id)
    WHERE status = 'captured';

DROP INDEX IF EXISTS idx_products_sku;
CREATE INDEX idx_products_sku
    ON products (sku);

DROP INDEX IF EXISTS idx_products_category;
CREATE INDEX idx_products_category
    ON products (category_id);

DROP INDEX IF EXISTS idx_products_name_trgm;
CREATE INDEX idx_products_name_trgm
    ON products USING gin (name gin_trgm_ops);

DROP INDEX IF EXISTS idx_products_name_fts;
CREATE INDEX idx_products_name_fts
    ON products USING gin (to_tsvector('simple', name));

DROP INDEX IF EXISTS idx_inventory_low_stock;
CREATE INDEX idx_inventory_low_stock
    ON inventory (quantity, product_id)
    INCLUDE (warehouse_id)
    WHERE quantity < 10;

DROP INDEX IF EXISTS idx_customers_city_active;
CREATE INDEX idx_customers_city_active
    ON customers (city)
    INCLUDE (full_name, email)
    WHERE is_active;

ANALYZE customers;
ANALYZE products;
ANALYZE orders;
ANALYZE order_items;
ANALYZE payments;
ANALYZE inventory;
