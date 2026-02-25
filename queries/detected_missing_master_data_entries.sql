SELECT
  td.todo_type,
  COUNT(*) AS occurrences,
  COUNT(DISTINCT t.doc_id) AS affected_documents
FROM task_exceptions td
JOIN tasks t ON t.task_id = td.task_id
JOIN documents d ON d.doc_id = t.doc_id
WHERE d.received_at BETWEEN {{ from_ts }} AND {{ to_ts }}
  AND td.todo_type IN (
    'missing_supplier',
    'missing_article',
    'missing_payment_terms',
    'missing_po',
    'missing_cost_center'
  )
GROUP BY td.todo_type
ORDER BY occurrences DESC;
