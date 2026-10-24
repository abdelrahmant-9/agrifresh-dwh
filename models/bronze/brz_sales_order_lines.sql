-- 1:1 copy of raw.sales_order_lines. No business logic: values stay as loaded (VARCHAR).
select
    order_line_id,
    order_id,
    product_id,
    quantity,
    unit_price_usd,
    discount_pct,
    _source_file,
    _loaded_at
from {{ source('raw', 'sales_order_lines') }}
