-- 1:1 copy of raw.shipments. No business logic: values stay as loaded (VARCHAR).
select
    shipment_id,
    order_id,
    carrier,
    shipped_at,
    delivered_at,
    temperature_breach_flag,
    freight_cost_usd,
    _source_file,
    _loaded_at
from {{ source('raw', 'shipments') }}
