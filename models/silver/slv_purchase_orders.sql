with typed as (
    select
        {{ to_int('purchase_order_id') }}           as purchase_order_id,
        upper({{ clean_string('po_number') }})      as po_number,
        {{ to_int('farm_id') }}                     as farm_id,
        {{ to_int('product_id') }}                  as product_id,
        {{ to_int('warehouse_id') }}                as warehouse_id,
        {{ to_date('harvest_date') }}               as harvest_date,
        {{ to_date('received_date') }}              as received_date,
        {{ to_dec('quantity_received', 2) }}        as quantity_received,
        {{ to_dec('quantity_rejected', 2) }}        as quantity_rejected,
        {{ to_dec('unit_cost_usd') }}               as unit_cost_usd,
        upper({{ clean_string('quality_grade') }})  as quality_grade,
        _loaded_at
    from {{ ref('brz_purchase_orders') }}
    qualify row_number() over (partition by purchase_order_id order by _loaded_at desc) = 1
)

select
    *,
    quantity_received - quantity_rejected                          as quantity_accepted,
    quantity_rejected / nullif(quantity_received, 0)               as reject_rate,
    (quantity_received - quantity_rejected) * unit_cost_usd        as accepted_cost_usd,
    datediff(day, harvest_date, received_date)                     as harvest_to_receipt_days
from typed
