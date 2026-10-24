-- 1:1 copy of raw.fx_rates. No business logic: values stay as loaded (VARCHAR).
select
    rate_month,
    from_currency,
    to_currency,
    rate,
    _source_file,
    _loaded_at
from {{ source('raw', 'fx_rates') }}
