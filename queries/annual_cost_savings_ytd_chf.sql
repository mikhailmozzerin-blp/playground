WITH saved_hours
    AS (SELECT (SUM(CASE WHEN td.status = 'RESOLVED' THEN 1 ELSE 0 END) * {{ todo_minutes_constant }}) /
               60.0 AS hours_saved
        FROM task_exceptions td
                 JOIN tasks t ON t.task_id = td.task_id
                 JOIN documents d ON d.doc_id = t.doc_id
                 JOIN users u ON u.user_id = td.resolved_by_user_id
        WHERE d.received_at >=
   {{ ytd_start_ts }}
    AND d.received_at
   < {{ ytd_end_ts }}
    AND u.is_machine = 0
    )
SELECT (hours_saved * {{ cost_per_hour }}) AS annual_cost_savings_chf
FROM saved_hours;
