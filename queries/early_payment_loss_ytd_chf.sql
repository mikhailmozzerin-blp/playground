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
),
inv AS (
  SELECT
    d.doc_id,
    i.total_amount,
    i.payment_date,
    dd.due_date,
    i.cash_discount_amount
  FROM documents d
  JOIN dt_invoices i ON i.external_id = d.external_database_id
  JOIN due_latest dd ON dd.doc_id = d.doc_id
  WHERE d.received_at >= {{ ytd_start_ts }}
    AND d.received_at < {{ ytd_end_ts }}
    AND i.payment_date IS NOT NULL
)
SELECT
  SUM(
    CASE
      WHEN inv.payment_date < inv.due_date
        AND (inv.cash_discount_amount IS NULL OR inv.cash_discount_amount = 0)
      THEN inv.total_amount
        * GREATEST(TIMESTAMPDIFF(DAY, inv.payment_date, inv.due_date), 0)
        * {{ cost_of_capital_daily }}
      ELSE 0
    END
  ) AS early_payment_loss_chf_ytd
FROM inv;
