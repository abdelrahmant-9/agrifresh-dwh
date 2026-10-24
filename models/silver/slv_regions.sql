select
    {{ to_int('region_id') }}                    as region_id,
    upper({{ clean_string('region_code') }})     as region_code,
    {{ clean_string('region_name') }}            as region_name,
    {{ clean_string('country') }}                as country,
    upper({{ clean_string('currency_code') }})   as currency_code,
    _loaded_at
from {{ ref('brz_regions') }}
qualify row_number() over (partition by region_id order by _loaded_at desc) = 1
