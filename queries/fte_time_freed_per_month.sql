WITH this_m AS (
  SELECT
    {{ mtd_start_ts }} AS m_start,
    {{ mtd_end_ts }} AS m_end
),
saved_hours AS (
  SELECT
    (SUM(CASE WHEN td.status = 'RESOLVED' THEN 1 ELSE 0 END) * {{ todo_minutes_constant }}) / 60.0 AS hours_saved
  FROM task_exceptions td
  JOIN tasks t ON t.task_id = td.task_id
  JOIN documents d ON d.doc_id = t.doc_id
  JOIN users u ON u.user_id = td.resolved_by_user_id
  JOIN this_m m
    ON d.received_at >= m.m_start
   AND d.received_at < m.m_end
  WHERE u.is_machine = 0
)
SELECT
  (hours_saved / {{ hours_per_fte_month }}) AS fte_time_freed_per_month
FROM saved_hours;
