with typed as (
    select
        {{ to_int('shipment_id') }}                     as shipment_id,
        {{ to_int('order_id') }}                        as order_id,
        {{ clean_string('carrier') }}                   as carrier,
        {{ to_ts('shipped_at') }}                       as shipped_at,
        -- NULL while the order is still in transit (status SHIPPED)
        {{ to_ts('delivered_at') }}                     as delivered_at,
        {{ yn_to_bool('temperature_breach_flag') }}     as has_temperature_breach,
        {{ to_dec('freight_cost_usd', 2) }}             as freight_cost_usd,
        _loaded_at
    from {{ ref('brz_shipments') }}
    qualify row_number() over (partition by shipment_id order by _loaded_at desc) = 1
)

select
    s.*,
    s.delivered_at is not null                                      as is_delivered,
    datediff(hour, s.shipped_at, s.delivered_at)                    as transit_hours,
    case
        when s.delivered_at is null then null
        else s.delivered_at::date <= o.requested_delivery_date
    end                                                             as is_on_time
from typed s
left join {{ ref('slv_sales_orders') }} o
    on s.order_id = o.order_id
