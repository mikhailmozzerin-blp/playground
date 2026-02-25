WITH po_data AS (
    -- Extracts PO external ID from prediction fields
    SELECT
        df.doc_id,
        df.value_string AS po_external_id
    FROM document_fields df
    WHERE df.field_key IN ('purchase_order_id')
),
     combined_pc AS (
         -- Population: all invoices processed (Digital Twin Invoice + Documents)
         SELECT
             d.doc_id,
             d.org_id,
             di.cash_discount_amount,
             di.total_amount,
             -- Potential Sconto Source logic: PO header first, then supplier master data
             COALESCE(po.payment_condition_id, bp.payment_condition_id) AS target_pc_id
         FROM documents d
                  JOIN dt_invoices di ON di.external_id = d.external_database_id
                  LEFT JOIN po_data pd ON pd.doc_id = d.doc_id
                  LEFT JOIN dt_purchase_orders po ON po.external_id = pd.po_external_id
                  LEFT JOIN dt_business_partners bp ON bp.id = di.business_partner_id
     )
SELECT
    cpc.org_id,
    -- KPI: (sum amounts where sconto applied) / (sum amounts where sconto available)
    ROUND(
            100.0 * SUM(IF(cpc.cash_discount_amount > 0, cpc.total_amount, 0))
                / NULLIF(SUM(cpc.total_amount), 0),
            2
    ) AS sconto_utilization_pct
FROM combined_pc cpc
         JOIN dt_payment_conditions pc ON pc.id = cpc.target_pc_id
-- Defines "Potential Sconto Available": only terms with actual discount % and days
# WHERE pc.sconto_percent > 0
#   AND pc.sconto_days > 0
GROUP BY cpc.org_id;


# doc.orgID: 661fce72-536e-5719-a014-9ee4dc117508
#   - dt_invoices.id: ERP-INV-1001,ERP-INV-1004
#       - 0
# doc.orgID: 772fce83-647f-5820-b125-1b7e7916c619
#   - dt_invoices.id: ERP-INV-2003(135.60),ERP-INV-2001
#       - 74.66