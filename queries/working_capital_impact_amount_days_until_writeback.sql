WITH writeback_events AS (
    SELECT ds.doc_id,
           ds.version_start_date AS writeback_at
    FROM document_status ds
    WHERE ds.category = 'FETCHED'
      AND ds.version_end_date IS NULL
),
kpi_base AS (
    SELECT i.total_amount,
           TIMESTAMPDIFF(DAY, d.received_at, w.writeback_at) AS day_diff
    FROM documents d
             JOIN writeback_events w ON w.doc_id = d.doc_id
             JOIN dt_invoices i ON i.external_id = d.external_database_id
)
SELECT SUM(total_amount * day_diff) AS amount_days_timing_shift
FROM kpi_base;
