-- Clean DDL (DBML aligned). Use this file in docker init.

CREATE TABLE `users`
(
    `user_id`    BINARY(16) NOT NULL,
    `name`       VARCHAR(255),
    `is_machine` BOOLEAN,
    `created_at` DATETIME   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME   NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`user_id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;
CREATE TABLE `documents`
(
    `doc_id`               BINARY(16) NOT NULL,
    `org_id`               BINARY(16) NOT NULL,
    `name`                 VARCHAR(255),
    `document_type`        VARCHAR(64),
    `external_database_id` VARCHAR(128),
    `received_at`          DATETIME,
    `created_at`           DATETIME   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at`           DATETIME   NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`doc_id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;
CREATE TABLE `document_metadata`
(
    `document_metadata_id` BINARY(16)  NOT NULL,
    `doc_id`               BINARY(16)  NOT NULL,
    `category`             VARCHAR(64) NOT NULL,
    `modified_by`          VARCHAR(255),
    `created_by`           VARCHAR(255),
    `updated_by`           VARCHAR(255),
    `created_at`           DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at`           DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`document_metadata_id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;
CREATE TABLE `workflow_instances`
(
    `workflow_instance_id` BINARY(16) NOT NULL,
    `name`                 VARCHAR(255),
    `created_at`           DATETIME   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at`           DATETIME   NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`workflow_instance_id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;
CREATE TABLE `tasks`
(
    `task_id`               BINARY(16) NOT NULL,
    `workflow_instance_id`  BINARY(16),
    `doc_id`                BINARY(16),
    `task_type`             VARCHAR(64),
    `business_process_type` VARCHAR(64),
    `status`                ENUM ('OPEN','DONE','CANCELLED'),
    `start_date`            DATETIME,
    `end_date`              DATETIME,
    `assigned_to_user_id`   BINARY(16),
    `assigned_at`           DATETIME,
    `sla_due_at`            DATETIME,
    `created_at`            DATETIME   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at`            DATETIME   NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`task_id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;
CREATE TABLE `document_versions`
(
    `version_id`         BINARY(16) NOT NULL,
    `doc_id`             BINARY(16) NOT NULL,
    `version_number`     INT        NOT NULL,
    `created_by_user_id` BINARY(16),
    `created_at`         DATETIME   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`version_id`),
    UNIQUE KEY `document_versions_uq_doc_version` (`doc_id`, `version_number`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;
CREATE TABLE `document_version_tasks`
(
    `version_id` BINARY(16) NOT NULL,
    `task_id`    BINARY(16) NOT NULL,
    `created_at` DATETIME   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`version_id`, `task_id`),
    KEY `document_version_tasks_index_task` (`task_id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;
CREATE TABLE `prediction_fields`
(
    `field_id`        BINARY(16)                       NOT NULL,
    `version_id`      BINARY(16)                       NOT NULL,
    `parent_field_id` BINARY(16),
    `metadata_id`     BINARY(16),
    `field_key`       VARCHAR(128),
    `field_type`      ENUM ('OBJECT','ARRAY','SCALAR') NOT NULL,
    `value_string`    TEXT,
    `value_number`    DECIMAL(18, 6),
    `value_date`      DATETIME,
    `value_bool`      BOOLEAN,
    `modified_by`     BINARY(16),
    `created_at`      DATETIME                         NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at`      DATETIME                         NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`field_id`),
    KEY `prediction_fields_index_28` (`field_key`),
    KEY `prediction_fields_index_type` (`version_id`, `field_type`),
    KEY `prediction_fields_index_version_key` (`version_id`, `field_key`),
    KEY `prediction_fields_index_parent` (`parent_field_id`),
    KEY `prediction_fields_index_meta` (`metadata_id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;
CREATE TABLE `document_fields`
(
    `field_id`        BINARY(16)                       NOT NULL,
    `doc_id`          BINARY(16)                       NOT NULL,
    `parent_field_id` BINARY(16),
    `metadata_id`     BINARY(16),
    `field_key`       VARCHAR(128),
    `field_type`      ENUM ('OBJECT','ARRAY','SCALAR') NOT NULL,
    `value_string`    TEXT,
    `value_number`    DECIMAL(18, 6),
    `value_date`      DATETIME,
    `value_bool`      BOOLEAN,
    `modified_by`     BINARY(16),
    `created_at`      DATETIME                         NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at`      DATETIME                         NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`field_id`),
    KEY `document_fields_index_doc` (`doc_id`),
    KEY `document_fields_index_key` (`field_key`),
    KEY `document_fields_index_doc_key` (`doc_id`, `field_key`),
    KEY `document_fields_index_doc_type` (`doc_id`, `field_type`),
    KEY `document_fields_index_parent` (`parent_field_id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;
CREATE TABLE `document_fields_json`
(
    `doc_id`      BINARY(16) NOT NULL,
    `fields_json` JSON,
    `modified_by` BINARY(16),
    `created_at`  DATETIME   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at`  DATETIME   NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`doc_id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;
CREATE TABLE `task_actions`
(
    `action_id`             BINARY(16) NOT NULL,
    `task_id`               BINARY(16),
    `user_id`               BINARY(16),
    `action`                VARCHAR(64),
    `datetime`              DATETIME,
    `external_id`           VARCHAR(128),
    `external_system`       VARCHAR(32),
    `reassign_from_user_id` BINARY(16),
    `reassign_to_user_id`   BINARY(16),
    `reassign_comment`      VARCHAR(255),
    `action_metadata_json`  JSON,
    `created_at`            DATETIME   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at`            DATETIME   NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`action_id`),
    KEY `task_actions_index_14` (`task_id`, `datetime`),
    KEY `task_actions_index_15` (`user_id`, `datetime`),
    KEY `task_actions_index_16` (`action`, `datetime`),
    KEY `task_actions_index_17` (`reassign_to_user_id`, `datetime`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;
CREATE TABLE `task_edits`
(
    `edit_id`    BINARY(16) NOT NULL,
    `task_id`    BINARY(16),
    `user_id`    BINARY(16),
    `datetime`   DATETIME,
    `mode`       ENUM ('GET','EDIT'),
    `edit_type`  VARCHAR(128),
    `edit_value` TEXT,
    `created_at` DATETIME   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME   NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`edit_id`),
    KEY `task_edits_index_18` (`task_id`, `datetime`),
    KEY `task_edits_index_19` (`user_id`, `datetime`),
    KEY `task_edits_index_20` (`mode`, `datetime`),
    KEY `task_edits_index_21` (`edit_type`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;
CREATE TABLE `task_exceptions`
(
    `exception_id`        BINARY(16) NOT NULL,
    `task_id`             BINARY(16),
    `scope`               ENUM ('HEADER','POSITION'),
    `position_type`       VARCHAR(64),
    `position_id`         VARCHAR(128),
    `todo_type`           VARCHAR(128),
    `status`              ENUM ('OPEN','RESOLVED'),
    `created_at`          DATETIME   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at`          DATETIME   NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `resolved_at`         DATETIME,
    `resolved_by_user_id` BINARY(16),
    `deviation_amount`    DECIMAL(18, 2),
    `deviation_percent`   DECIMAL(9, 4),
    `risk_level`          ENUM ('LOW','MEDIUM','HIGH'),
    PRIMARY KEY (`exception_id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;
CREATE TABLE `dt_payment_conditions`
(
    `id`             BINARY(16) NOT NULL,
    `name`           VARCHAR(255),
    `sconto_percent` DECIMAL(9, 4),
    `sconto_days`    INT,
    `created_at`     DATETIME   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at`     DATETIME   NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;
CREATE TABLE `dt_business_partners`
(
    `id`                   BINARY(16) NOT NULL,
    `name`                 VARCHAR(255),
    `payment_condition_id` BINARY(16),
    `created_at`           DATETIME   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at`           DATETIME   NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `dt_business_partners_index_30` (`payment_condition_id`),
    KEY `dt_business_partners_index_31` (`name`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;
CREATE TABLE `dt_invoices`
(
    `id`                   BINARY(16) NOT NULL,
    `external_id`          VARCHAR(128),
    `business_partner_id`  BINARY(16),
    `total_amount`         DECIMAL(18, 2),
    `invoice_status`       VARCHAR(64),
    `posting_date`         DATETIME,
    `payment_date`         DATETIME,
    `cash_discount_amount` DECIMAL(18, 2),
    `payment_condition_id` BINARY(16),
    `created_at`           DATETIME   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at`           DATETIME   NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `dt_invoices_index_32` (`external_id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;
CREATE TABLE `dt_purchase_orders`
(
    `id`                   BINARY(16) NOT NULL,
    `external_id`          VARCHAR(128),
    `purchase_order_type`  ENUM ('NORMAL_ORDER','BLANKET_ORDER','BUDGET_ORDER','CONTRACT_ORDER','SCHEDULING_AGREEMENT','SERVICE_ORDER','CONSIGNMENT_STOCK_ORDER','FREIGHT_ORDER'),
    `payment_condition_id` BINARY(16),
    `created_at`           DATETIME   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at`           DATETIME   NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;
CREATE TABLE `dt_delivery_notes`
(
    `id`         BINARY(16) NOT NULL,
    `created_at` DATETIME   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME   NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;
CREATE TABLE `config_kv`
(
    `config_id`          BINARY(16) NOT NULL,
    `scope_type`         ENUM ('GLOBAL','ORG','WORKFLOW','DASHBOARD','KPI'),
    `scope_id`           BINARY(16),
    `config_key`         VARCHAR(128),
    `value_type`         ENUM ('STRING','NUMBER','BOOL','JSON','DATE'),
    `value_string`       TEXT,
    `value_number`       DECIMAL(18, 6),
    `value_bool`         BOOLEAN,
    `value_json`         JSON,
    `value_date`         DATETIME,
    `created_at`         DATETIME   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at`         DATETIME   NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `updated_by_user_id` BINARY(16),
    PRIMARY KEY (`config_id`),
    UNIQUE KEY `config_kv_index_42` (`scope_type`, `scope_id`, `config_key`),
    KEY `config_kv_index_43` (`config_key`),
    KEY `config_kv_index_44` (`updated_at`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

ALTER TABLE `document_metadata`
    ADD CONSTRAINT `fk_dm_doc` FOREIGN KEY (`doc_id`) REFERENCES `documents` (`doc_id`);
ALTER TABLE `tasks`
    ADD CONSTRAINT `fk_tasks_wf` FOREIGN KEY (`workflow_instance_id`) REFERENCES `workflow_instances` (`workflow_instance_id`);
ALTER TABLE `tasks`
    ADD CONSTRAINT `fk_tasks_doc` FOREIGN KEY (`doc_id`) REFERENCES `documents` (`doc_id`);
ALTER TABLE `tasks`
    ADD CONSTRAINT `fk_tasks_user` FOREIGN KEY (`assigned_to_user_id`) REFERENCES `users` (`user_id`);
ALTER TABLE `document_versions`
    ADD CONSTRAINT `fk_dv_doc` FOREIGN KEY (`doc_id`) REFERENCES `documents` (`doc_id`);
ALTER TABLE `document_versions`
    ADD CONSTRAINT `fk_dv_created_by` FOREIGN KEY (`created_by_user_id`) REFERENCES `users` (`user_id`);
ALTER TABLE `document_version_tasks`
    ADD CONSTRAINT `fk_dvt_version` FOREIGN KEY (`version_id`) REFERENCES `document_versions` (`version_id`);
ALTER TABLE `document_version_tasks`
    ADD CONSTRAINT `fk_dvt_task` FOREIGN KEY (`task_id`) REFERENCES `tasks` (`task_id`);
ALTER TABLE `prediction_fields`
    ADD CONSTRAINT `fk_pf_version` FOREIGN KEY (`version_id`) REFERENCES `document_versions` (`version_id`);
ALTER TABLE `prediction_fields`
    ADD CONSTRAINT `fk_pf_parent` FOREIGN KEY (`parent_field_id`) REFERENCES `prediction_fields` (`field_id`);
ALTER TABLE `prediction_fields`
    ADD CONSTRAINT `fk_pf_modified_by` FOREIGN KEY (`modified_by`) REFERENCES `users` (`user_id`);
ALTER TABLE `document_fields`
    ADD CONSTRAINT `fk_df_doc` FOREIGN KEY (`doc_id`) REFERENCES `documents` (`doc_id`);
ALTER TABLE `document_fields`
    ADD CONSTRAINT `fk_df_parent` FOREIGN KEY (`parent_field_id`) REFERENCES `document_fields` (`field_id`);
ALTER TABLE `document_fields`
    ADD CONSTRAINT `fk_df_modified_by` FOREIGN KEY (`modified_by`) REFERENCES `users` (`user_id`);
ALTER TABLE `document_fields_json`
    ADD CONSTRAINT `fk_dfj_doc` FOREIGN KEY (`doc_id`) REFERENCES `documents` (`doc_id`);
ALTER TABLE `document_fields_json`
    ADD CONSTRAINT `fk_dfj_modified_by` FOREIGN KEY (`modified_by`) REFERENCES `users` (`user_id`);
ALTER TABLE `task_actions`
    ADD CONSTRAINT `fk_ta_task` FOREIGN KEY (`task_id`) REFERENCES `tasks` (`task_id`);
ALTER TABLE `task_actions`
    ADD CONSTRAINT `fk_ta_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);
ALTER TABLE `task_actions`
    ADD CONSTRAINT `fk_ta_from_user` FOREIGN KEY (`reassign_from_user_id`) REFERENCES `users` (`user_id`);
ALTER TABLE `task_actions`
    ADD CONSTRAINT `fk_ta_to_user` FOREIGN KEY (`reassign_to_user_id`) REFERENCES `users` (`user_id`);
ALTER TABLE `task_edits`
    ADD CONSTRAINT `fk_te_task` FOREIGN KEY (`task_id`) REFERENCES `tasks` (`task_id`);
ALTER TABLE `task_edits`
    ADD CONSTRAINT `fk_te_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);
ALTER TABLE `task_exceptions`
    ADD CONSTRAINT `fk_tex_task` FOREIGN KEY (`task_id`) REFERENCES `tasks` (`task_id`);
ALTER TABLE `task_exceptions`
    ADD CONSTRAINT `fk_tex_resolver` FOREIGN KEY (`resolved_by_user_id`) REFERENCES `users` (`user_id`);
ALTER TABLE `dt_business_partners`
    ADD CONSTRAINT `fk_dtbp_pc` FOREIGN KEY (`payment_condition_id`) REFERENCES `dt_payment_conditions` (`id`);
ALTER TABLE `dt_invoices`
    ADD CONSTRAINT `fk_dti_bp` FOREIGN KEY (`business_partner_id`) REFERENCES `dt_business_partners` (`id`);
ALTER TABLE `dt_invoices`
    ADD CONSTRAINT `fk_dti_pc` FOREIGN KEY (`payment_condition_id`) REFERENCES `dt_payment_conditions` (`id`);
ALTER TABLE `dt_purchase_orders`
    ADD CONSTRAINT `fk_dtpo_pc` FOREIGN KEY (`payment_condition_id`) REFERENCES `dt_payment_conditions` (`id`);
ALTER TABLE `documents`
    ADD CONSTRAINT `fk_docs_ext_inv` FOREIGN KEY (`external_database_id`) REFERENCES `dt_invoices` (`external_id`);
ALTER TABLE `config_kv`
    ADD CONSTRAINT `fk_cfg_user` FOREIGN KEY (`updated_by_user_id`) REFERENCES `users` (`user_id`);
