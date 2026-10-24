-- 1:1 copy of raw.products. No business logic: values stay as loaded (VARCHAR).
select
    product_id,
    sku,
    product_name,
    category_id,
    unit_of_measure,
    shelf_life_days,
    standard_cost_usd,
    list_price_usd,
    is_organic,
    is_active,
    created_at,
    _source_file,
    _loaded_at
from {{ source('raw', 'products') }}
