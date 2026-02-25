WITH writeback AS (
  SELECT t.doc_id, MIN(a.datetime) AS writeback_at
  FROM task_actions a
  JOIN tasks t ON t.task_id = a.task_id
  WHERE a.action = 'CATEGORY_CHANGE'
    AND JSON_UNQUOTE(JSON_EXTRACT(a.action_metadata_json, '$.category_to')) = 'FETCHED'
  GROUP BY t.doc_id
)
SELECT
  AVG(TIMESTAMPDIFF(DAY, d.received_at, w.writeback_at)) AS avg_invoice_to_writeback_days
FROM documents d
JOIN writeback w ON w.doc_id = d.doc_id
WHERE d.received_at BETWEEN {{ from_ts }} AND {{ to_ts }};
