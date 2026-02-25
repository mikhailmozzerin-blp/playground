SELECT
  ROUND(
    100
    * SUM(CASE WHEN u.is_machine = 1 THEN 1 ELSE 0 END)
    / NULLIF(COUNT(*), 0),
    2
  ) AS automated_approvals_pct
FROM task_actions a
JOIN tasks t ON t.task_id = a.task_id
JOIN users u ON u.user_id = a.user_id
JOIN documents d ON d.doc_id = t.doc_id
WHERE d.received_at BETWEEN {{ from_ts }} AND {{ to_ts }}
  AND t.task_type = 'approval'
  AND a.action IN ('approve', 'auto_approve', 'manual_approve');
