-- Source holds several versions per customer_id (e.g. credit_limit changes).
-- This model keeps the latest version only; full SCD2 history is slv_customers_history.
select
    {{ to_int('customer_id') }}                     as customer_id,
    upper({{ clean_string('customer_code') }})      as customer_code,
    {{ clean_string('customer_name') }}             as customer_name,
    -- source mixes 'Supermarket' / 'supermarket'
    initcap({{ clean_string('segment') }})          as segment,
    {{ to_int('region_id') }}                       as region_id,
    {{ to_int('account_manager_id') }}              as account_manager_id,
    {{ to_dec('credit_limit_usd', 2) }}             as credit_limit_usd,
    {{ to_int('payment_terms_days') }}              as payment_terms_days,
    lower({{ clean_string('email') }})              as email,
    {{ clean_string('phone') }}                     as phone,
    {{ to_ts('registered_at') }}                    as registered_at,
    {{ to_ts('updated_at') }}                       as updated_at,
    _loaded_at
from {{ ref('brz_customers') }}
qualify row_number() over (
    partition by customer_id
    order by {{ to_ts('updated_at') }} desc, _loaded_at desc
) = 1
