with stg_orders as
(
    select
        OrderID,
        {{ dbt_utils.generate_surrogate_key(['employeeid']) }} as employeekey,
        {{ dbt_utils.generate_surrogate_key(['customerid']) }} as customerkey,
        replace(to_date(orderdate)::varchar,'-','')::int as orderdatekey,
    from {{ source('northwind','Orders')}}
),
stg_order_details as
(
    select
        orderid,
        {{ dbt_utils.generate_surrogate_key(['productid'])}} as productkey,
        productid,
        Quantity,
        Quantity*UnitPrice as extendedpriceamount,
        extendedpriceamount*Discount as discountamount,
        extendedpriceamount - discountamount as soldamount
    from {{source('northwind','Order_Details')}}
),
stg_products as (
    select * from {{source('northwind','Products')}}
)
select o.OrderID,
    o.employeekey,
    o.customerkey,
    o.orderdatekey,
    od.productkey,
    od.Quantity,
    od.extendedpriceamount,
    od.discountamount,
    od.soldamount,
    p.* 
from stg_order_details od
join stg_products p on p.productid = od.productid
join stg_orders o on o.orderid = od.orderid
