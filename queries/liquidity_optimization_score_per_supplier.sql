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
po_pc AS (
  SELECT
    pm.doc_id,
    po.payment_condition_id AS po_payment_condition_id
  FROM po_map pm
  JOIN dt_purchase_orders po ON po.external_id = pm.purchase_order_external_id
),
base AS (
  SELECT
    i.business_partner_id,
    COUNT(*) AS n_invoices,
    AVG(CASE WHEN i.payment_date IS NOT NULL AND i.payment_date <= dd.due_date THEN 1 ELSE 0 END) AS on_time_rate,
    AVG(TIMESTAMPDIFF(DAY, dd.due_date, i.payment_date)) AS avg_delay_days,
    AVG(CASE WHEN i.cash_discount_amount IS NOT NULL AND i.cash_discount_amount > 0 THEN 1 ELSE 0 END) AS sconto_util,
    SUM(
      CASE
        WHEN (i.cash_discount_amount IS NULL OR i.cash_discount_amount = 0)
        THEN i.total_amount * pc.sconto_percent
        ELSE 0
      END
    ) AS missed_sconto_chf
  FROM documents d
  JOIN dt_invoices i ON i.external_id = d.external_database_id
  JOIN due_latest dd ON dd.doc_id = d.doc_id
  JOIN dt_business_partners bp ON bp.id = i.business_partner_id
  LEFT JOIN po_pc ppc ON ppc.doc_id = d.doc_id
  JOIN dt_payment_conditions pc
    ON pc.id = COALESCE(ppc.po_payment_condition_id, bp.payment_condition_id)
  WHERE d.received_at BETWEEN {{ from_ts }} AND {{ to_ts }}
    AND i.payment_date IS NOT NULL
    AND pc.sconto_percent IS NOT NULL
  GROUP BY i.business_partner_id
)
SELECT
  bp.name AS supplier_name,
  b.n_invoices,
  ROUND(100 * b.on_time_rate, 2) AS on_time_pct,
  ROUND(b.avg_delay_days, 2) AS avg_delay_days,
  ROUND(100 * b.sconto_util, 2) AS sconto_util_pct,
  ROUND(b.missed_sconto_chf, 2) AS missed_sconto_chf,
  ROUND(
    (b.missed_sconto_chf)
    + (GREATEST(b.avg_delay_days, 0) * 100)
    + ((1 - b.on_time_rate) * 1000),
    2
  ) AS liquidity_optimization_score
FROM base b
JOIN dt_business_partners bp ON bp.id = b.business_partner_id
ORDER BY liquidity_optimization_score DESC;
