with typed as (
    select
        {{ to_int('product_id') }}                     as product_id,
        upper({{ clean_string('sku') }})               as sku,
        -- a few names arrive upper-cased with padding ('  ONION WHITE ')
        initcap({{ clean_string('product_name') }})    as product_name,
        {{ to_int('category_id') }}                    as category_id,
        upper({{ clean_string('unit_of_measure') }})   as unit_of_measure,
        {{ to_int('shelf_life_days') }}                as shelf_life_days,
        {{ to_dec('standard_cost_usd') }}              as standard_cost_usd,
        {{ to_dec('list_price_usd') }}                 as list_price_usd,
        {{ yn_to_bool('is_organic') }}                 as is_organic,
        {{ yn_to_bool('is_active') }}                  as is_active,
        {{ to_ts('created_at') }}                      as created_at,
        _loaded_at
    from {{ ref('brz_products') }}
    qualify row_number() over (partition by product_id order by _loaded_at desc) = 1
)

select
    *,
    list_price_usd - standard_cost_usd                                   as unit_margin_usd,
    (list_price_usd - standard_cost_usd) / nullif(list_price_usd, 0)     as margin_pct
from typed
