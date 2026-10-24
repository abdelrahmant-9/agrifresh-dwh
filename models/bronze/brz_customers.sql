-- 1:1 copy of raw.customers. No business logic: values stay as loaded (VARCHAR).
select
    customer_id,
    customer_code,
    customer_name,
    segment,
    region_id,
    account_manager_id,
    credit_limit_usd,
    payment_terms_days,
    email,
    phone,
    registered_at,
    updated_at,
    _source_file,
    _loaded_at
from {{ source('raw', 'customers') }}
