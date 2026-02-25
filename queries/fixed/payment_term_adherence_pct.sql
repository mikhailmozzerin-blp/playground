SELECT ROUND(
               100 * (1 - COUNT(DISTINCT td.task_id) / NULLIF(COUNT(DISTINCT d.doc_id), 0)),
               2
       ) AS payment_term_adherence_pct
FROM documents d
         LEFT JOIN tasks t
                   ON t.doc_id = d.doc_id
         LEFT JOIN task_exceptions td
                   ON td.task_id = t.task_id
                       AND td.todo_type IN (
                                            'payment_term_mismatch',
                                            'due_date_inconsistent',
                                            'discount_window_missing',
                                            'supplier_payment_terms_missing'
                           );