WITH ordered_tasks AS (
  SELECT
    t.doc_id,
    t.task_id,
    t.start_date,
    t.end_date,
    ROW_NUMBER() OVER (PARTITION BY t.doc_id ORDER BY t.start_date) AS rn
  FROM tasks t
),
gaps AS (
  SELECT
    a.doc_id,
    TIMESTAMPDIFF(SECOND, a.end_date, b.start_date) AS idle_seconds
  FROM ordered_tasks a
  JOIN ordered_tasks b
    ON b.doc_id = a.doc_id
   AND b.rn = a.rn + 1
  WHERE a.end_date IS NOT NULL
    AND b.start_date IS NOT NULL
)
SELECT
  SUM(idle_seconds) AS workflow_bottleneck_idle_seconds
FROM gaps;
