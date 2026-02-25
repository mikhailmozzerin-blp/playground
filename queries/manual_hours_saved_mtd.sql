WITH this_m AS (
  SELECT
    {{ mtd_start_ts }} AS m_start,
    {{ mtd_end_ts }} AS m_end
)
SELECT
  (SUM(CASE WHEN td.status = 'RESOLVED' THEN 1 ELSE 0 END) * {{ todo_minutes_constant }}) / 60.0 AS manual_hours_saved_mtd
FROM task_exceptions td
JOIN tasks t ON t.task_id = td.task_id
JOIN documents d ON d.doc_id = t.doc_id
JOIN users u ON u.user_id = td.resolved_by_user_id
JOIN this_m m
  ON d.received_at >= m.m_start
 AND d.received_at < m.m_end
WHERE u.is_machine = 0;
