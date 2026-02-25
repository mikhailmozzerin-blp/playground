WITH po_data AS (
    -- Get PO IDs from prediction fields efficiently
    -- Filtering by key first is faster than a wide GROUP BY
    SELECT df.doc_id,
           df.value_string AS po_external_id
    FROM document_fields df
    WHERE df.field_key IN ('purchase_order_id')
),
     combined_pc AS (
         -- Population: all invoices processed by BLP
         -- We bring in org_id for the final breakdown
         SELECT d.doc_id,
                d.org_id,
                di.cash_discount_amount,
                -- Priority logic: 1. PO header, 2. Supplier Master Data (Business Partner)
                COALESCE(po.payment_condition_id, bp.payment_condition_id) AS target_pc_id
         FROM documents d
                  JOIN dt_invoices di ON di.external_id = d.external_database_id
                  LEFT JOIN po_data pd ON pd.doc_id = d.doc_id
                  LEFT JOIN dt_purchase_orders po ON po.external_id = pd.po_external_id
                  LEFT JOIN dt_business_partners bp ON bp.id = di.business_partner_id)
SELECT cpc.org_id,
       -- KPI: (# invoices with sconto) / (# invoices where sconto was available)
       ROUND(
               100.0 * COUNT(CASE WHEN cpc.cash_discount_amount > 0 THEN 1 END)
                   / NULLIF(COUNT(*), 0),
               2
       ) AS sconto_utilization_pct
FROM combined_pc cpc
-- Inner Join ensures we only look at "Potential Sconto Available" population
         JOIN dt_payment_conditions pc ON pc.id = cpc.target_pc_id
WHERE pc.sconto_percent > 0
  AND pc.sconto_days > 0
GROUP BY cpc.org_id;