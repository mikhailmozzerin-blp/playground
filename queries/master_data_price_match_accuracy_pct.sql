WITH evaluated AS (
  SELECT DISTINCT d.doc_id
  FROM documents d
  WHERE d.received_at BETWEEN {{ from_ts }} AND {{ to_ts }}
),
mismatched AS (
  SELECT DISTINCT t.doc_id
  FROM task_exceptions td
  JOIN tasks t ON t.task_id = td.task_id
  WHERE td.todo_type IN ('unit_price_mismatch', 'price_condition_mismatch', 'PO_price_deviation')
)
SELECT
  ROUND(
    100
    * (
      1
      - (SELECT COUNT(*) FROM mismatched)
      / NULLIF((SELECT COUNT(*) FROM evaluated), 0)
    ),
    2
  ) AS master_data_price_match_accuracy_pct;
