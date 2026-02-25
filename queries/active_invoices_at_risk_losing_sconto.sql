WITH open_docs AS (
  SELECT DISTINCT t.doc_id
  FROM tasks t
  WHERE t.status = 'OPEN'
),
writeback_done AS (
  SELECT DISTINCT t.doc_id
  FROM task_actions a
  JOIN tasks t ON t.task_id = a.task_id
  WHERE a.action = 'CATEGORY_CHANGE'
    AND JSON_UNQUOTE(JSON_EXTRACT(a.action_metadata_json, '$.category_to')) = 'FETCHED'
),
inv_bp AS (
  SELECT d.doc_id, di.business_partner_id, di.posting_date
  FROM documents d
  JOIN dt_invoices di ON di.external_id = d.external_database_id
),
po_map AS (
  SELECT
    t.doc_id,
    MAX(
      CASE
        WHEN pf.field_key IN ('purchase_order_id', 'po_external_id', 'POExternalId')
        THEN pf.value_string
      END
    ) AS purchase_order_external_id
  FROM prediction_fields pf
  JOIN tasks t ON t.task_id = pf.task_id
  WHERE pf.version_end_date IS NULL
  GROUP BY t.doc_id
),
potential_pc AS (
  SELECT
    od.doc_id,
    COALESCE(po.payment_condition_id, bp.payment_condition_id) AS pc_id,
    ib.posting_date
  FROM open_docs od
  LEFT JOIN po_map pm ON pm.doc_id = od.doc_id
  LEFT JOIN dt_purchase_orders po ON po.external_id = pm.purchase_order_external_id
  LEFT JOIN inv_bp ib ON ib.doc_id = od.doc_id
  LEFT JOIN dt_business_partners bp ON bp.id = ib.business_partner_id
  WHERE od.doc_id NOT IN (SELECT doc_id FROM writeback_done)
),
eligible AS (
  SELECT
    p.doc_id,
    p.posting_date,
    pc.sconto_days
  FROM potential_pc p
  JOIN dt_payment_conditions pc ON pc.id = p.pc_id
  WHERE pc.sconto_days IS NOT NULL
    AND pc.sconto_days > 0
)
SELECT
  e.doc_id,
  TIMESTAMPDIFF(
    DAY,
    NOW(),
    DATE_ADD(e.posting_date, INTERVAL e.sconto_days DAY)
  ) AS days_left_until_discount_deadline
FROM eligible e
WHERE e.posting_date IS NOT NULL
  AND TIMESTAMPDIFF(
    DAY,
    NOW(),
    DATE_ADD(e.posting_date, INTERVAL e.sconto_days DAY)
  ) BETWEEN 0 AND {{ risk_threshold_days }}
ORDER BY days_left_until_discount_deadline ASC;
