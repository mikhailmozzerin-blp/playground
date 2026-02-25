SELECT
  COUNT(*) AS declined_approvals
FROM task_actions a
JOIN tasks t ON t.task_id = a.task_id
JOIN documents d ON d.doc_id = t.doc_id
WHERE d.received_at BETWEEN {{ from_ts }} AND {{ to_ts }}
  AND t.task_type = 'approval'
  AND a.action = 'decline';
