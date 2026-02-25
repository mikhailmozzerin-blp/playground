WITH writeback AS (
  SELECT t.doc_id, MIN(a.datetime) AS writeback_at
  FROM task_actions a
  JOIN tasks t ON t.task_id = a.task_id
  WHERE a.action = 'CATEGORY_CHANGE'
    AND JSON_UNQUOTE(JSON_EXTRACT(a.action_metadata_json, '$.category_to')) = 'FETCHED'
  GROUP BY t.doc_id
),
inv_delivery_notes AS (
  SELECT
    t.doc_id,
    MIN(dn.created_at) AS goods_receipt_date
  FROM prediction_fields pf
  JOIN tasks t ON t.task_id = pf.task_id
  JOIN dt_delivery_notes dn
    ON BIN_TO_UUID(dn.id) = pf.value_string
  WHERE pf.field_key = 'delivery_note_id'
    AND pf.version_end_date IS NULL
  GROUP BY t.doc_id
)
SELECT
  AVG(TIMESTAMPDIFF(DAY, idn.goods_receipt_date, w.writeback_at)) AS avg_goods_receipt_to_writeback_days
FROM documents d
JOIN writeback w ON w.doc_id = d.doc_id
JOIN inv_delivery_notes idn ON idn.doc_id = d.doc_id
WHERE d.received_at BETWEEN {{ from_ts }} AND {{ to_ts }}
  AND idn.goods_receipt_date IS NOT NULL;
