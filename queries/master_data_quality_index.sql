WITH total_docs AS (
  SELECT COUNT(*) AS n
  FROM documents d
  WHERE d.received_at BETWEEN {{ from_ts }} AND {{ to_ts }}
),
md_ex_docs AS (
  SELECT COUNT(DISTINCT t.doc_id) AS n
  FROM task_exceptions td
  JOIN tasks t ON t.task_id = td.task_id
  JOIN documents d ON d.doc_id = t.doc_id
  WHERE d.received_at BETWEEN {{ from_ts }} AND {{ to_ts }}
    AND td.todo_type IN (
      'missing_supplier',
      'missing_article',
      'missing_payment_terms',
      'payment_term_mismatch',
      'unit_price_mismatch',
      'price_condition_mismatch'
    )
)
SELECT
  ROUND(100 * (1 - (md_ex_docs.n / NULLIF(total_docs.n, 0))), 2) AS master_data_quality_index
FROM total_docs, md_ex_docs;
