# AgriFresh DWH (Snowflake + dbt)

Two-layer warehouse for the AgriFresh source CSVs.

```
data/*.csv ──PUT/COPY──> AGRIFRESH.RAW      (VARCHAR landing tables)
                            │  dbt
                            ▼
                         AGRIFRESH.BRONZE   (brz_*  views, 1:1 with raw + _source_file/_loaded_at)
                            │  dbt
                            ▼
                         AGRIFRESH.SILVER   (slv_*  tables: typed, cleaned, deduped, tested)
                            │  dbt
                            ▼
                         AGRIFRESH.GOLD     (star schema: dim_date, dim_customer, dim_product,
                                             fact_sales [order line], fact_purchases [PO])
```

## Run order

1. **Snowflake setup:** run `snowflake/01_setup.sql` (replace `<YOUR_USER>` first).
2. **Load raw:** run `snowflake/02_load_raw.sql` from SnowSQL or `snow sql` (PUT needs a CLI client).
3. **dbt:**
   ```bash
   # key-pair auth; private key at ~/.snowflake/agrifresh_rsa_key.p8
   # SNOWFLAKE_USER is the user's LOGIN_NAME (key-pair JWT fails with the user name if they differ)
   export SNOWFLAKE_ACCOUNT=<ORGNAME-ACCOUNTNAME>  SNOWFLAKE_USER=<LOGIN_NAME>
   dbt deps
   dbt debug
   dbt build            # runs bronze + silver models and all tests
   dbt docs generate && dbt docs serve
   ```
   Run one layer only: `dbt build -s tag:bronze` / `tag:silver` / `tag:gold`.

## Cleaning applied in SILVER

| Source issue | Fix | Model |
|---|---|---|
| All columns are text | `try_to_*` casts via `macros/cleaning.sql` | all |
| Y/N flags | BOOLEAN | products, warehouses, shipments |
| `segment` mixed case (`supermarket`) | `initcap(trim())` | slv_customers |
| 8 customers with several versions | latest by `updated_at`; full SCD2 in `slv_customers_history` | slv_customers |
| Product names upper-cased + padded | `initcap(trim())` | slv_products |
| `certification = 'None'` | NULL + `is_certified` | slv_farms |
| `parent_category_id = '1.0'` | integer | slv_product_categories |
| USD->USD rate != 1 | forced to 1 | slv_fx_rates |
| Order line with product_id 9999 | dropped (inner join to products) | slv_sales_order_lines |
| 84 negative line quantities | kept, `is_negative_quantity` flag, warn-level test | slv_sales_order_lines |
| Negative payments | kept, `is_refund` flag | slv_payments |
| Payment dates in the future | kept, `is_future_dated` flag | slv_payments |
| `delivered_at` empty for in-transit | NULL + `is_delivered` | slv_shipments |

## Open questions for the business

- Negative quantities: returns, or entry errors?
- Future-dated payments: post-dated cheques, or bad data?
- Orphan product 9999: test record to delete at source?
