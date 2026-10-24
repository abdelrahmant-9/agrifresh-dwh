-- Grain: one row per sales order line.
-- Amounts are in USD (source unit prices are USD); local-currency net is derived via the
-- order month's FX rate (rate = local -> USD, so local = usd / rate).
with lines as (
    select * from {{ ref('slv_sales_order_lines') }}
),

orders as (
    select * from {{ ref('slv_sales_orders') }}
),

fx as (
    select * from {{ ref('slv_fx_rates') }}
    where to_currency = 'USD'
)

select
    l.order_line_id,
    o.order_id,
    o.order_number,

    -- dimension keys
    to_number(to_char(o.order_date, 'YYYYMMDD'))                    as order_date_key,
    to_number(to_char(o.requested_delivery_date, 'YYYYMMDD'))       as requested_delivery_date_key,
    {{ dbt_utils.generate_surrogate_key(['o.customer_id']) }}       as customer_key,
    {{ dbt_utils.generate_surrogate_key(['l.product_id']) }}        as product_key,
    o.warehouse_id,
    o.sales_rep_id,

    -- degenerate attributes
    o.order_status,
    o.channel,
    o.currency_code,
    o.order_status in ('DELIVERED', 'SHIPPED')                      as is_revenue_recognized,
    l.is_negative_quantity,

    -- measures (USD)
    l.quantity,
    l.unit_price_usd,
    l.discount_pct,
    l.gross_amount_usd,
    l.discount_amount_usd,
    l.net_amount_usd,
    l.quantity * p.standard_cost_usd                                as cost_amount_usd,
    l.net_amount_usd - l.quantity * p.standard_cost_usd             as gross_margin_usd,

    -- measures (order currency)
    fx.rate                                                         as fx_rate_to_usd,
    l.net_amount_usd / nullif(fx.rate, 0)                           as net_amount_local
from lines l
inner join orders o
    on l.order_id = o.order_id
left join {{ ref('slv_products') }} p
    on l.product_id = p.product_id
left join fx
    on fx.rate_month = o.order_month
   and fx.from_currency = o.currency_code
