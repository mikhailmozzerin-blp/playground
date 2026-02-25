SELECT
  AVG(TIMESTAMPDIFF(MINUTE, t.assigned_at, t.end_date)) AS avg_manual_approval_cycle_minutes
FROM tasks t
JOIN task_actions a ON a.task_id = t.task_id
JOIN users u ON u.user_id = a.user_id
JOIN documents d ON d.doc_id = t.doc_id
WHERE d.received_at BETWEEN {{ from_ts }} AND {{ to_ts }}
  AND t.task_type = 'approval'
  AND t.end_date IS NOT NULL
  AND t.assigned_at IS NOT NULL
  AND u.is_machine = 0
  AND a.action IN ('approve', 'manual_approve');
