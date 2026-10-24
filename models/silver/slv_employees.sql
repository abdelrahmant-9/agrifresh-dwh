select
    {{ to_int('employee_id') }}              as employee_id,
    {{ clean_string('full_name') }}          as full_name,
    {{ clean_string('job_title') }}          as job_title,
    {{ to_int('region_id') }}                as region_id,
    {{ to_int('manager_id') }}               as manager_id,
    {{ to_date('hire_date') }}               as hire_date,
    {{ to_date('termination_date') }}        as termination_date,
    {{ to_date('termination_date') }} is null as is_active,
    _loaded_at
from {{ ref('brz_employees') }}
qualify row_number() over (partition by employee_id order by _loaded_at desc) = 1
