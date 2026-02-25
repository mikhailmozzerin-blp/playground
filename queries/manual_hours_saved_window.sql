SELECT
  (SUM(CASE WHEN td.status = 'RESOLVED' THEN 1 ELSE 0 END) * {{ todo_minutes_constant }}) / 60.0 AS manual_hours_saved
FROM task_exceptions td
JOIN tasks t ON t.task_id = td.task_id
JOIN documents d ON d.doc_id = t.doc_id
JOIN users u ON u.user_id = td.resolved_by_user_id
WHERE d.received_at BETWEEN {{ from_ts }} AND {{ to_ts }}
  AND u.is_machine = 0;
