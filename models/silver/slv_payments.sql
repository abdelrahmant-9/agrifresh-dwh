select
    {{ to_int('payment_id') }}                  as payment_id,
    {{ to_int('order_id') }}                    as order_id,
    {{ to_date('payment_date') }}               as payment_date,
    {{ to_dec('amount_usd', 2) }}               as amount_usd,
    {{ clean_string('payment_method') }}        as payment_method,
    -- negative amounts look like refunds; kept and flagged
    {{ to_dec('amount_usd', 2) }} < 0           as is_refund,
    -- source contains payment dates after the extract date; kept and flagged
    {{ to_date('payment_date') }} > current_date() as is_future_dated,
    _loaded_at
from {{ ref('brz_payments') }}
qualify row_number() over (partition by payment_id order by _loaded_at desc) = 1
