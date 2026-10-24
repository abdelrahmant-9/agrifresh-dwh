with typed as (
    select
        {{ to_int('order_line_id') }}       as order_line_id,
        {{ to_int('order_id') }}            as order_id,
        {{ to_int('product_id') }}          as product_id,
        {{ to_dec('quantity', 2) }}         as quantity,
        {{ to_dec('unit_price_usd') }}      as unit_price_usd,
        {{ to_dec('discount_pct', 4) }}     as discount_pct,
        _loaded_at
    from {{ ref('brz_sales_order_lines') }}
    qualify row_number() over (partition by order_line_id order by _loaded_at desc) = 1
)

select
    l.*,
    -- 84 lines carry negative quantities; kept and flagged, not dropped
    l.quantity < 0                                              as is_negative_quantity,
    l.quantity * l.unit_price_usd                               as gross_amount_usd,
    l.quantity * l.unit_price_usd * l.discount_pct              as discount_amount_usd,
    l.quantity * l.unit_price_usd * (1 - l.discount_pct)        as net_amount_usd
from typed l
-- drop orphan lines whose product is not in the product master (source has product_id 9999)
inner join {{ ref('slv_products') }} p
    on l.product_id = p.product_id
