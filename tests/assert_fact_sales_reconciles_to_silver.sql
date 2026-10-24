-- fact_sales must carry every Silver order line and the same net total (no fan-out, no drops).
with gold as (
    select count(*) as line_count, sum(net_amount_usd) as net_usd
    from {{ ref('fact_sales') }}
),

silver as (
    select count(*) as line_count, sum(net_amount_usd) as net_usd
    from {{ ref('slv_sales_order_lines') }}
)

select *
from gold
cross join silver
where gold.line_count != silver.line_count
   or abs(gold.net_usd - silver.net_usd) > 0.01
