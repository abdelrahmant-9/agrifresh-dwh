-- 1:1 copy of raw.sales_orders. No business logic: values stay as loaded (VARCHAR).
select
    order_id,
    order_number,
    customer_id,
    sales_rep_id,
    warehouse_id,
    order_date,
    requested_delivery_date,
    order_status,
    currency_code,
    channel,
    created_at,
    _source_file,
    _loaded_at
from {{ source('raw', 'sales_orders') }}
