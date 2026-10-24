-- Current state of each customer (SCD1), denormalised with region and account manager.
select
    {{ dbt_utils.generate_surrogate_key(['c.customer_id']) }}  as customer_key,
    c.customer_id,
    c.customer_code,
    c.customer_name,
    c.segment,
    c.credit_limit_usd,
    c.payment_terms_days,
    c.email,
    c.phone,
    c.registered_at,
    r.region_id,
    r.region_code,
    r.region_name,
    r.country,
    r.currency_code,
    c.account_manager_id,
    e.full_name                                                as account_manager_name,
    c.updated_at
from {{ ref('slv_customers') }} c
left join {{ ref('slv_regions') }} r
    on c.region_id = r.region_id
left join {{ ref('slv_employees') }} e
    on c.account_manager_id = e.employee_id
