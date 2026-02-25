SELECT d.doc_id,
       COUNT(td.exception_id)                             AS manual_todo_count,
       SUM(
               CASE
                   WHEN td.todo_type = 'TAX_VALIDATION' THEN 10
                   WHEN td.todo_type = 'net_saldo_mismatch' THEN 5
                   ELSE :todo_minutes_constant
                   END
       )                                                  AS weighted_waste_minutes,
       GROUP_CONCAT(DISTINCT td.todo_type SEPARATOR ', ') AS resolved_issues
FROM documents d
         JOIN tasks t ON t.doc_id = d.doc_id
         JOIN task_exceptions td ON td.task_id = t.task_id
         JOIN users u ON u.user_id = td.resolved_by_user_id
WHERE td.status = 'RESOLVED'
  AND u.is_machine = FALSE
GROUP BY d.doc_id, d.org_id
ORDER BY weighted_waste_minutes DESC;