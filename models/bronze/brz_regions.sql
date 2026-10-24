-- 1:1 copy of raw.regions. No business logic: values stay as loaded (VARCHAR).
select
    region_id,
    region_code,
    region_name,
    country,
    currency_code,
    _source_file,
    _loaded_at
from {{ source('raw', 'regions') }}
