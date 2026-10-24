-- 1:1 copy of raw.employees. No business logic: values stay as loaded (VARCHAR).
select
    employee_id,
    full_name,
    job_title,
    region_id,
    manager_id,
    hire_date,
    termination_date,
    _source_file,
    _loaded_at
from {{ source('raw', 'employees') }}
