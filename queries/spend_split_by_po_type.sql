WITH per_doc_po AS (
  SELECT
    t.doc_id,
    MAX(
      CASE
        WHEN pf.field_key IN ('purchase_order_id', 'po_external_id', 'POExternalId')
        THEN pf.value_string
      END
    ) AS purchase_order_external_id,
    SUM(CASE WHEN pf.field_key = 'amount' THEN pf.value_number ELSE 0 END) AS amount_sum
  FROM prediction_fields pf
  JOIN tasks t ON t.task_id = pf.task_id
  JOIN documents d ON d.doc_id = t.doc_id
  WHERE d.received_at BETWEEN {{ from_ts }} AND {{ to_ts }}
    AND pf.version_end_date IS NULL
  GROUP BY t.doc_id
),
classified AS (
  SELECT
    x.doc_id,
    x.amount_sum,
    CASE
      WHEN x.purchase_order_external_id IS NULL THEN 'FI_NON_PO'
      ELSE po.purchase_order_type
    END AS category
  FROM per_doc_po x
  LEFT JOIN dt_purchase_orders po ON po.external_id = x.purchase_order_external_id
)
SELECT
  category,
  COUNT(*) AS document_count,
  SUM(amount_sum) AS total_amount
FROM classified
GROUP BY category
ORDER BY total_amount DESC;
