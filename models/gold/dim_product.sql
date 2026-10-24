-- Products with their category and top-level (parent) category flattened in.
select
    {{ dbt_utils.generate_surrogate_key(['p.product_id']) }}   as product_key,
    p.product_id,
    p.sku,
    p.product_name,
    p.unit_of_measure,
    p.shelf_life_days,
    p.standard_cost_usd,
    p.list_price_usd,
    p.unit_margin_usd,
    p.margin_pct,
    p.is_organic,
    p.is_active,
    c.category_id,
    c.category_code,
    c.category_name,
    -- top-level categories are their own parent
    coalesce(pc.category_name, c.category_name)                as parent_category_name
from {{ ref('slv_products') }} p
left join {{ ref('slv_product_categories') }} c
    on p.category_id = c.category_id
left join {{ ref('slv_product_categories') }} pc
    on c.parent_category_id = pc.category_id
