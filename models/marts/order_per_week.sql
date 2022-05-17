select

    date_trunc('week', order_date) AS order_week,
    status,
    count(order_pk)

from {{ ref('sat_order_details') }}

group by 1,2
