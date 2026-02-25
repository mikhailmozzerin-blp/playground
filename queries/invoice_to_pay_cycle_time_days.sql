SELECT
  AVG(TIMESTAMPDIFF(DAY, d.received_at, i.payment_date)) AS avg_invoice_to_pay_days
FROM documents d
JOIN dt_invoices i ON i.external_id = d.external_database_id
WHERE d.received_at BETWEEN {{ from_ts }} AND {{ to_ts }}
  AND i.payment_date IS NOT NULL;
