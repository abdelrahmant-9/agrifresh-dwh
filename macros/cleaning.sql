{# Reusable cleaning helpers for the SILVER layer. All inputs are raw VARCHAR columns. #}

{# Trim, and turn empty strings / placeholder tokens ('None', 'NULL', 'N/A') into real NULLs. #}
{% macro clean_string(col) -%}
    case
        when upper(trim({{ col }})) in ('', 'NONE', 'NULL', 'N/A', 'NAN') then null
        else trim({{ col }})
    end
{%- endmacro %}

{# 'Y' / 'N' flags -> BOOLEAN. Anything else becomes NULL (caught by not_null tests). #}
{% macro yn_to_bool(col) -%}
    case upper(trim({{ col }}))
        when 'Y' then true
        when 'N' then false
    end
{%- endmacro %}

{# Integer ids. Goes through DECIMAL so values like '1.0' still parse. #}
{% macro to_int(col) -%}
    try_to_decimal(trim({{ col }}), 38, 4)::integer
{%- endmacro %}

{% macro to_dec(col, scale=4) -%}
    try_to_decimal(trim({{ col }}), 18, {{ scale }})
{%- endmacro %}

{% macro to_date(col) -%}
    try_to_date(trim({{ col }}), 'YYYY-MM-DD')
{%- endmacro %}

{% macro to_ts(col) -%}
    try_to_timestamp_ntz(trim({{ col }}), 'YYYY-MM-DD HH24:MI:SS')
{%- endmacro %}
