select
    {{ to_int('warehouse_id') }}                   as warehouse_id,
    upper({{ clean_string('warehouse_code') }})    as warehouse_code,
    {{ clean_string('warehouse_name') }}           as warehouse_name,
    {{ to_int('region_id') }}                      as region_id,
    {{ to_int('capacity_tonnes') }}                as capacity_tonnes,
    {{ yn_to_bool('is_cold_storage') }}            as is_cold_storage,
    _loaded_at
from {{ ref('brz_warehouses') }}
qualify row_number() over (partition by warehouse_id order by _loaded_at desc) = 1
