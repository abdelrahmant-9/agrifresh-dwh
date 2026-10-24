-- 1:1 copy of raw.payments. No business logic: values stay as loaded (VARCHAR).
select
    payment_id,
    order_id,
    payment_date,
    amount_usd,
    payment_method,
    _source_file,
    _loaded_at
from {{ source('raw', 'payments') }}
