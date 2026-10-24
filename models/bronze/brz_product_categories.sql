-- 1:1 copy of raw.product_categories. No business logic: values stay as loaded (VARCHAR).
select
    category_id,
    category_code,
    category_name,
    parent_category_id,
    _source_file,
    _loaded_at
from {{ source('raw', 'product_categories') }}
