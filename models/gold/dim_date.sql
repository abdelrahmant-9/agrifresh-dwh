-- Calendar dimension. Range covers every date in the source (2023-11 .. 2026-11) with headroom.
with spine as (
    {{ dbt_utils.date_spine(
        datepart="day",
        start_date="to_date('2023-01-01')",
        end_date="to_date('2028-01-01')"
    ) }}
)

select
    to_number(to_char(date_day, 'YYYYMMDD'))     as date_key,
    date_day::date                               as date_day,
    year(date_day)                               as year,
    quarter(date_day)                            as quarter,
    'Q' || quarter(date_day)                     as quarter_name,
    month(date_day)                              as month,
    monthname(date_day)                          as month_short_name,
    to_char(date_day, 'MMMM')                    as month_name,
    to_char(date_day, 'YYYY-MM')                 as year_month,
    date_trunc('month', date_day)::date          as month_start_date,
    weekofyear(date_day)                         as week_of_year,
    day(date_day)                                as day_of_month,
    dayofweekiso(date_day)                       as day_of_week_iso,
    dayname(date_day)                            as day_short_name,
    -- Egypt / KSA / UAE weekend is Friday + Saturday
    dayofweekiso(date_day) in (5, 6)             as is_weekend
from spine
