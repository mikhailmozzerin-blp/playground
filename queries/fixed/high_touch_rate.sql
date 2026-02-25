SELECT DISTINCT d.doc_id,
                touches.total_count
FROM documents d
         JOIN tasks t ON t.doc_id = d.doc_id
         JOIN LATERAL (
    SELECT (
               (SELECT COUNT(*)
                FROM task_edits te
                         JOIN users u ON u.user_id = te.user_id
                WHERE te.task_id = t.task_id
                  AND u.is_machine = FALSE)
                   +
               (SELECT COUNT(*)
                FROM task_actions ta
                         JOIN users u ON u.is_machine = FALSE
                    AND u.user_id IN (ta.user_id, ta.reassign_from_user_id, ta.reassign_to_user_id)
                WHERE ta.task_id = t.task_id)
                   +
               (SELECT COUNT(*)
                FROM task_exceptions tex
                         JOIN users u ON u.user_id = tex.resolved_by_user_id
                WHERE tex.task_id = t.task_id
                  AND u.is_machine = FALSE)
               ) AS total_count
    ) AS touches ON TRUE
WHERE
  touches.total_count > :user_touch_threshold;