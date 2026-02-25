WITH per_doc AS (
  SELECT
    t.doc_id,
    SUM(CASE WHEN pf.field_key = 'amount' THEN pf.value_number ELSE 0 END) AS amount_sum,
    MAX(CASE WHEN pf.field_key IN ('purchase_order_id', 'po_external_id', 'POExternalId') THEN 1 ELSE 0 END) AS has_po
  FROM prediction_fields pf
  JOIN tasks t ON t.task_id = pf.task_id
  JOIN documents d ON d.doc_id = t.doc_id
  WHERE d.received_at BETWEEN {{ from_ts }} AND {{ to_ts }}
    AND pf.version_end_date IS NULL
  GROUP BY t.doc_id
)
SELECT
  CASE WHEN has_po = 1 THEN 'PO' ELSE 'NON_PO' END AS bucket,
  COUNT(*) AS document_count,
  SUM(amount_sum) AS total_amount
FROM per_doc
GROUP BY bucket;
