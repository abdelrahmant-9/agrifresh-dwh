-- SCD Type 2 view of customers built from the versions already present in the source.
-- (A dbt snapshot would only see the latest version per load, so history is derived here.)
with versions as (
    select
        {{ to_int('customer_id') }}                     as customer_id,
        upper({{ clean_string('customer_code') }})      as customer_code,
        {{ clean_string('customer_name') }}             as customer_name,
        initcap({{ clean_string('segment') }})          as segment,
        {{ to_int('region_id') }}                       as region_id,
        {{ to_int('account_manager_id') }}              as account_manager_id,
        {{ to_dec('credit_limit_usd', 2) }}             as credit_limit_usd,
        {{ to_int('payment_terms_days') }}              as payment_terms_days,
        {{ to_ts('updated_at') }}                       as updated_at
    from {{ ref('brz_customers') }}
    qualify row_number() over (
        partition by customer_id, updated_at
        order by _loaded_at desc
    ) = 1
)

select
    {{ dbt_utils.generate_surrogate_key(['customer_id', 'updated_at']) }} as customer_version_key,
    *,
    updated_at                                                                    as valid_from,
    lead(updated_at) over (partition by customer_id order by updated_at)          as valid_to,
    lead(updated_at) over (partition by customer_id order by updated_at) is null  as is_current
from versions
