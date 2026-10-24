-- 1:1 copy of raw.farms. No business logic: values stay as loaded (VARCHAR).
select
    farm_id,
    farm_code,
    farm_name,
    region_id,
    farm_size_feddan,
    certification,
    contract_start_date,
    contact_email,
    _source_file,
    _loaded_at
from {{ source('raw', 'farms') }}
