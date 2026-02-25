SELECT
  ROUND(
    100
    * SUM(
      CASE
        WHEN i.invoice_status IN {{ reversal_statuses_csv }} THEN 1
        ELSE 0
      END
    )
    / NULLIF(COUNT(*), 0),
    2
  ) AS posting_reversal_rate_pct
FROM documents d
JOIN dt_invoices i ON i.external_id = d.external_database_id
WHERE d.received_at BETWEEN {{ from_ts }} AND {{ to_ts }}
  AND d.external_database_id IS NOT NULL;
