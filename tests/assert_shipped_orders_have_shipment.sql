-- Every SHIPPED / DELIVERED / RETURNED order should have a shipment row.
select o.*
from {{ ref('slv_sales_orders') }} o
left join {{ ref('slv_shipments') }} s
    on o.order_id = s.order_id
where o.order_status in ('SHIPPED', 'DELIVERED', 'RETURNED')
  and s.shipment_id is null
