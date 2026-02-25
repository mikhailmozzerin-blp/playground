SELECT d.org_id,
       COUNT(t.doc_id)                AS total_docs,
       SUM(IF(r.is_rework = 1, 1, 0)) AS rework_docs,
       ROUND(
               100.0 * SUM(IF(r.is_rework = 1, 1, 0))
                   / NULLIF(COUNT(t.doc_id), 0),
               2
       )                              AS rework_escalation_ratio_pct
FROM documents d
         JOIN tasks t ON t.doc_id = d.doc_id
         LEFT JOIN (SELECT task_id, 1 AS is_rework
                    FROM task_actions
                    WHERE action IN (:actions) #decline, ask_for_changes
                    GROUP BY task_id) r ON r.task_id = t.task_id
GROUP BY d.org_id;