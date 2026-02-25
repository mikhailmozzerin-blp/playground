EXPLAIN SELECT d.doc_id, p.field_key
FROM documents d
         JOIN tasks t ON t.doc_id = d.doc_id
         JOIN v_current_predictions p ON p.doc_id = d.doc_id # added to be able to filter by document fields if needed
WHERE p.field_type = 'SCALAR'
  AND NOT EXISTS (SELECT 1
                  FROM task_edits te
                           JOIN users u ON u.user_id = te.user_id
                  WHERE te.task_id = t.task_id
                    AND u.is_machine = FALSE)
  AND NOT EXISTS (SELECT 1
                  FROM task_actions ta
                           JOIN users u ON u.is_machine = FALSE
                      AND u.user_id IN (ta.user_id, ta.reassign_from_user_id, ta.reassign_to_user_id)
                  WHERE ta.task_id = t.task_id)
  AND NOT EXISTS (SELECT 1
                  FROM task_exceptions tex
                           JOIN users u ON u.user_id = tex.resolved_by_user_id
                  WHERE tex.task_id = t.task_id
                    AND u.is_machine = FALSE);