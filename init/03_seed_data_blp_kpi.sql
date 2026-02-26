-- ============================================================
-- BLP Analytics KPI Model – DML (seed data)
-- Data extracted from:
--   predicton_sven.json     → invoice prediction (header + positions)
--   prediction_jsonata.json → dashboard config stored as prediction tree
--   prediction_xslt.json   → dashboard config stored as prediction tree
-- ============================================================

-- -----------------------------------------------
-- 1. Users
-- -----------------------------------------------
INSERT INTO users (user_id, name, is_machine)
VALUES (UUID_TO_BIN('a0000001-0000-0000-0000-000000000001'), 'System Automation', TRUE),
       (UUID_TO_BIN('a0000001-0000-0000-0000-000000000002'), 'Custom AI Wizard', TRUE),
       (UUID_TO_BIN('b0000001-0000-0000-0000-000000000001'), 'Max Mustermann', FALSE),
       (UUID_TO_BIN('b0000001-0000-0000-0000-000000000002'), 'Anna Schmidt', FALSE),
       (UUID_TO_BIN('b0000001-0000-0000-0000-000000000003'), 'Sven Bergmann', FALSE),
       (UUID_TO_BIN('b0000001-0000-0000-0000-000000000004'), 'Thomas Weber', FALSE),
       (UUID_TO_BIN('b0000001-0000-0000-0000-000000000005'), 'Lisa Müller', FALSE);


-- -----------------------------------------------
-- 2. Documents
-- -----------------------------------------------
-- org 1: 661fce72-536e-5719-a014-9ee4dc117508 (Süddeutsche Bauteile AG)
-- org 2: 772fce83-647f-5820-b125-1b7e7916c619 (Acme Logistics GmbH)
INSERT INTO documents (doc_id, org_id, name, document_type, external_database_id, received_at)
VALUES
    -- org 1
    (UUID_TO_BIN('18034fa5-d668-4383-99a6-c92ed1350c38'),
     UUID_TO_BIN('661fce72-536e-5719-a014-9ee4dc117508'),
     '16272572-c53a-4689-b57a-086c8240b0ae_106_20250813_00002623192.PDF',
     'INVOICE', NULL, '2025-08-15 09:13:56'),
    (UUID_TO_BIN('20000000-aaaa-4000-8000-000000000001'),
     UUID_TO_BIN('661fce72-536e-5719-a014-9ee4dc117508'),
     'jsonata_test_invoice.pdf',
     'INVOICE', NULL, '2025-08-10 14:00:00'),
    (UUID_TO_BIN('20000000-bbbb-4000-8000-000000000002'),
     UUID_TO_BIN('661fce72-536e-5719-a014-9ee4dc117508'),
     'xslt_test_invoice.pdf',
     'INVOICE', NULL, '2025-08-11 10:30:00'),
    (UUID_TO_BIN('30000000-0001-4000-8000-000000000001'),
     UUID_TO_BIN('661fce72-536e-5719-a014-9ee4dc117508'),
     'INV-2025-08-001_clean.pdf',
     'INVOICE', NULL, '2025-08-16 08:00:00'),
    (UUID_TO_BIN('30000000-0001-4000-8000-000000000002'),
     UUID_TO_BIN('661fce72-536e-5719-a014-9ee4dc117508'),
     'INV-2025-08-002_declined.pdf',
     'INVOICE', NULL, '2025-08-17 10:00:00'),
    -- org 2
    (UUID_TO_BIN('30000000-0002-4000-8000-000000000001'),
     UUID_TO_BIN('772fce83-647f-5820-b125-1b7e7916c619'),
     'RE-2025-0871_zero_touch.pdf',
     'INVOICE', NULL, '2025-08-18 07:30:00'),
    (UUID_TO_BIN('30000000-0002-4000-8000-000000000002'),
     UUID_TO_BIN('772fce83-647f-5820-b125-1b7e7916c619'),
     'RE-2025-0872_correction.pdf',
     'INVOICE', NULL, '2025-08-18 08:15:00'),
    (UUID_TO_BIN('30000000-0002-4000-8000-000000000003'),
     UUID_TO_BIN('772fce83-647f-5820-b125-1b7e7916c619'),
     'RE-2025-0873_approved.pdf',
     'INVOICE', NULL, '2025-08-19 09:00:00'),
    (UUID_TO_BIN('30000000-0002-4000-8000-000000000004'),
     UUID_TO_BIN('772fce83-647f-5820-b125-1b7e7916c619'),
     'RE-2025-0874_declined.pdf',
     'INVOICE', NULL, '2025-08-19 11:00:00');


-- -----------------------------------------------
-- 3. Workflow instances
-- -----------------------------------------------
INSERT INTO workflow_instances (workflow_instance_id, name)
VALUES (UUID_TO_BIN('c0000001-0000-4000-8000-000000000001'), 'Invoice Processing v2'),
       (UUID_TO_BIN('c0000001-0000-4000-8000-000000000002'), 'Invoice Processing – JSONata Test'),
       (UUID_TO_BIN('c0000001-0000-4000-8000-000000000003'), 'Invoice Processing – XSLT Test'),
       (UUID_TO_BIN('c0000001-0000-4000-8000-000000000004'), 'Invoice Processing – Org1 Batch'),
       (UUID_TO_BIN('c0000001-0000-4000-8000-000000000005'), 'Invoice Processing – Acme');


-- -----------------------------------------------
-- 4. Tasks
-- -----------------------------------------------
INSERT INTO tasks (task_id, workflow_instance_id, doc_id, task_type, business_process_type, status, start_date,
                   end_date, assigned_to_user_id)
VALUES
    -- org 1 tasks
    (UUID_TO_BIN('d0000001-0000-4000-8000-000000000001'),
     UUID_TO_BIN('c0000001-0000-4000-8000-000000000001'),
     UUID_TO_BIN('18034fa5-d668-4383-99a6-c92ed1350c38'),
     'matching', 'AP_INVOICE', 'DONE',
     '2025-08-15 09:14:00', '2025-08-15 09:45:00',
     UUID_TO_BIN('b0000001-0000-0000-0000-000000000003')),
    (UUID_TO_BIN('d0000001-0000-4000-8000-000000000002'),
     UUID_TO_BIN('c0000001-0000-4000-8000-000000000002'),
     UUID_TO_BIN('20000000-aaaa-4000-8000-000000000001'),
     'matching', 'AP_INVOICE', 'OPEN',
     '2025-08-10 14:05:00', NULL,
     UUID_TO_BIN('b0000001-0000-0000-0000-000000000001')),
    (UUID_TO_BIN('d0000001-0000-4000-8000-000000000003'),
     UUID_TO_BIN('c0000001-0000-4000-8000-000000000003'),
     UUID_TO_BIN('20000000-bbbb-4000-8000-000000000002'),
     'matching', 'AP_INVOICE', 'OPEN',
     '2025-08-11 10:35:00', NULL,
     UUID_TO_BIN('b0000001-0000-0000-0000-000000000002')),
    (UUID_TO_BIN('d0000001-0000-4000-8000-000000000004'),
     UUID_TO_BIN('c0000001-0000-4000-8000-000000000004'),
     UUID_TO_BIN('30000000-0001-4000-8000-000000000001'),
     'approval', 'AP_INVOICE', 'DONE',
     '2025-08-16 08:05:00', '2025-08-16 08:20:00',
     UUID_TO_BIN('b0000001-0000-0000-0000-000000000003')),
    (UUID_TO_BIN('d0000001-0000-4000-8000-000000000005'),
     UUID_TO_BIN('c0000001-0000-4000-8000-000000000004'),
     UUID_TO_BIN('30000000-0001-4000-8000-000000000002'),
     'matching', 'AP_INVOICE', 'OPEN',
     '2025-08-17 10:05:00', NULL,
     UUID_TO_BIN('b0000001-0000-0000-0000-000000000001')),
    -- org 2 tasks
    (UUID_TO_BIN('d0000002-0000-4000-8000-000000000001'),
     UUID_TO_BIN('c0000001-0000-4000-8000-000000000005'),
     UUID_TO_BIN('30000000-0002-4000-8000-000000000001'),
     'matching', 'AP_INVOICE', 'DONE',
     '2025-08-18 07:35:00', '2025-08-18 07:36:00',
     NULL),
    (UUID_TO_BIN('d0000002-0000-4000-8000-000000000002'),
     UUID_TO_BIN('c0000001-0000-4000-8000-000000000005'),
     UUID_TO_BIN('30000000-0002-4000-8000-000000000002'),
     'sachliche_pruefung', 'AP_INVOICE', 'OPEN',
     '2025-08-18 08:20:00', NULL,
     UUID_TO_BIN('b0000001-0000-0000-0000-000000000004')),
    (UUID_TO_BIN('d0000002-0000-4000-8000-000000000003'),
     UUID_TO_BIN('c0000001-0000-4000-8000-000000000005'),
     UUID_TO_BIN('30000000-0002-4000-8000-000000000003'),
     'approval', 'AP_INVOICE', 'DONE',
     '2025-08-19 09:05:00', '2025-08-19 09:25:00',
     UUID_TO_BIN('b0000001-0000-0000-0000-000000000005')),
    (UUID_TO_BIN('d0000002-0000-4000-8000-000000000004'),
     UUID_TO_BIN('c0000001-0000-4000-8000-000000000005'),
     UUID_TO_BIN('30000000-0002-4000-8000-000000000004'),
     'matching', 'AP_INVOICE', 'OPEN',
     '2025-08-19 11:05:00', NULL,
     UUID_TO_BIN('b0000001-0000-0000-0000-000000000005'));


-- -----------------------------------------------
-- 5. Task actions
-- -----------------------------------------------
INSERT INTO task_actions (action_id, task_id, user_id, action, datetime)
VALUES (UUID_TO_BIN('e0000001-0000-4000-8000-000000000001'),
        UUID_TO_BIN('d0000001-0000-4000-8000-000000000001'),
        UUID_TO_BIN('a0000001-0000-0000-0000-000000000001'),
        'start', '2025-08-15 09:14:00'),
       (UUID_TO_BIN('e0000001-0000-4000-8000-000000000003'),
        UUID_TO_BIN('d0000001-0000-4000-8000-000000000001'),
        UUID_TO_BIN('b0000001-0000-0000-0000-000000000003'),
        'approve', '2025-08-15 09:45:00');

INSERT INTO task_actions (action_id, task_id, user_id, action, datetime, action_metadata_json)
VALUES (UUID_TO_BIN('e0000001-0000-4000-8000-000000000002'),
        UUID_TO_BIN('d0000001-0000-4000-8000-000000000001'),
        UUID_TO_BIN('a0000001-0000-0000-0000-000000000001'),
        'CATEGORY_CHANGE', '2025-08-15 09:14:01',
        JSON_OBJECT('category_from', 'IMPORTED', 'category_to', 'NOT_CHECKED', 'category_reason', 'SYSTEM_ROUTING')),
       (UUID_TO_BIN('e0000001-0000-4000-8000-000000000004'),
        UUID_TO_BIN('d0000001-0000-4000-8000-000000000001'),
        UUID_TO_BIN('a0000001-0000-0000-0000-000000000001'),
        'CATEGORY_CHANGE', '2025-08-15 09:45:01',
        JSON_OBJECT('category_from', 'NOT_CHECKED', 'category_to', 'FETCHED', 'category_reason', 'WRITEBACK_SUCCESS'));

-- task 2 (jsonata) – reviewer starts, then declines with reason
INSERT INTO task_actions (action_id, task_id, user_id, action, datetime)
VALUES (UUID_TO_BIN('e0000002-0000-4000-8000-000000000001'),
        UUID_TO_BIN('d0000001-0000-4000-8000-000000000002'),
        UUID_TO_BIN('a0000001-0000-0000-0000-000000000001'),
        'start', '2025-08-10 14:05:00');

INSERT INTO task_actions (action_id, task_id, user_id, action, datetime, action_metadata_json)
VALUES (UUID_TO_BIN('e0000002-0000-4000-8000-000000000002'),
        UUID_TO_BIN('d0000001-0000-4000-8000-000000000002'),
        UUID_TO_BIN('a0000001-0000-0000-0000-000000000001'),
        'CATEGORY_CHANGE', '2025-08-10 14:05:01',
        JSON_OBJECT('category_from', 'IMPORTED', 'category_to', 'NOT_CHECKED', 'category_reason', 'SYSTEM_ROUTING')),
       (UUID_TO_BIN('e0000002-0000-4000-8000-000000000003'),
        UUID_TO_BIN('d0000001-0000-4000-8000-000000000002'),
        UUID_TO_BIN('b0000001-0000-0000-0000-000000000001'),
        'decline', '2025-08-10 15:20:00',
        JSON_OBJECT('decline_reason', 'PO number missing', 'decline_scope', 'HEADER'));

-- task 2 – after decline, reassign to another user for review
INSERT INTO task_actions (action_id, task_id, user_id, action, datetime, reassign_from_user_id, reassign_to_user_id,
                          reassign_comment)
VALUES (UUID_TO_BIN('e0000002-0000-4000-8000-000000000004'),
        UUID_TO_BIN('d0000001-0000-4000-8000-000000000002'),
        UUID_TO_BIN('b0000001-0000-0000-0000-000000000001'),
        'REASSIGN_USER', '2025-08-10 15:21:00',
        UUID_TO_BIN('b0000001-0000-0000-0000-000000000001'),
        UUID_TO_BIN('b0000001-0000-0000-0000-000000000002'),
        'Declined – needs PO, reassigning to Anna');

-- task 3 (xslt) – reviewer starts, asks for correction, gets corrected data, then approves
INSERT INTO task_actions (action_id, task_id, user_id, action, datetime)
VALUES (UUID_TO_BIN('e0000003-0000-4000-8000-000000000001'),
        UUID_TO_BIN('d0000001-0000-4000-8000-000000000003'),
        UUID_TO_BIN('a0000001-0000-0000-0000-000000000001'),
        'start', '2025-08-11 10:35:00');

INSERT INTO task_actions (action_id, task_id, user_id, action, datetime, action_metadata_json)
VALUES (UUID_TO_BIN('e0000003-0000-4000-8000-000000000002'),
        UUID_TO_BIN('d0000001-0000-4000-8000-000000000003'),
        UUID_TO_BIN('a0000001-0000-0000-0000-000000000001'),
        'CATEGORY_CHANGE', '2025-08-11 10:35:01',
        JSON_OBJECT('category_from', 'IMPORTED', 'category_to', 'NOT_CHECKED', 'category_reason', 'SYSTEM_ROUTING')),
       (UUID_TO_BIN('e0000003-0000-4000-8000-000000000003'),
        UUID_TO_BIN('d0000001-0000-4000-8000-000000000003'),
        UUID_TO_BIN('b0000001-0000-0000-0000-000000000002'),
        'ask_for_correction', '2025-08-11 11:00:00',
        JSON_OBJECT('correction_field', 'BusinessPartnerName', 'correction_reason',
                    'Supplier name does not match ERP master data', 'correction_expected', 'Niederlassung Stuttgart')),
       (UUID_TO_BIN('e0000003-0000-4000-8000-000000000004'),
        UUID_TO_BIN('d0000001-0000-4000-8000-000000000003'),
        UUID_TO_BIN('b0000001-0000-0000-0000-000000000003'),
        'CATEGORY_CHANGE', '2025-08-11 14:10:00',
        JSON_OBJECT('category_from', 'NOT_CHECKED', 'category_to', 'CORRECTED', 'category_reason', 'USER_CORRECTION'));

INSERT INTO task_actions (action_id, task_id, user_id, action, datetime)
VALUES (UUID_TO_BIN('e0000003-0000-4000-8000-000000000005'),
        UUID_TO_BIN('d0000001-0000-4000-8000-000000000003'),
        UUID_TO_BIN('b0000001-0000-0000-0000-000000000002'),
        'approve', '2025-08-11 14:15:00');

-- task 4 (org 1, clean approve)
INSERT INTO task_actions (action_id, task_id, user_id, action, datetime)
VALUES (UUID_TO_BIN('e0000004-0000-4000-8000-000000000001'),
        UUID_TO_BIN('d0000001-0000-4000-8000-000000000004'),
        UUID_TO_BIN('a0000001-0000-0000-0000-000000000001'),
        'start', '2025-08-16 08:05:00'),
       (UUID_TO_BIN('e0000004-0000-4000-8000-000000000002'),
        UUID_TO_BIN('d0000001-0000-4000-8000-000000000004'),
        UUID_TO_BIN('b0000001-0000-0000-0000-000000000003'),
        'approve', '2025-08-16 08:20:00');

-- task 5 (org 1, decline – wrong amount)
INSERT INTO task_actions (action_id, task_id, user_id, action, datetime)
VALUES (UUID_TO_BIN('e0000005-0000-4000-8000-000000000001'),
        UUID_TO_BIN('d0000001-0000-4000-8000-000000000005'),
        UUID_TO_BIN('a0000001-0000-0000-0000-000000000001'),
        'start', '2025-08-17 10:05:00');

INSERT INTO task_actions (action_id, task_id, user_id, action, datetime, action_metadata_json)
VALUES (UUID_TO_BIN('e0000005-0000-4000-8000-000000000002'),
        UUID_TO_BIN('d0000001-0000-4000-8000-000000000005'),
        UUID_TO_BIN('b0000001-0000-0000-0000-000000000001'),
        'decline', '2025-08-17 11:30:00',
        JSON_OBJECT('decline_reason', 'Invoice total does not match PO amount', 'decline_scope', 'HEADER',
                    'deviation_amount', -450.00));

-- task 6 (org 2, zero-touch – machine only, auto-approve)
INSERT INTO task_actions (action_id, task_id, user_id, action, datetime)
VALUES (UUID_TO_BIN('e0000006-0000-4000-8000-000000000001'),
        UUID_TO_BIN('d0000002-0000-4000-8000-000000000001'),
        UUID_TO_BIN('a0000001-0000-0000-0000-000000000001'),
        'start', '2025-08-18 07:35:00'),
       (UUID_TO_BIN('e0000006-0000-4000-8000-000000000002'),
        UUID_TO_BIN('d0000002-0000-4000-8000-000000000001'),
        UUID_TO_BIN('a0000001-0000-0000-0000-000000000001'),
        'complete', '2025-08-18 07:36:00');

INSERT INTO task_actions (action_id, task_id, user_id, action, datetime, action_metadata_json)
VALUES (UUID_TO_BIN('e0000006-0000-4000-8000-000000000003'),
        UUID_TO_BIN('d0000002-0000-4000-8000-000000000001'),
        UUID_TO_BIN('a0000001-0000-0000-0000-000000000001'),
        'CATEGORY_CHANGE', '2025-08-18 07:36:01',
        JSON_OBJECT('category_from', 'IMPORTED', 'category_to', 'FETCHED', 'category_reason', 'AUTO_MATCH_SUCCESS'));

-- task 7 (org 2, ask_for_correction – VAT mismatch)
INSERT INTO task_actions (action_id, task_id, user_id, action, datetime)
VALUES (UUID_TO_BIN('e0000007-0000-4000-8000-000000000001'),
        UUID_TO_BIN('d0000002-0000-4000-8000-000000000002'),
        UUID_TO_BIN('a0000001-0000-0000-0000-000000000001'),
        'start', '2025-08-18 08:20:00');

INSERT INTO task_actions (action_id, task_id, user_id, action, datetime, action_metadata_json)
VALUES (UUID_TO_BIN('e0000007-0000-4000-8000-000000000002'),
        UUID_TO_BIN('d0000002-0000-4000-8000-000000000002'),
        UUID_TO_BIN('b0000001-0000-0000-0000-000000000004'),
        'ask_for_correction', '2025-08-18 09:45:00',
        JSON_OBJECT('correction_field', 'VATAmount', 'correction_reason',
                    'VAT rate 19% applied but supplier is in CH (exempt)', 'correction_expected', '0.00'));

-- task 8 (org 2, clean approve)
INSERT INTO task_actions (action_id, task_id, user_id, action, datetime)
VALUES (UUID_TO_BIN('e0000008-0000-4000-8000-000000000001'),
        UUID_TO_BIN('d0000002-0000-4000-8000-000000000003'),
        UUID_TO_BIN('a0000001-0000-0000-0000-000000000001'),
        'start', '2025-08-19 09:05:00'),
       (UUID_TO_BIN('e0000008-0000-4000-8000-000000000002'),
        UUID_TO_BIN('d0000002-0000-4000-8000-000000000003'),
        UUID_TO_BIN('b0000001-0000-0000-0000-000000000005'),
        'approve', '2025-08-19 09:25:00');

-- task 9 (org 2, decline – duplicate invoice)
INSERT INTO task_actions (action_id, task_id, user_id, action, datetime)
VALUES (UUID_TO_BIN('e0000009-0000-4000-8000-000000000001'),
        UUID_TO_BIN('d0000002-0000-4000-8000-000000000004'),
        UUID_TO_BIN('a0000001-0000-0000-0000-000000000001'),
        'start', '2025-08-19 11:05:00');

INSERT INTO task_actions (action_id, task_id, user_id, action, datetime, action_metadata_json)
VALUES (UUID_TO_BIN('e0000009-0000-4000-8000-000000000002'),
        UUID_TO_BIN('d0000002-0000-4000-8000-000000000004'),
        UUID_TO_BIN('b0000001-0000-0000-0000-000000000005'),
        'decline', '2025-08-19 12:00:00',
        JSON_OBJECT('decline_reason', 'Duplicate invoice – already posted as RE-2025-0873', 'decline_scope', 'HEADER'));


-- -----------------------------------------------
-- 5b. Document metadata history staging
-- -----------------------------------------------
CREATE TEMPORARY TABLE `document_metadata_staging`
(
    `document_metadata_id` BINARY(16)  NOT NULL,
    `doc_id`               BINARY(16)  NOT NULL,
    `category`             VARCHAR(64) NOT NULL,
    `version_start_date`   DATETIME    NOT NULL,
    `version_end_date`     DATETIME,
    `modified_by`          VARCHAR(255),
    `created_by`           VARCHAR(255),
    `updated_by`           VARCHAR(255),
    `created_at`           DATETIME    NOT NULL,
    `updated_at`           DATETIME    NOT NULL
);

INSERT INTO document_metadata_staging (document_metadata_id, doc_id, category, version_start_date, version_end_date,
                                       modified_by, created_by, updated_by, created_at, updated_at)
VALUES
    -- doc 1: IMPORTED -> NOT_CHECKED -> FETCHED
    (UUID_TO_BIN('91000001-0000-4000-8000-000000000001'),
     UUID_TO_BIN('18034fa5-d668-4383-99a6-c92ed1350c38'),
     'IMPORTED', '2025-08-15 09:13:56', '2025-08-15 09:14:01',
     'system-automation',
     'system-automation',
     'system-automation',
     '2025-08-15 09:13:56', '2025-08-15 09:14:01'),
    (UUID_TO_BIN('91000001-0000-4000-8000-000000000002'),
     UUID_TO_BIN('18034fa5-d668-4383-99a6-c92ed1350c38'),
     'NOT_CHECKED', '2025-08-15 09:14:01', '2025-08-15 09:45:01',
     'system-automation',
     'system-automation',
     'system-automation',
     '2025-08-15 09:14:01', '2025-08-15 09:45:01'),
    (UUID_TO_BIN('91000001-0000-4000-8000-000000000003'),
     UUID_TO_BIN('18034fa5-d668-4383-99a6-c92ed1350c38'),
     'FETCHED', '2025-08-15 09:45:01', NULL,
     'system-automation',
     'system-automation',
     'system-automation',
     '2025-08-15 09:45:01', '2025-08-15 09:45:01'),

    -- doc 2: IMPORTED -> NOT_CHECKED -> DECLINED
    (UUID_TO_BIN('91000001-0000-4000-8000-000000000004'),
     UUID_TO_BIN('20000000-aaaa-4000-8000-000000000001'),
     'IMPORTED', '2025-08-10 14:00:00', '2025-08-10 14:05:01',
     'system-automation',
     'system-automation',
     'system-automation',
     '2025-08-10 14:00:00', '2025-08-10 14:05:01'),
    (UUID_TO_BIN('91000001-0000-4000-8000-000000000005'),
     UUID_TO_BIN('20000000-aaaa-4000-8000-000000000001'),
     'NOT_CHECKED', '2025-08-10 14:05:01', '2025-08-10 15:20:00',
     'system-automation',
     'system-automation',
     'max.mustermann',
     '2025-08-10 14:05:01', '2025-08-10 15:20:00'),
    (UUID_TO_BIN('91000001-0000-4000-8000-000000000006'),
     UUID_TO_BIN('20000000-aaaa-4000-8000-000000000001'),
     'DECLINED', '2025-08-10 15:20:00', NULL,
     'max.mustermann',
     'max.mustermann',
     'max.mustermann',
     '2025-08-10 15:20:00', '2025-08-10 15:20:00'),

    -- doc 3: IMPORTED -> NOT_CHECKED -> CORRECTED
    (UUID_TO_BIN('91000001-0000-4000-8000-000000000007'),
     UUID_TO_BIN('20000000-bbbb-4000-8000-000000000002'),
     'IMPORTED', '2025-08-11 10:30:00', '2025-08-11 10:35:01',
     'system-automation',
     'system-automation',
     'system-automation',
     '2025-08-11 10:30:00', '2025-08-11 10:35:01'),
    (UUID_TO_BIN('91000001-0000-4000-8000-000000000008'),
     UUID_TO_BIN('20000000-bbbb-4000-8000-000000000002'),
     'NOT_CHECKED', '2025-08-11 10:35:01', '2025-08-11 14:10:00',
     'system-automation',
     'system-automation',
     'sven.bergmann',
     '2025-08-11 10:35:01', '2025-08-11 14:10:00'),
    (UUID_TO_BIN('91000001-0000-4000-8000-000000000009'),
     UUID_TO_BIN('20000000-bbbb-4000-8000-000000000002'),
     'CORRECTED', '2025-08-11 14:10:00', NULL,
     'sven.bergmann',
     'sven.bergmann',
     'anna.schmidt',
     '2025-08-11 14:10:00', '2025-08-11 14:15:00'),

    -- doc 6: IMPORTED -> FETCHED (current)
    (UUID_TO_BIN('91000001-0000-4000-8000-000000000010'),
     UUID_TO_BIN('30000000-0002-4000-8000-000000000001'),
     'IMPORTED', '2025-08-18 07:30:00', '2025-08-18 07:36:01',
     'system-automation',
     'system-automation',
     'system-automation',
     '2025-08-18 07:30:00', '2025-08-18 07:36:01'),
    (UUID_TO_BIN('91000001-0000-4000-8000-000000000011'),
     UUID_TO_BIN('30000000-0002-4000-8000-000000000001'),
     'FETCHED', '2025-08-18 07:36:01', NULL,
     'system-automation',
     'system-automation',
     'system-automation',
     '2025-08-18 07:36:01', '2025-08-18 07:36:01'),

    -- doc 8: IMPORTED -> FETCHED (current)
    (UUID_TO_BIN('91000001-0000-4000-8000-000000000012'),
     UUID_TO_BIN('30000000-0002-4000-8000-000000000003'),
     'IMPORTED', '2025-08-19 09:00:00', '2025-08-19 09:25:00',
     'system-automation',
     'system-automation',
     'lisa.mueller',
     '2025-08-19 09:00:00', '2025-08-19 09:25:00'),
    (UUID_TO_BIN('91000001-0000-4000-8000-000000000013'),
     UUID_TO_BIN('30000000-0002-4000-8000-000000000003'),
     'FETCHED', '2025-08-19 09:25:00', NULL,
     'lisa.mueller',
     'lisa.mueller',
     'lisa.mueller',
     '2025-08-19 09:25:00', '2025-08-19 09:25:00');

INSERT INTO document_metadata (document_metadata_id, doc_id, category, modified_by, created_by, updated_by, created_at, updated_at)
SELECT document_metadata_id,
       doc_id,
       category,
       modified_by,
       created_by,
       updated_by,
       created_at,
       updated_at
FROM document_metadata_staging;

DROP TEMPORARY TABLE `document_metadata_staging`;


-- -----------------------------------------------
-- 6. Task edits
-- -----------------------------------------------
INSERT INTO task_edits (edit_id, task_id, user_id, datetime, mode, edit_type, edit_value)
VALUES (UUID_TO_BIN('f0000001-0000-4000-8000-000000000001'),
        UUID_TO_BIN('d0000001-0000-4000-8000-000000000001'),
        UUID_TO_BIN('b0000001-0000-0000-0000-000000000003'),
        '2025-08-15 09:30:00', 'EDIT',
        'InvoiceHeader.PaymentCondition', '0001 / 10 days due net');


-- -----------------------------------------------
-- 7. Task exceptions
-- -----------------------------------------------
INSERT INTO task_exceptions (exception_id, task_id, scope, position_type, position_id, todo_type, status, created_at,
                             resolved_at, resolved_by_user_id, deviation_amount, risk_level)
VALUES (UUID_TO_BIN('f1000001-0000-4000-8000-000000000001'),
        UUID_TO_BIN('d0000001-0000-4000-8000-000000000001'),
        'HEADER', NULL, NULL,
        'payment_condition_mismatch', 'RESOLVED',
        '2025-08-15 09:14:02', '2025-08-15 09:30:00',
        UUID_TO_BIN('b0000001-0000-0000-0000-000000000003'),
        NULL, 'MEDIUM'),
       (UUID_TO_BIN('f1000001-0000-4000-8000-000000000002'),
        UUID_TO_BIN('d0000001-0000-4000-8000-000000000001'),
        'HEADER', NULL, NULL,
        'net_saldo_mismatch', 'RESOLVED',
        '2025-08-15 09:14:02', '2025-08-15 09:40:00',
        UUID_TO_BIN('b0000001-0000-0000-0000-000000000003'),
        -2713.35, 'HIGH');


-- -----------------------------------------------
-- 8. Reserved metadata ids for prediction_fields.metadata_id
--    (no FK to table by design in the current schema)
-- -----------------------------------------------


-- -----------------------------------------------
-- 9. Prediction fields
--
-- Keep existing payload in legacy structure, then migrate
-- into final schema (`document_versions` + `prediction_fields.version_id`).
RENAME TABLE prediction_fields TO prediction_fields_final;

CREATE TABLE `prediction_fields`
(
    `field_id`           BINARY(16)                       NOT NULL,
    `parent_field_id`    BINARY(16),
    `metadata_id`        BINARY(16),
    `task_id`            BINARY(16),
    `field_key`          VARCHAR(128),
    `field_type`         ENUM ('OBJECT','ARRAY','SCALAR') NOT NULL,
    `value_string`       TEXT,
    `value_number`       DECIMAL(18, 6),
    `value_date`         DATETIME,
    `value_bool`         BOOLEAN,
    `version_start_date` DATETIME,
    `version_end_date`   DATETIME,
    `modified_by`        BINARY(16),
    `created_at`         DATETIME                         NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`field_id`)
);
--
--    field_type semantics:
--      OBJECT = named children (key-value container)
--      ARRAY  = ordered children (list container)
--      SCALAR = leaf node, read value from value_* columns
--
--    Tree structure:
--      header fields   → parent_field_id = NULL, metadata_id = NULL
--      position fields → parent_field_id = header root, metadata_id = prediction_fields_metadata row
--      nested JSON     → parent_field_id = parent field (child rows)
--
--    Temporal versioning:
--      v1 = initial prediction  (version_end_date set → superseded)
--      v2 = after user edit     (version_end_date = NULL → current)
-- -----------------------------------------------

-- =====================================================
-- predicton_sven.json – v1 HEADER fields (superseded)
-- =====================================================
INSERT INTO prediction_fields (field_id, parent_field_id, metadata_id, task_id, field_key, field_type, value_string,
                               value_number, value_date, value_bool, version_start_date, version_end_date, modified_by,
                               created_at)
VALUES (UUID_TO_BIN('22000001-0001-4000-8000-000000000001'),
        NULL, NULL, UUID_TO_BIN('d0000001-0000-4000-8000-000000000001'),
        'DocumentDate', 'SCALAR', NULL, NULL, '2025-08-13 00:00:00', NULL,
        '2025-08-15 09:14:01', '2025-08-15 09:30:00',
        UUID_TO_BIN('a0000001-0000-0000-0000-000000000001'), '2025-08-15 09:14:01'),

       (UUID_TO_BIN('22000001-0001-4000-8000-000000000002'),
        NULL, NULL, UUID_TO_BIN('d0000001-0000-4000-8000-000000000001'),
        'DocumentNumber', 'OBJECT', '1062623192', NULL, NULL, NULL,
        '2025-08-15 09:14:01', '2025-08-15 09:30:00',
        UUID_TO_BIN('a0000001-0000-0000-0000-000000000001'), '2025-08-15 09:14:01'),

       (UUID_TO_BIN('22000001-0001-4000-8000-000000000003'),
        NULL, NULL, UUID_TO_BIN('d0000001-0000-4000-8000-000000000001'),
        'InvoiceType', 'SCALAR', 'MM', NULL, NULL, NULL,
        '2025-08-15 09:14:01', '2025-08-15 09:30:00',
        UUID_TO_BIN('a0000001-0000-0000-0000-000000000001'), '2025-08-15 09:14:01'),

       (UUID_TO_BIN('22000001-0001-4000-8000-000000000004'),
        NULL, NULL, UUID_TO_BIN('d0000001-0000-4000-8000-000000000001'),
        'PostingDate', 'SCALAR', NULL, NULL, '2025-08-13 00:00:00', NULL,
        '2025-08-15 09:14:01', '2025-08-15 09:30:00',
        UUID_TO_BIN('a0000001-0000-0000-0000-000000000001'), '2025-08-15 09:14:01'),

       (UUID_TO_BIN('22000001-0001-4000-8000-000000000005'),
        NULL, NULL, UUID_TO_BIN('d0000001-0000-4000-8000-000000000001'),
        'Currency', 'SCALAR', 'EUR', NULL, NULL, NULL,
        '2025-08-15 09:14:01', '2025-08-15 09:30:00',
        UUID_TO_BIN('a0000001-0000-0000-0000-000000000001'), '2025-08-15 09:14:01'),

       (UUID_TO_BIN('22000001-0001-4000-8000-000000000006'),
        NULL, NULL, UUID_TO_BIN('d0000001-0000-4000-8000-000000000001'),
        'BusinessPartnerName', 'SCALAR', 'Niederlassung Rottenburg/Neckar', NULL, NULL, NULL,
        '2025-08-15 09:14:01', '2025-08-15 09:30:00',
        UUID_TO_BIN('a0000001-0000-0000-0000-000000000001'), '2025-08-15 09:14:01'),

       (UUID_TO_BIN('22000001-0001-4000-8000-000000000007'),
        NULL, NULL, UUID_TO_BIN('d0000001-0000-4000-8000-000000000001'),
        'BusinessPartnerCity', 'SCALAR', 'Rottenburg-Ergenzingen', NULL, NULL, NULL,
        '2025-08-15 09:14:01', '2025-08-15 09:30:00',
        UUID_TO_BIN('a0000001-0000-0000-0000-000000000001'), '2025-08-15 09:14:01'),

       (UUID_TO_BIN('22000001-0001-4000-8000-000000000008'),
        NULL, NULL, UUID_TO_BIN('d0000001-0000-4000-8000-000000000001'),
        'PaymentCondition', 'SCALAR', '0001 / 10 days due net', NULL, NULL, NULL,
        '2025-08-15 09:14:01', '2025-08-15 09:30:00',
        UUID_TO_BIN('a0000001-0000-0000-0000-000000000001'), '2025-08-15 09:14:01'),

       (UUID_TO_BIN('22000001-0001-4000-8000-000000000009'),
        NULL, NULL, UUID_TO_BIN('d0000001-0000-4000-8000-000000000001'),
        'AcceptDuplicates', 'SCALAR', NULL, NULL, NULL, FALSE,
        '2025-08-15 09:14:01', '2025-08-15 09:30:00',
        UUID_TO_BIN('a0000001-0000-0000-0000-000000000001'), '2025-08-15 09:14:01'),

       (UUID_TO_BIN('22000001-0001-4000-8000-000000000010'),
        NULL, NULL, UUID_TO_BIN('d0000001-0000-4000-8000-000000000001'),
        'BlockPayment', 'SCALAR', NULL, NULL, NULL, FALSE,
        '2025-08-15 09:14:01', '2025-08-15 09:30:00',
        UUID_TO_BIN('a0000001-0000-0000-0000-000000000001'), '2025-08-15 09:14:01');


-- == v1 POSITION fields – invoice_position (pos_0), parent → DocumentNumber (OBJECT) ==
INSERT INTO prediction_fields (field_id, parent_field_id, metadata_id, task_id, field_key, field_type, value_string,
                               value_number, value_date, value_bool, version_start_date, version_end_date, modified_by,
                               created_at)
VALUES (UUID_TO_BIN('33000001-0001-4000-8000-000000000001'),
        UUID_TO_BIN('22000001-0001-4000-8000-000000000002'),
        UUID_TO_BIN('aa000001-0000-4000-8000-000000000001'),
        UUID_TO_BIN('d0000001-0000-4000-8000-000000000001'),
        'Currency', 'OBJECT', 'EUR', NULL, NULL, NULL,
        '2025-08-15 09:14:01', '2025-08-15 09:30:00',
        UUID_TO_BIN('a0000001-0000-0000-0000-000000000001'), '2025-08-15 09:14:01'),

       (UUID_TO_BIN('33000001-0001-4000-8000-000000000002'),
        UUID_TO_BIN('22000001-0001-4000-8000-000000000002'),
        UUID_TO_BIN('aa000001-0000-4000-8000-000000000001'),
        UUID_TO_BIN('d0000001-0000-4000-8000-000000000001'),
        'DeliveryNotePositionNumber', 'SCALAR', '1', NULL, NULL, NULL,
        '2025-08-15 09:14:01', '2025-08-15 09:30:00',
        UUID_TO_BIN('a0000001-0000-0000-0000-000000000001'), '2025-08-15 09:14:01'),

       (UUID_TO_BIN('33000001-0001-4000-8000-000000000003'),
        UUID_TO_BIN('22000001-0001-4000-8000-000000000002'),
        UUID_TO_BIN('aa000001-0000-4000-8000-000000000001'),
        UUID_TO_BIN('d0000001-0000-4000-8000-000000000001'),
        'DeliveryNoteReferenceNumber', 'SCALAR', '8003451566', NULL, NULL, NULL,
        '2025-08-15 09:14:01', '2025-08-15 09:30:00',
        UUID_TO_BIN('a0000001-0000-0000-0000-000000000001'), '2025-08-15 09:14:01');

-- == v1 POSITION fields – accounting, parent → pos_0 Currency (OBJECT) ==
INSERT INTO prediction_fields (field_id, parent_field_id, metadata_id, task_id, field_key, field_type, value_string,
                               value_number, value_date, value_bool, version_start_date, version_end_date, modified_by,
                               created_at)
VALUES (UUID_TO_BIN('33000001-0001-4000-8000-000000000004'),
        UUID_TO_BIN('33000001-0001-4000-8000-000000000001'),
        UUID_TO_BIN('aa000001-0000-4000-8000-000000000003'),
        UUID_TO_BIN('d0000001-0000-4000-8000-000000000001'),
        'CostCenter', 'SCALAR', NULL, NULL, NULL, NULL,
        '2025-08-15 09:14:01', '2025-08-15 09:30:00',
        UUID_TO_BIN('a0000001-0000-0000-0000-000000000001'), '2025-08-15 09:14:01'),

       (UUID_TO_BIN('33000001-0001-4000-8000-000000000005'),
        UUID_TO_BIN('33000001-0001-4000-8000-000000000001'),
        UUID_TO_BIN('aa000001-0000-4000-8000-000000000003'),
        UUID_TO_BIN('d0000001-0000-4000-8000-000000000001'),
        'Account', 'SCALAR', NULL, NULL, NULL, NULL,
        '2025-08-15 09:14:01', '2025-08-15 09:30:00',
        UUID_TO_BIN('a0000001-0000-0000-0000-000000000001'), '2025-08-15 09:14:01');

-- == v1 POSITION fields – extracosts, parent → pos_0 Currency (OBJECT) ==
INSERT INTO prediction_fields (field_id, parent_field_id, metadata_id, task_id, field_key, field_type, value_string,
                               value_number, value_date, value_bool, version_start_date, version_end_date, modified_by,
                               created_at)
VALUES (UUID_TO_BIN('33000001-0001-4000-8000-000000000006'),
        UUID_TO_BIN('33000001-0001-4000-8000-000000000001'),
        UUID_TO_BIN('aa000001-0000-4000-8000-000000000002'),
        UUID_TO_BIN('d0000001-0000-4000-8000-000000000001'),
        'ExtraCostDescription', 'SCALAR', 'Freight surcharge', NULL, NULL, NULL,
        '2025-08-15 09:14:01', '2025-08-15 09:30:00',
        UUID_TO_BIN('a0000001-0000-0000-0000-000000000001'), '2025-08-15 09:14:01'),

       (UUID_TO_BIN('33000001-0001-4000-8000-000000000007'),
        UUID_TO_BIN('33000001-0001-4000-8000-000000000001'),
        UUID_TO_BIN('aa000001-0000-4000-8000-000000000002'),
        UUID_TO_BIN('d0000001-0000-4000-8000-000000000001'),
        'ExtraCostAmount', 'SCALAR', NULL, 150.000000, NULL, NULL,
        '2025-08-15 09:14:01', '2025-08-15 09:30:00',
        UUID_TO_BIN('a0000001-0000-0000-0000-000000000001'), '2025-08-15 09:14:01');


-- =====================================================
-- predicton_sven.json – v2 HEADER fields (current)
-- =====================================================
INSERT INTO prediction_fields (field_id, parent_field_id, metadata_id, task_id, field_key, field_type, value_string,
                               value_number, value_date, value_bool, version_start_date, version_end_date, modified_by,
                               created_at)
VALUES (UUID_TO_BIN('22000002-0001-4000-8000-000000000001'),
        NULL, NULL, UUID_TO_BIN('d0000001-0000-4000-8000-000000000001'),
        'DocumentDate', 'SCALAR', NULL, NULL, '2025-08-13 00:00:00', NULL,
        '2025-08-15 09:30:00', NULL,
        UUID_TO_BIN('b0000001-0000-0000-0000-000000000003'), '2025-08-15 09:30:00'),

       (UUID_TO_BIN('22000002-0001-4000-8000-000000000002'),
        NULL, NULL, UUID_TO_BIN('d0000001-0000-4000-8000-000000000001'),
        'DocumentNumber', 'OBJECT', '1062623192', NULL, NULL, NULL,
        '2025-08-15 09:30:00', NULL,
        UUID_TO_BIN('b0000001-0000-0000-0000-000000000003'), '2025-08-15 09:30:00'),

       (UUID_TO_BIN('22000002-0001-4000-8000-000000000003'),
        NULL, NULL, UUID_TO_BIN('d0000001-0000-4000-8000-000000000001'),
        'InvoiceType', 'SCALAR', 'MM', NULL, NULL, NULL,
        '2025-08-15 09:30:00', NULL,
        UUID_TO_BIN('b0000001-0000-0000-0000-000000000003'), '2025-08-15 09:30:00'),

       (UUID_TO_BIN('22000002-0001-4000-8000-000000000004'),
        NULL, NULL, UUID_TO_BIN('d0000001-0000-4000-8000-000000000001'),
        'PostingDate', 'SCALAR', NULL, NULL, '2025-08-13 00:00:00', NULL,
        '2025-08-15 09:30:00', NULL,
        UUID_TO_BIN('b0000001-0000-0000-0000-000000000003'), '2025-08-15 09:30:00'),

       (UUID_TO_BIN('22000002-0001-4000-8000-000000000005'),
        NULL, NULL, UUID_TO_BIN('d0000001-0000-4000-8000-000000000001'),
        'Currency', 'SCALAR', 'EUR', NULL, NULL, NULL,
        '2025-08-15 09:30:00', NULL,
        UUID_TO_BIN('b0000001-0000-0000-0000-000000000003'), '2025-08-15 09:30:00'),

       (UUID_TO_BIN('22000002-0001-4000-8000-000000000008'),
        NULL, NULL, UUID_TO_BIN('d0000001-0000-4000-8000-000000000001'),
        'PaymentCondition', 'SCALAR', '0001 / 10 days due net', NULL, NULL, NULL,
        '2025-08-15 09:30:00', NULL,
        UUID_TO_BIN('b0000001-0000-0000-0000-000000000003'), '2025-08-15 09:30:00'),

       (UUID_TO_BIN('22000002-0001-4000-8000-000000000009'),
        NULL, NULL, UUID_TO_BIN('d0000001-0000-4000-8000-000000000001'),
        'AcceptDuplicates', 'SCALAR', NULL, NULL, NULL, FALSE,
        '2025-08-15 09:30:00', NULL,
        UUID_TO_BIN('b0000001-0000-0000-0000-000000000003'), '2025-08-15 09:30:00'),

       (UUID_TO_BIN('22000002-0001-4000-8000-000000000010'),
        NULL, NULL, UUID_TO_BIN('d0000001-0000-4000-8000-000000000001'),
        'BlockPayment', 'SCALAR', NULL, NULL, NULL, FALSE,
        '2025-08-15 09:30:00', NULL,
        UUID_TO_BIN('b0000001-0000-0000-0000-000000000003'), '2025-08-15 09:30:00');

-- == v2 POSITION fields (current) ==
INSERT INTO prediction_fields (field_id, parent_field_id, metadata_id, task_id, field_key, field_type, value_string,
                               value_number, value_date, value_bool, version_start_date, version_end_date, modified_by,
                               created_at)
VALUES (UUID_TO_BIN('33000002-0001-4000-8000-000000000001'),
        UUID_TO_BIN('22000002-0001-4000-8000-000000000002'),
        UUID_TO_BIN('aa000001-0000-4000-8000-000000000001'),
        UUID_TO_BIN('d0000001-0000-4000-8000-000000000001'),
        'Currency', 'SCALAR', 'EUR', NULL, NULL, NULL,
        '2025-08-15 09:30:00', NULL,
        UUID_TO_BIN('b0000001-0000-0000-0000-000000000003'), '2025-08-15 09:30:00'),

       (UUID_TO_BIN('33000002-0001-4000-8000-000000000002'),
        UUID_TO_BIN('22000002-0001-4000-8000-000000000002'),
        UUID_TO_BIN('aa000001-0000-4000-8000-000000000001'),
        UUID_TO_BIN('d0000001-0000-4000-8000-000000000001'),
        'DeliveryNoteReferenceNumber', 'SCALAR', '8003451566', NULL, NULL, NULL,
        '2025-08-15 09:30:00', NULL,
        UUID_TO_BIN('b0000001-0000-0000-0000-000000000003'), '2025-08-15 09:30:00');


-- =====================================================
-- prediction_jsonata.json – config as tree (current)
-- Every nesting level is a parent/child relationship
--
--   BillingAddressConfig          (root)
--   ├── ActiveFields              (child)
--   │   ├── Name                  (leaf)
--   │   ├── Street                (leaf)
--   │   ├── Postcode              (leaf)
--   │   └── City                  (leaf)
--   └── CommitChecks              (child)
--       ├── City                  (leaf, bool)
--       └── Country               (leaf, bool)
--   InvoiceHeaderConfig           (root)
--   └── AllowedInvoiceTypes       (child)
--       ├── ASSET                 (leaf)
--       ├── MM                    (leaf)
--       └── FI                    (leaf)
--   PaymentCardConfig             (root)
--   └── PaymentCardMode           (leaf)
--   PaymentInfoConfig             (root)
--   └── UsePaymentMethods         (leaf, bool)
-- =====================================================

-- roots (OBJECT – have named children)
INSERT INTO prediction_fields (field_id, parent_field_id, metadata_id, task_id, field_key, field_type, value_string,
                               value_number, value_date, value_bool, version_start_date, version_end_date, modified_by,
                               created_at)
VALUES (UUID_TO_BIN('22000010-0001-4000-8000-000000000001'),
        NULL, NULL, UUID_TO_BIN('d0000001-0000-4000-8000-000000000002'),
        'BillingAddressConfig', 'OBJECT', NULL, NULL, NULL, NULL,
        '2025-08-10 14:05:01', NULL,
        UUID_TO_BIN('a0000001-0000-0000-0000-000000000001'), '2025-08-10 14:05:01'),
       (UUID_TO_BIN('22000010-0001-4000-8000-000000000002'),
        NULL, NULL, UUID_TO_BIN('d0000001-0000-4000-8000-000000000002'),
        'InvoiceHeaderConfig', 'OBJECT', NULL, NULL, NULL, NULL,
        '2025-08-10 14:05:01', NULL,
        UUID_TO_BIN('a0000001-0000-0000-0000-000000000001'), '2025-08-10 14:05:01'),
       (UUID_TO_BIN('22000010-0001-4000-8000-000000000005'),
        NULL, NULL, UUID_TO_BIN('d0000001-0000-4000-8000-000000000002'),
        'PaymentCardConfig', 'OBJECT', NULL, NULL, NULL, NULL,
        '2025-08-10 14:05:01', NULL,
        UUID_TO_BIN('a0000001-0000-0000-0000-000000000001'), '2025-08-10 14:05:01'),
       (UUID_TO_BIN('22000010-0001-4000-8000-000000000006'),
        NULL, NULL, UUID_TO_BIN('d0000001-0000-4000-8000-000000000002'),
        'PaymentInfoConfig', 'OBJECT', NULL, NULL, NULL, NULL,
        '2025-08-10 14:05:01', NULL,
        UUID_TO_BIN('a0000001-0000-0000-0000-000000000001'), '2025-08-10 14:05:01');

-- BillingAddressConfig → ActiveFields (OBJECT)
INSERT INTO prediction_fields (field_id, parent_field_id, metadata_id, task_id, field_key, field_type, value_string,
                               value_number, value_date, value_bool, version_start_date, version_end_date, modified_by,
                               created_at)
VALUES (UUID_TO_BIN('22000010-0001-4000-8000-000000000030'),
        UUID_TO_BIN('22000010-0001-4000-8000-000000000001'),
        NULL, UUID_TO_BIN('d0000001-0000-4000-8000-000000000002'),
        'ActiveFields', 'OBJECT', NULL, NULL, NULL, NULL,
        '2025-08-10 14:05:01', NULL,
        UUID_TO_BIN('a0000001-0000-0000-0000-000000000001'), '2025-08-10 14:05:01');

-- ActiveFields → leaves (SCALAR)
INSERT INTO prediction_fields (field_id, parent_field_id, metadata_id, task_id, field_key, field_type, value_string,
                               value_number, value_date, value_bool, version_start_date, version_end_date, modified_by,
                               created_at)
VALUES (UUID_TO_BIN('22000010-0001-4000-8000-000000000010'),
        UUID_TO_BIN('22000010-0001-4000-8000-000000000030'),
        NULL, UUID_TO_BIN('d0000001-0000-4000-8000-000000000002'),
        'Name', 'SCALAR', 'Name', NULL, NULL, NULL,
        '2025-08-10 14:05:01', NULL,
        UUID_TO_BIN('a0000001-0000-0000-0000-000000000001'), '2025-08-10 14:05:01'),
       (UUID_TO_BIN('22000010-0001-4000-8000-000000000011'),
        UUID_TO_BIN('22000010-0001-4000-8000-000000000030'),
        NULL, UUID_TO_BIN('d0000001-0000-4000-8000-000000000002'),
        'Street', 'SCALAR', 'Street', NULL, NULL, NULL,
        '2025-08-10 14:05:01', NULL,
        UUID_TO_BIN('a0000001-0000-0000-0000-000000000001'), '2025-08-10 14:05:01'),
       (UUID_TO_BIN('22000010-0001-4000-8000-000000000012'),
        UUID_TO_BIN('22000010-0001-4000-8000-000000000030'),
        NULL, UUID_TO_BIN('d0000001-0000-4000-8000-000000000002'),
        'Postcode', 'SCALAR', 'Postcode', NULL, NULL, NULL,
        '2025-08-10 14:05:01', NULL,
        UUID_TO_BIN('a0000001-0000-0000-0000-000000000001'), '2025-08-10 14:05:01'),
       (UUID_TO_BIN('22000010-0001-4000-8000-000000000013'),
        UUID_TO_BIN('22000010-0001-4000-8000-000000000030'),
        NULL, UUID_TO_BIN('d0000001-0000-4000-8000-000000000002'),
        'City', 'SCALAR', 'City', NULL, NULL, NULL,
        '2025-08-10 14:05:01', NULL,
        UUID_TO_BIN('a0000001-0000-0000-0000-000000000001'), '2025-08-10 14:05:01');

-- BillingAddressConfig → CommitChecks (OBJECT)
INSERT INTO prediction_fields (field_id, parent_field_id, metadata_id, task_id, field_key, field_type, value_string,
                               value_number, value_date, value_bool, version_start_date, version_end_date, modified_by,
                               created_at)
VALUES (UUID_TO_BIN('22000010-0001-4000-8000-000000000031'),
        UUID_TO_BIN('22000010-0001-4000-8000-000000000001'),
        NULL, UUID_TO_BIN('d0000001-0000-4000-8000-000000000002'),
        'CommitChecks', 'OBJECT', NULL, NULL, NULL, NULL,
        '2025-08-10 14:05:01', NULL,
        UUID_TO_BIN('a0000001-0000-0000-0000-000000000001'), '2025-08-10 14:05:01');

-- CommitChecks → leaves (SCALAR)
INSERT INTO prediction_fields (field_id, parent_field_id, metadata_id, task_id, field_key, field_type, value_string,
                               value_number, value_date, value_bool, version_start_date, version_end_date, modified_by,
                               created_at)
VALUES (UUID_TO_BIN('22000010-0001-4000-8000-000000000014'),
        UUID_TO_BIN('22000010-0001-4000-8000-000000000031'),
        NULL, UUID_TO_BIN('d0000001-0000-4000-8000-000000000002'),
        'City', 'SCALAR', NULL, NULL, NULL, FALSE,
        '2025-08-10 14:05:01', NULL,
        UUID_TO_BIN('a0000001-0000-0000-0000-000000000001'), '2025-08-10 14:05:01'),
       (UUID_TO_BIN('22000010-0001-4000-8000-000000000015'),
        UUID_TO_BIN('22000010-0001-4000-8000-000000000031'),
        NULL, UUID_TO_BIN('d0000001-0000-4000-8000-000000000002'),
        'Country', 'SCALAR', NULL, NULL, NULL, FALSE,
        '2025-08-10 14:05:01', NULL,
        UUID_TO_BIN('a0000001-0000-0000-0000-000000000001'), '2025-08-10 14:05:01');

-- InvoiceHeaderConfig → AllowedInvoiceTypes (ARRAY – ordered list of values)
INSERT INTO prediction_fields (field_id, parent_field_id, metadata_id, task_id, field_key, field_type, value_string,
                               value_number, value_date, value_bool, version_start_date, version_end_date, modified_by,
                               created_at)
VALUES (UUID_TO_BIN('22000010-0001-4000-8000-000000000032'),
        UUID_TO_BIN('22000010-0001-4000-8000-000000000002'),
        NULL, UUID_TO_BIN('d0000001-0000-4000-8000-000000000002'),
        'AllowedInvoiceTypes', 'ARRAY', NULL, NULL, NULL, NULL,
        '2025-08-10 14:05:01', NULL,
        UUID_TO_BIN('a0000001-0000-0000-0000-000000000001'), '2025-08-10 14:05:01');

-- AllowedInvoiceTypes → leaves (SCALAR)
INSERT INTO prediction_fields (field_id, parent_field_id, metadata_id, task_id, field_key, field_type, value_string,
                               value_number, value_date, value_bool, version_start_date, version_end_date, modified_by,
                               created_at)
VALUES (UUID_TO_BIN('22000010-0001-4000-8000-000000000020'),
        UUID_TO_BIN('22000010-0001-4000-8000-000000000032'),
        NULL, UUID_TO_BIN('d0000001-0000-4000-8000-000000000002'),
        'ASSET', 'SCALAR', 'ASSET', NULL, NULL, NULL,
        '2025-08-10 14:05:01', NULL,
        UUID_TO_BIN('a0000001-0000-0000-0000-000000000001'), '2025-08-10 14:05:01'),
       (UUID_TO_BIN('22000010-0001-4000-8000-000000000021'),
        UUID_TO_BIN('22000010-0001-4000-8000-000000000032'),
        NULL, UUID_TO_BIN('d0000001-0000-4000-8000-000000000002'),
        'MM', 'SCALAR', 'MM', NULL, NULL, NULL,
        '2025-08-10 14:05:01', NULL,
        UUID_TO_BIN('a0000001-0000-0000-0000-000000000001'), '2025-08-10 14:05:01'),
       (UUID_TO_BIN('22000010-0001-4000-8000-000000000022'),
        UUID_TO_BIN('22000010-0001-4000-8000-000000000032'),
        NULL, UUID_TO_BIN('d0000001-0000-4000-8000-000000000002'),
        'FI', 'SCALAR', 'FI', NULL, NULL, NULL,
        '2025-08-10 14:05:01', NULL,
        UUID_TO_BIN('a0000001-0000-0000-0000-000000000001'), '2025-08-10 14:05:01');

-- PaymentCardConfig → PaymentCardMode (SCALAR leaf)
INSERT INTO prediction_fields (field_id, parent_field_id, metadata_id, task_id, field_key, field_type, value_string,
                               value_number, value_date, value_bool, version_start_date, version_end_date, modified_by,
                               created_at)
VALUES (UUID_TO_BIN('22000010-0001-4000-8000-000000000033'),
        UUID_TO_BIN('22000010-0001-4000-8000-000000000005'),
        NULL, UUID_TO_BIN('d0000001-0000-4000-8000-000000000002'),
        'PaymentCardMode', 'SCALAR', 'FULL', NULL, NULL, NULL,
        '2025-08-10 14:05:01', NULL,
        UUID_TO_BIN('a0000001-0000-0000-0000-000000000001'), '2025-08-10 14:05:01');

-- PaymentInfoConfig → UsePaymentMethods (SCALAR leaf)
INSERT INTO prediction_fields (field_id, parent_field_id, metadata_id, task_id, field_key, field_type, value_string,
                               value_number, value_date, value_bool, version_start_date, version_end_date, modified_by,
                               created_at)
VALUES (UUID_TO_BIN('22000010-0001-4000-8000-000000000034'),
        UUID_TO_BIN('22000010-0001-4000-8000-000000000006'),
        NULL, UUID_TO_BIN('d0000001-0000-4000-8000-000000000002'),
        'UsePaymentMethods', 'SCALAR', NULL, NULL, NULL, TRUE,
        '2025-08-10 14:05:01', NULL,
        UUID_TO_BIN('a0000001-0000-0000-0000-000000000001'), '2025-08-10 14:05:01');


-- =====================================================
-- prediction_xslt.json – config as tree (current)
-- Same tree structure, different task
-- =====================================================

-- roots (OBJECT)
INSERT INTO prediction_fields (field_id, parent_field_id, metadata_id, task_id, field_key, field_type, value_string,
                               value_number, value_date, value_bool, version_start_date, version_end_date, modified_by,
                               created_at)
VALUES (UUID_TO_BIN('22000020-0001-4000-8000-000000000001'),
        NULL, NULL, UUID_TO_BIN('d0000001-0000-4000-8000-000000000003'),
        'BillingAddressConfig', 'OBJECT', NULL, NULL, NULL, NULL,
        '2025-08-11 10:35:01', NULL,
        UUID_TO_BIN('a0000001-0000-0000-0000-000000000001'), '2025-08-11 10:35:01'),
       (UUID_TO_BIN('22000020-0001-4000-8000-000000000002'),
        NULL, NULL, UUID_TO_BIN('d0000001-0000-4000-8000-000000000003'),
        'InvoiceHeaderConfig', 'OBJECT', NULL, NULL, NULL, NULL,
        '2025-08-11 10:35:01', NULL,
        UUID_TO_BIN('a0000001-0000-0000-0000-000000000001'), '2025-08-11 10:35:01'),
       (UUID_TO_BIN('22000020-0001-4000-8000-000000000004'),
        NULL, NULL, UUID_TO_BIN('d0000001-0000-4000-8000-000000000003'),
        'PaymentCardConfig', 'OBJECT', NULL, NULL, NULL, NULL,
        '2025-08-11 10:35:01', NULL,
        UUID_TO_BIN('a0000001-0000-0000-0000-000000000001'), '2025-08-11 10:35:01'),
       (UUID_TO_BIN('22000020-0001-4000-8000-000000000005'),
        NULL, NULL, UUID_TO_BIN('d0000001-0000-4000-8000-000000000003'),
        'PaymentInfoConfig', 'OBJECT', NULL, NULL, NULL, NULL,
        '2025-08-11 10:35:01', NULL,
        UUID_TO_BIN('a0000001-0000-0000-0000-000000000001'), '2025-08-11 10:35:01');

-- BillingAddressConfig → ActiveFields (OBJECT)
INSERT INTO prediction_fields (field_id, parent_field_id, metadata_id, task_id, field_key, field_type, value_string,
                               value_number, value_date, value_bool, version_start_date, version_end_date, modified_by,
                               created_at)
VALUES (UUID_TO_BIN('22000020-0001-4000-8000-000000000030'),
        UUID_TO_BIN('22000020-0001-4000-8000-000000000001'),
        NULL, UUID_TO_BIN('d0000001-0000-4000-8000-000000000003'),
        'ActiveFields', 'OBJECT', NULL, NULL, NULL, NULL,
        '2025-08-11 10:35:01', NULL,
        UUID_TO_BIN('a0000001-0000-0000-0000-000000000001'), '2025-08-11 10:35:01');

-- ActiveFields → leaves (SCALAR)
INSERT INTO prediction_fields (field_id, parent_field_id, metadata_id, task_id, field_key, field_type, value_string,
                               value_number, value_date, value_bool, version_start_date, version_end_date, modified_by,
                               created_at)
VALUES (UUID_TO_BIN('22000020-0001-4000-8000-000000000010'),
        UUID_TO_BIN('22000020-0001-4000-8000-000000000030'),
        NULL, UUID_TO_BIN('d0000001-0000-4000-8000-000000000003'),
        'Name', 'SCALAR', 'Name', NULL, NULL, NULL,
        '2025-08-11 10:35:01', NULL,
        UUID_TO_BIN('a0000001-0000-0000-0000-000000000001'), '2025-08-11 10:35:01'),
       (UUID_TO_BIN('22000020-0001-4000-8000-000000000011'),
        UUID_TO_BIN('22000020-0001-4000-8000-000000000030'),
        NULL, UUID_TO_BIN('d0000001-0000-4000-8000-000000000003'),
        'Street', 'SCALAR', 'Street', NULL, NULL, NULL,
        '2025-08-11 10:35:01', NULL,
        UUID_TO_BIN('a0000001-0000-0000-0000-000000000001'), '2025-08-11 10:35:01');

-- BillingAddressConfig → CommitChecks (OBJECT)
INSERT INTO prediction_fields (field_id, parent_field_id, metadata_id, task_id, field_key, field_type, value_string,
                               value_number, value_date, value_bool, version_start_date, version_end_date, modified_by,
                               created_at)
VALUES (UUID_TO_BIN('22000020-0001-4000-8000-000000000031'),
        UUID_TO_BIN('22000020-0001-4000-8000-000000000001'),
        NULL, UUID_TO_BIN('d0000001-0000-4000-8000-000000000003'),
        'CommitChecks', 'OBJECT', NULL, NULL, NULL, NULL,
        '2025-08-11 10:35:01', NULL,
        UUID_TO_BIN('a0000001-0000-0000-0000-000000000001'), '2025-08-11 10:35:01');

-- CommitChecks → leaves (SCALAR)
INSERT INTO prediction_fields (field_id, parent_field_id, metadata_id, task_id, field_key, field_type, value_string,
                               value_number, value_date, value_bool, version_start_date, version_end_date, modified_by,
                               created_at)
VALUES (UUID_TO_BIN('22000020-0001-4000-8000-000000000012'),
        UUID_TO_BIN('22000020-0001-4000-8000-000000000031'),
        NULL, UUID_TO_BIN('d0000001-0000-4000-8000-000000000003'),
        'City', 'SCALAR', NULL, NULL, NULL, FALSE,
        '2025-08-11 10:35:01', NULL,
        UUID_TO_BIN('a0000001-0000-0000-0000-000000000001'), '2025-08-11 10:35:01');

-- InvoiceHeaderConfig → AllowedInvoiceTypes (ARRAY)
INSERT INTO prediction_fields (field_id, parent_field_id, metadata_id, task_id, field_key, field_type, value_string,
                               value_number, value_date, value_bool, version_start_date, version_end_date, modified_by,
                               created_at)
VALUES (UUID_TO_BIN('22000020-0001-4000-8000-000000000032'),
        UUID_TO_BIN('22000020-0001-4000-8000-000000000002'),
        NULL, UUID_TO_BIN('d0000001-0000-4000-8000-000000000003'),
        'AllowedInvoiceTypes', 'ARRAY', NULL, NULL, NULL, NULL,
        '2025-08-11 10:35:01', NULL,
        UUID_TO_BIN('a0000001-0000-0000-0000-000000000001'), '2025-08-11 10:35:01');

-- AllowedInvoiceTypes → leaves (SCALAR)
INSERT INTO prediction_fields (field_id, parent_field_id, metadata_id, task_id, field_key, field_type, value_string,
                               value_number, value_date, value_bool, version_start_date, version_end_date, modified_by,
                               created_at)
VALUES (UUID_TO_BIN('22000020-0001-4000-8000-000000000020'),
        UUID_TO_BIN('22000020-0001-4000-8000-000000000032'),
        NULL, UUID_TO_BIN('d0000001-0000-4000-8000-000000000003'),
        'ASSET', 'SCALAR', 'ASSET', NULL, NULL, NULL,
        '2025-08-11 10:35:01', NULL,
        UUID_TO_BIN('a0000001-0000-0000-0000-000000000001'), '2025-08-11 10:35:01'),
       (UUID_TO_BIN('22000020-0001-4000-8000-000000000021'),
        UUID_TO_BIN('22000020-0001-4000-8000-000000000032'),
        NULL, UUID_TO_BIN('d0000001-0000-4000-8000-000000000003'),
        'MM', 'SCALAR', 'MM', NULL, NULL, NULL,
        '2025-08-11 10:35:01', NULL,
        UUID_TO_BIN('a0000001-0000-0000-0000-000000000001'), '2025-08-11 10:35:01');

-- PaymentCardConfig → PaymentCardMode (SCALAR leaf)
INSERT INTO prediction_fields (field_id, parent_field_id, metadata_id, task_id, field_key, field_type, value_string,
                               value_number, value_date, value_bool, version_start_date, version_end_date, modified_by,
                               created_at)
VALUES (UUID_TO_BIN('22000020-0001-4000-8000-000000000033'),
        UUID_TO_BIN('22000020-0001-4000-8000-000000000004'),
        NULL, UUID_TO_BIN('d0000001-0000-4000-8000-000000000003'),
        'PaymentCardMode', 'SCALAR', 'FULL', NULL, NULL, NULL,
        '2025-08-11 10:35:01', NULL,
        UUID_TO_BIN('a0000001-0000-0000-0000-000000000001'), '2025-08-11 10:35:01');

-- PaymentInfoConfig → UsePaymentMethods (SCALAR leaf)
INSERT INTO prediction_fields (field_id, parent_field_id, metadata_id, task_id, field_key, field_type, value_string,
                               value_number, value_date, value_bool, version_start_date, version_end_date, modified_by,
                               created_at)
VALUES (UUID_TO_BIN('22000020-0001-4000-8000-000000000034'),
        UUID_TO_BIN('22000020-0001-4000-8000-000000000005'),
        NULL, UUID_TO_BIN('d0000001-0000-4000-8000-000000000003'),
        'UsePaymentMethods', 'SCALAR', NULL, NULL, NULL, TRUE,
        '2025-08-11 10:35:01', NULL,
        UUID_TO_BIN('a0000001-0000-0000-0000-000000000001'), '2025-08-11 10:35:01');

-- Create version rows from distinct task/time versions in legacy payload.
CREATE TEMPORARY TABLE `_version_map` AS
SELECT UUID_TO_BIN(UUID())                                                              AS version_id,
       s.task_id,
       s.version_start_date,
       s.version_end_date,
       t.doc_id,
       ROW_NUMBER() OVER (
           PARTITION BY t.doc_id
           ORDER BY s.version_start_date, COALESCE(s.version_end_date, '9999-12-31 23:59:59')
           )                                                                            AS version_number,
       s.created_by_user_id,
       s.created_at
FROM (SELECT pf.task_id,
             pf.version_start_date,
             pf.version_end_date,
             MAX(pf.modified_by) AS created_by_user_id,
             MIN(pf.created_at)  AS created_at
      FROM prediction_fields pf
      GROUP BY pf.task_id, pf.version_start_date, pf.version_end_date) s
         JOIN tasks t ON t.task_id = s.task_id;

INSERT INTO document_versions (version_id, doc_id, version_number, created_by_user_id, created_at)
SELECT version_id,
       doc_id,
       version_number,
       created_by_user_id,
       created_at
FROM _version_map;

INSERT INTO document_version_tasks (version_id, task_id, created_at)
SELECT version_id, task_id, created_at
FROM _version_map;

INSERT INTO prediction_fields_final (field_id, version_id, parent_field_id, metadata_id, field_key, field_type, value_string,
                                     value_number, value_date, value_bool, modified_by, created_at, updated_at)
SELECT pf.field_id,
       vm.version_id,
       NULL AS parent_field_id,
       pf.metadata_id,
       pf.field_key,
       pf.field_type,
       pf.value_string,
       pf.value_number,
       pf.value_date,
       pf.value_bool,
       pf.modified_by,
       pf.created_at,
       pf.created_at
FROM prediction_fields pf
         JOIN _version_map vm
              ON vm.task_id = pf.task_id
                  AND (vm.version_start_date <=> pf.version_start_date)
                  AND (vm.version_end_date <=> pf.version_end_date);

-- Set parent pointers after all rows exist to satisfy self-FK ordering.
UPDATE prediction_fields_final tgt
JOIN prediction_fields src ON src.field_id = tgt.field_id
SET tgt.parent_field_id = src.parent_field_id;

DROP TEMPORARY TABLE `_version_map`;
DROP TABLE `prediction_fields`;
RENAME TABLE prediction_fields_final TO prediction_fields;

-- Materialize last-version fields into non-versioned document_fields table.
INSERT INTO document_fields (
    field_id, doc_id, parent_field_id, metadata_id, field_key, field_type,
    value_string, value_number, value_date, value_bool, modified_by, created_at, updated_at
)
SELECT pf.field_id,
       dv.doc_id,
       NULL AS parent_field_id,
       pf.metadata_id,
       pf.field_key,
       pf.field_type,
       pf.value_string,
       pf.value_number,
       pf.value_date,
       pf.value_bool,
       pf.modified_by,
       pf.created_at,
       pf.updated_at
FROM prediction_fields pf
JOIN document_versions dv
  ON dv.version_id = pf.version_id
JOIN (
  SELECT doc_id, MAX(version_number) AS max_version_number
  FROM document_versions
  GROUP BY doc_id
) latest
  ON latest.doc_id = dv.doc_id
 AND latest.max_version_number = dv.version_number;

UPDATE document_fields df
JOIN prediction_fields pf ON pf.field_id = df.field_id
SET df.parent_field_id = pf.parent_field_id;

INSERT INTO analytics.document_fields_json (doc_id, fields_json, modified_by, created_at, updated_at) VALUES (0x18034FA5D668438399A6C92ED1350C38, '{"InvoiceArray": [{"amount1": 234}], "InvoiceParent": {"InvoiceNumber": 123}}', 0xB0000001000000000000000000000003, '2025-08-15 09:30:00', '2026-02-26 09:14:35');
INSERT INTO analytics.document_fields_json (doc_id, fields_json, modified_by, created_at, updated_at) VALUES (0x20000000AAAA40008000000000000001, '{"InvoiceArray": {"amount1": 234}, "InvoiceParent": {"InvoiceNumber": 123}}', 0xA0000001000000000000000000000001, '2025-08-10 14:05:01', '2026-02-26 09:10:07');
INSERT INTO analytics.document_fields_json (doc_id, fields_json, modified_by, created_at, updated_at) VALUES (0x20000000BBBB40008000000000000002, '{"InvoiceArray": {"amount2": 123}, "InvoiceParent": {"InvoiceNumber": 123}}', 0xA0000001000000000000000000000001, '2025-08-11 10:35:01', '2026-02-26 09:13:52');



-- -----------------------------------------------
-- 10. Digital Twin – Payment conditions
-- -----------------------------------------------
INSERT INTO dt_payment_conditions (id, name, sconto_percent, sconto_days)
VALUES (UUID_TO_BIN('96977ffe-b4e1-5130-a424-c3193227b298'), '0001 / 10 days due net', 0.0000, 10),
       (UUID_TO_BIN('e47d5db7-57c8-5c48-bca1-0a6d6805019e'), 'VA10 / within 38 days Due net', 0.0000, 38),
       (UUID_TO_BIN('7b7c2f13-8d9d-4d61-9a5a-7d4c2f4ec001'), '2% / 14 days, net 30', 0.0200, 14);


-- -----------------------------------------------
-- 11. Digital Twin – Business partners
-- -----------------------------------------------
INSERT INTO dt_business_partners (id, name, payment_condition_id)
VALUES (UUID_TO_BIN('40000001-0000-4000-8000-000000000001'),
        'Niederlassung Rottenburg/Neckar',
        UUID_TO_BIN('e47d5db7-57c8-5c48-bca1-0a6d6805019e')),
       (UUID_TO_BIN('40000002-0000-4000-8000-000000000002'),
        'Acme Logistics GmbH',
        UUID_TO_BIN('7b7c2f13-8d9d-4d61-9a5a-7d4c2f4ec001'));


-- -----------------------------------------------
-- 11b. Digital Twin – Invoices (linked to documents.external_database_id)
-- -----------------------------------------------
INSERT INTO dt_invoices (id, external_id, business_partner_id, total_amount, invoice_status,
                         posting_date, payment_date, cash_discount_amount, payment_condition_id)
VALUES (UUID_TO_BIN('41000001-0000-4000-8000-000000000001'),
        'ERP-INV-1001', UUID_TO_BIN('40000001-0000-4000-8000-000000000001'),
        8920.50, 'POSTED',
        '2025-08-15 10:00:00', '2025-08-28 12:00:00', 0.00,
        UUID_TO_BIN('e47d5db7-57c8-5c48-bca1-0a6d6805019e')),
       (UUID_TO_BIN('41000001-0000-4000-8000-000000000004'),
        'ERP-INV-1004', UUID_TO_BIN('40000001-0000-4000-8000-000000000001'),
        1540.00, 'POSTED',
        '2025-08-16 09:00:00', '2025-08-25 09:30:00', 0.00,
        UUID_TO_BIN('96977ffe-b4e1-5130-a424-c3193227b298')),
       (UUID_TO_BIN('41000002-0000-4000-8000-000000000001'),
        'ERP-INV-2001', UUID_TO_BIN('40000002-0000-4000-8000-000000000002'),
        2300.75, 'POSTED',
        '2025-08-18 08:10:00', NULL, 0.00,
        UUID_TO_BIN('7b7c2f13-8d9d-4d61-9a5a-7d4c2f4ec001')),
       (UUID_TO_BIN('41000002-0000-4000-8000-000000000003'),
        'ERP-INV-2003', UUID_TO_BIN('40000002-0000-4000-8000-000000000002'),
        6780.10, 'POSTED',
        '2025-08-19 09:20:00', '2025-08-27 16:10:00', 135.60,
        UUID_TO_BIN('7b7c2f13-8d9d-4d61-9a5a-7d4c2f4ec001'));

-- Set ERP references after dt_invoices exists (FK-safe ordering)
UPDATE documents
SET external_database_id = 'ERP-INV-1001'
WHERE doc_id = UUID_TO_BIN('18034fa5-d668-4383-99a6-c92ed1350c38');

UPDATE documents
SET external_database_id = 'ERP-INV-1004'
WHERE doc_id = UUID_TO_BIN('30000000-0001-4000-8000-000000000001');

UPDATE documents
SET external_database_id = 'ERP-INV-2001'
WHERE doc_id = UUID_TO_BIN('30000000-0002-4000-8000-000000000001');

UPDATE documents
SET external_database_id = 'ERP-INV-2003'
WHERE doc_id = UUID_TO_BIN('30000000-0002-4000-8000-000000000003');


-- -----------------------------------------------
-- 12. Digital Twin – Purchase orders
-- -----------------------------------------------
INSERT INTO dt_purchase_orders (id, external_id, purchase_order_type, payment_condition_id)
VALUES (UUID_TO_BIN('50000001-0000-4000-8000-000000000001'),
        'PO-2025-0001', 'NORMAL_ORDER',
        UUID_TO_BIN('96977ffe-b4e1-5130-a424-c3193227b298')),
       (UUID_TO_BIN('50000002-0000-4000-8000-000000000002'),
        'PO-2025-2001', 'SERVICE_ORDER',
        UUID_TO_BIN('7b7c2f13-8d9d-4d61-9a5a-7d4c2f4ec001'));


-- -----------------------------------------------
-- 13. Digital Twin – Delivery notes
-- -----------------------------------------------
INSERT INTO dt_delivery_notes (id, created_at)
VALUES (UUID_TO_BIN('60000001-0000-4000-8000-000000000001'), '2025-08-12 08:00:00'),
       (UUID_TO_BIN('60000002-0000-4000-8000-000000000002'), '2025-08-18 06:30:00');


-- -----------------------------------------------
-- 14. Config key-value
-- -----------------------------------------------
INSERT INTO config_kv (config_id, scope_type, scope_id, config_key, value_type, value_number, updated_at,
                       updated_by_user_id)
VALUES (UUID_TO_BIN('70000001-0000-4000-8000-000000000001'),
        'GLOBAL', NULL, 'low_touch_threshold', 'NUMBER', 0.950000,
        '2025-08-01 00:00:00', NULL),
       (UUID_TO_BIN('70000001-0000-4000-8000-000000000002'),
        'GLOBAL', NULL, 'zero_touch_threshold', 'NUMBER', 0.990000,
        '2025-08-01 00:00:00', NULL),
       (UUID_TO_BIN('70000001-0000-4000-8000-000000000003'),
        'GLOBAL', NULL, 'todo_minutes_constant', 'NUMBER', 5.000000,
        '2025-08-01 00:00:00', NULL);

INSERT INTO config_kv (config_id, scope_type, scope_id, config_key, value_type, value_json, updated_at,
                       updated_by_user_id)
VALUES (UUID_TO_BIN('70000001-0000-4000-8000-000000000004'),
        'ORG', UUID_TO_BIN('661fce72-536e-5719-a014-9ee4dc117508'),
        'reversal_status_set', 'JSON',
        JSON_ARRAY('REVERSED', 'CANCELLED', 'VOIDED'),
        '2025-08-01 00:00:00', NULL);
