-- A shipment cannot be delivered before it was shipped.
select *
from {{ ref('slv_shipments') }}
where delivered_at < shipped_at
