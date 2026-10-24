-- A payment cannot be dated before the order it pays for.
select p.*
from {{ ref('slv_payments') }} p
inner join {{ ref('slv_sales_orders') }} o
    on p.order_id = o.order_id
where p.payment_date < o.order_date
