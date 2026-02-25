WITH inv_docs AS (
  SELECT d.doc_id, i.payment_date
  FROM documents d
  JOIN dt_invoices i ON i.external_id = d.external_database_id
  WHERE d.received_at BETWEEN {{ from_ts }} AND {{ to_ts }}
    AND i.payment_date IS NOT NULL
),
inv_delivery_notes AS (
  SELECT
    t.doc_id,
    MIN(dn.created_at) AS goods_receipt_date
  FROM prediction_fields pf
  JOIN tasks t ON t.task_id = pf.task_id
  JOIN dt_delivery_notes dn
    ON BIN_TO_UUID(dn.id) = pf.value_string
  WHERE pf.field_key = 'delivery_note_id'
    AND pf.version_end_date IS NULL
  GROUP BY t.doc_id
)
SELECT
  AVG(TIMESTAMPDIFF(DAY, idn.goods_receipt_date, inv.payment_date)) AS avg_goods_receipt_to_pay_days
FROM inv_docs inv
JOIN inv_delivery_notes idn ON idn.doc_id = inv.doc_id
WHERE idn.goods_receipt_date IS NOT NULL;
