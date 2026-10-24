select
    {{ to_int('farm_id') }}                       as farm_id,
    upper({{ clean_string('farm_code') }})        as farm_code,
    {{ clean_string('farm_name') }}               as farm_name,
    {{ to_int('region_id') }}                     as region_id,
    {{ to_int('farm_size_feddan') }}              as farm_size_feddan,
    -- source uses the literal string 'None' for uncertified farms; clean_string nulls it
    {{ clean_string('certification') }}           as certification,
    {{ clean_string('certification') }} is not null as is_certified,
    {{ to_date('contract_start_date') }}          as contract_start_date,
    lower({{ clean_string('contact_email') }})    as contact_email,
    _loaded_at
from {{ ref('brz_farms') }}
qualify row_number() over (partition by farm_id order by _loaded_at desc) = 1
