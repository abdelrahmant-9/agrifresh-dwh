select
    {{ to_int('category_id') }}                  as category_id,
    upper({{ clean_string('category_code') }})   as category_code,
    {{ clean_string('category_name') }}          as category_name,
    -- source stores this as float text ('1.0'); to_int handles it
    {{ to_int('parent_category_id') }}           as parent_category_id,
    parent_category_id is null                   as is_top_level,
    _loaded_at
from {{ ref('brz_product_categories') }}
qualify row_number() over (partition by category_id order by _loaded_at desc) = 1
