WITH due_latest AS (
  SELECT doc_id, due_date
  FROM (
    SELECT
      t.doc_id,
      pf.value_date AS due_date,
      ROW_NUMBER() OVER (
        PARTITION BY t.doc_id
        ORDER BY COALESCE(pf.version_start_date, pf.created_at) DESC, pf.created_at DESC
      ) AS rn
    FROM prediction_fields pf
    JOIN tasks t ON t.task_id = pf.task_id
    WHERE pf.version_end_date IS NULL
      AND pf.field_type = 'SCALAR'
      AND pf.value_date IS NOT NULL
      AND pf.field_key IN ('due_date', 'DueDate')
  ) x
  WHERE rn = 1
)
SELECT
  ROUND(
    100
    * SUM(
      CASE
        WHEN i.payment_date IS NOT NULL AND i.payment_date <= dd.due_date THEN 1
        ELSE 0
      END
    )
    / NULLIF(COUNT(*), 0),
    2
  ) AS on_time_payment_rate_pct
FROM documents d
JOIN dt_invoices i ON i.external_id = d.external_database_id
JOIN due_latest dd ON dd.doc_id = d.doc_id
WHERE d.received_at BETWEEN {{ from_ts }} AND {{ to_ts }};
