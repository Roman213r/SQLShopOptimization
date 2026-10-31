CREATE INDEX IF NOT EXISTS idx_orders_customer_created
    ON orders (customer_id, created_at DESC);

CREATE INDEX IF NOT EXISTS idx_orders_status_created
    ON orders (status, created_at DESC);

CREATE INDEX IF NOT EXISTS idx_orders_paid_customer
    ON orders (customer_id)
    INCLUDE (total_amount, created_at)
    WHERE status IN ('paid', 'shipped');

CREATE INDEX IF NOT EXISTS idx_order_items_order
    ON order_items (order_id);

CREATE INDEX IF NOT EXISTS idx_order_items_product
    ON order_items (product_id);

CREATE INDEX IF NOT EXISTS idx_payments_order
    ON payments (order_id);

CREATE INDEX IF NOT EXISTS idx_payments_status
    ON payments (status);

CREATE INDEX IF NOT EXISTS idx_products_sku
    ON products (sku);

CREATE INDEX IF NOT EXISTS idx_products_category
    ON products (category_id);

CREATE INDEX IF NOT EXISTS idx_products_name_trgm
    ON products USING gin (name gin_trgm_ops);

CREATE INDEX IF NOT EXISTS idx_inventory_low_stock
    ON inventory (quantity)
    WHERE quantity < 10;

CREATE INDEX IF NOT EXISTS idx_customers_city_active
    ON customers (city)
    WHERE is_active;

ANALYZE customers;
ANALYZE products;
ANALYZE orders;
ANALYZE order_items;
ANALYZE payments;
ANALYZE inventory;
