SELECT u.user_id,
       u.name,
       COUNT(*)                                         AS pending_approvals,
       MAX(TIMESTAMPDIFF(MINUTE, t.assigned_at, NOW())) AS max_current_delay_minutes,
       AVG(TIMESTAMPDIFF(MINUTE, t.assigned_at, NOW())) AS avg_current_delay_minutes
FROM tasks t
         JOIN users u ON u.user_id = t.assigned_to_user_id
WHERE t.status = 'OPEN'
  AND t.task_type = 'approval'
  AND t.assigned_at IS NOT NULL
  AND (t.sla_due_at IS NULL OR NOW() > t.sla_due_at)
GROUP BY u.user_id, u.name
ORDER BY max_current_delay_minutes DESC;
