SELECT
  (COUNT(DISTINCT t.doc_id) / {{ fte_count }}) AS invoices_per_fte
FROM tasks t
JOIN documents d ON d.doc_id = t.doc_id
WHERE d.received_at BETWEEN {{ from_ts }} AND {{ to_ts }}
  AND t.business_process_type = {{ business_process_type }}
  AND t.status = 'DONE';
