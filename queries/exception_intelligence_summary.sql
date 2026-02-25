SELECT
  td.todo_type AS exception_type,
  ROUND(100 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS pct_of_total,
  AVG(TIMESTAMPDIFF(MINUTE, td.created_at, td.resolved_at)) AS avg_resolution_minutes,
  COALESCE(td.risk_level, 'MEDIUM') AS risk
FROM task_exceptions td
JOIN tasks t ON t.task_id = td.task_id
JOIN documents d ON d.doc_id = t.doc_id
WHERE d.received_at BETWEEN {{ from_ts }} AND {{ to_ts }}
  AND td.status = 'RESOLVED'
GROUP BY td.todo_type, COALESCE(td.risk_level, 'MEDIUM')
ORDER BY COUNT(*) DESC;
