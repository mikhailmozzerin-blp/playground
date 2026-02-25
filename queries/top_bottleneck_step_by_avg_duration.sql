SELECT
  t.task_type,
  AVG(TIMESTAMPDIFF(SECOND, t.start_date, t.end_date)) AS avg_task_duration_seconds
FROM tasks t
JOIN documents d ON d.doc_id = t.doc_id
WHERE d.received_at BETWEEN {{ from_ts }} AND {{ to_ts }}
  AND t.end_date IS NOT NULL
GROUP BY t.task_type
ORDER BY avg_task_duration_seconds DESC
LIMIT 1;
