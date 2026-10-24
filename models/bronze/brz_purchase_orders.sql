-- 1:1 copy of raw.purchase_orders. No business logic: values stay as loaded (VARCHAR).
select
    purchase_order_id,
    po_number,
    farm_id,
    product_id,
    warehouse_id,
    harvest_date,
    received_date,
    quantity_received,
    quantity_rejected,
    unit_cost_usd,
    quality_grade,
    _source_file,
    _loaded_at
from {{ source('raw', 'purchase_orders') }}
