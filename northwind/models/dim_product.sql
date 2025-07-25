-- join
with stg_products as(
    select * from {{ source('northwind', 'Products')}}
),
stg_categories as (
    select * from {{source('northwind','Categories')}}
)

select
    {{ dbt_utils.generate_surrogate_key(['p.productid'])}} as productkey,
    p.productid,
    p.productname,
    p.supplierid,
    c.categoryname,
    c.description as categorydescription
from stg_products p
    left join stg_categories c on c.categoryid = p.categoryid
