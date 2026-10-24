-- Grain: one row per purchase order (one farm, one product, one receipt).
select
    po.purchase_order_id,
    po.po_number,

    -- dimension keys
    to_number(to_char(po.received_date, 'YYYYMMDD'))                as received_date_key,
    to_number(to_char(po.harvest_date, 'YYYYMMDD'))                 as harvest_date_key,
    {{ dbt_utils.generate_surrogate_key(['po.product_id']) }}       as product_key,
    po.farm_id,
    f.farm_name,
    f.is_certified                                                  as is_farm_certified,
    po.warehouse_id,

    -- degenerate attributes
    po.quality_grade,

    -- measures
    po.quantity_received,
    po.quantity_rejected,
    po.quantity_accepted,
    po.reject_rate,
    po.unit_cost_usd,
    po.quantity_received * po.unit_cost_usd                         as received_cost_usd,
    po.accepted_cost_usd,
    po.quantity_rejected * po.unit_cost_usd                         as rejected_cost_usd,
    po.harvest_to_receipt_days
from {{ ref('slv_purchase_orders') }} po
left join {{ ref('slv_farms') }} f
    on po.farm_id = f.farm_id
