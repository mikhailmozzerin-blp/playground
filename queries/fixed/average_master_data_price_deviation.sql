SELECT AVG(COALESCE(td.deviation_percent, 0)) AS avg_price_deviation_percent,
       AVG(COALESCE(td.deviation_amount, 0))  AS avg_price_deviation_amount
FROM task_exceptions td
         JOIN tasks t ON t.task_id = td.task_id
         JOIN documents d ON d.doc_id = t.doc_id
WHERE td.todo_type IN ('unit_price_mismatch', 'price_condition_mismatch', 'PO_price_deviation')
  AND td.status IN ('OPEN', 'RESOLVED');
