select
    {{ to_int('order_id') }}                        as order_id,
    upper({{ clean_string('order_number') }})       as order_number,
    {{ to_int('customer_id') }}                     as customer_id,
    {{ to_int('sales_rep_id') }}                    as sales_rep_id,
    {{ to_int('warehouse_id') }}                    as warehouse_id,
    {{ to_date('order_date') }}                     as order_date,
    date_trunc('month', {{ to_date('order_date') }}) as order_month,
    {{ to_date('requested_delivery_date') }}        as requested_delivery_date,
    upper({{ clean_string('order_status') }})       as order_status,
    upper({{ clean_string('currency_code') }})      as currency_code,
    {{ clean_string('channel') }}                   as channel,
    {{ to_ts('created_at') }}                       as created_at,
    _loaded_at
from {{ ref('brz_sales_orders') }}
qualify row_number() over (partition by order_id order by _loaded_at desc) = 1
