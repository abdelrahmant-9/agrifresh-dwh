-- 1:1 copy of raw.warehouses. No business logic: values stay as loaded (VARCHAR).
select
    warehouse_id,
    warehouse_code,
    warehouse_name,
    region_id,
    capacity_tonnes,
    is_cold_storage,
    _source_file,
    _loaded_at
from {{ source('raw', 'warehouses') }}
