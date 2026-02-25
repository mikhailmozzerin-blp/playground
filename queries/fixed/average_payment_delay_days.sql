SELECT
    AVG(TIMESTAMPDIFF(DAY, pf.value_date, i.payment_date)) AS avg_payment_delay_days
FROM dt_invoices i
         JOIN documents d
              ON i.external_id = d.external_database_id
         JOIN document_fields pf
              ON pf.doc_id = d.doc_id
WHERE i.payment_date IS NOT NULL
  AND pf.field_key IN ('due_date', 'DueDate')
  AND pf.value_date IS NOT NULL;