select
    {{ to_date('rate_month') }}                    as rate_month,
    upper({{ clean_string('from_currency') }})     as from_currency,
    upper({{ clean_string('to_currency') }})       as to_currency,
    -- source has USD->USD rows with noise (1.000987); identity rate must be exactly 1
    case
        when upper(trim(from_currency)) = upper(trim(to_currency)) then 1
        else {{ to_dec('rate', 6) }}
    end::number(18, 6)                             as rate,
    _loaded_at
from {{ ref('brz_fx_rates') }}
qualify row_number() over (
    partition by rate_month, from_currency, to_currency
    order by _loaded_at desc
) = 1
