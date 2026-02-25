-- BLP Analytics KPI Model – DDL (DBML aligned)

CREATE TABLE `users` (
  `user_id` BINARY(16) NOT NULL,
  `name` VARCHAR(255),
  `is_machine` BOOLEAN,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `documents` (
  `doc_id` BINARY(16) NOT NULL,
  `org_id` BINARY(16) NOT NULL,
  `name` VARCHAR(255),
  `document_type` VARCHAR(64),
  `external_database_id` VARCHAR(128),
  `received_at` DATETIME,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`doc_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `document_metadata` (
  `document_metadata_id` BINARY(16) NOT NULL,
  `doc_id` BINARY(16) NOT NULL,
  `category` VARCHAR(64) NOT NULL,
  `modified_by` VARCHAR(255),
  `created_by` VARCHAR(255),
  `updated_by` VARCHAR(255),
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`document_metadata_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `workflow_instances` (
  `workflow_instance_id` BINARY(16) NOT NULL,
  `name` VARCHAR(255),
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`workflow_instance_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `tasks` (
  `task_id` BINARY(16) NOT NULL,
  `workflow_instance_id` BINARY(16),
  `doc_id` BINARY(16),
  `task_type` VARCHAR(64),
  `business_process_type` VARCHAR(64),
  `status` ENUM('OPEN','DONE','CANCELLED'),
  `start_date` DATETIME,
  `end_date` DATETIME,
  `assigned_to_user_id` BINARY(16),
  `assigned_at` DATETIME,
  `sla_due_at` DATETIME,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`task_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `document_versions` (
  `version_id` BINARY(16) NOT NULL,
  `doc_id` BINARY(16) NOT NULL,
  `task_id` BINARY(16),
  `version_number` INT NOT NULL,
  `created_by_user_id` BINARY(16),
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `prediction_fields` (
  `field_id` BINARY(16) NOT NULL,
  `version_id` BINARY(16) NOT NULL,
  `parent_field_id` BINARY(16),
  `metadata_id` BINARY(16),
  `field_key` VARCHAR(128),
  `field_type` ENUM('OBJECT','ARRAY','SCALAR') NOT NULL,
  `value_string` TEXT,
  `value_number` DECIMAL(18,6),
  `value_date` DATETIME,
  `value_bool` BOOLEAN,
  `modified_by` BINARY(16),
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`field_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `task_actions` (
  `action_id` BINARY(16) NOT NULL,
  `task_id` BINARY(16),
  `user_id` BINARY(16),
  `action` VARCHAR(64),
  `datetime` DATETIME,
  `external_id` VARCHAR(128),
  `external_system` VARCHAR(32),
  `reassign_from_user_id` BINARY(16),
  `reassign_to_user_id` BINARY(16),
  `reassign_comment` VARCHAR(255),
  `action_metadata_json` JSON,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`action_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `task_edits` (
  `edit_id` BINARY(16) NOT NULL,
  `task_id` BINARY(16),
  `user_id` BINARY(16),
  `datetime` DATETIME,
  `mode` ENUM('GET','EDIT'),
  `edit_type` VARCHAR(128),
  `edit_value` TEXT,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`edit_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `task_exceptions` (
  `exception_id` BINARY(16) NOT NULL,
  `task_id` BINARY(16),
  `scope` ENUM('HEADER','POSITION'),
  `position_type` VARCHAR(64),
  `position_id` VARCHAR(128),
  `todo_type` VARCHAR(128),
  `status` ENUM('OPEN','RESOLVED'),
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `resolved_at` DATETIME,
  `resolved_by_user_id` BINARY(16),
  `deviation_amount` DECIMAL(18,2),
  `deviation_percent` DECIMAL(9,4),
  `risk_level` ENUM('LOW','MEDIUM','HIGH'),
  PRIMARY KEY (`exception_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `dt_payment_conditions` (`id` BINARY(16) NOT NULL, `name` VARCHAR(255), `sconto_percent` DECIMAL(9,4), `sconto_days` INT, `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, PRIMARY KEY (`id`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE `dt_business_partners` (`id` BINARY(16) NOT NULL, `name` VARCHAR(255), `payment_condition_id` BINARY(16), `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, PRIMARY KEY (`id`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE `dt_invoices` (`id` BINARY(16) NOT NULL, `external_id` VARCHAR(128), `business_partner_id` BINARY(16), `total_amount` DECIMAL(18,2), `invoice_status` VARCHAR(64), `posting_date` DATETIME, `payment_date` DATETIME, `cash_discount_amount` DECIMAL(18,2), `payment_condition_id` BINARY(16), `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, PRIMARY KEY (`id`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE `dt_purchase_orders` (`id` BINARY(16) NOT NULL, `external_id` VARCHAR(128), `purchase_order_type` ENUM('NORMAL_ORDER','BLANKET_ORDER','BUDGET_ORDER','CONTRACT_ORDER','SCHEDULING_AGREEMENT','SERVICE_ORDER','CONSIGNMENT_STOCK_ORDER','FREIGHT_ORDER'), `payment_condition_id` BINARY(16), `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, PRIMARY KEY (`id`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE `dt_delivery_notes` (`id` BINARY(16) NOT NULL, `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, PRIMARY KEY (`id`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE `config_kv` (`config_id` BINARY(16) NOT NULL, `scope_type` ENUM('GLOBAL','ORG','WORKFLOW','DASHBOARD','KPI'), `scope_id` BINARY(16), `config_key` VARCHAR(128), `value_type` ENUM('STRING','NUMBER','BOOL','JSON','DATE'), `value_string` TEXT, `value_number` DECIMAL(18,6), `value_bool` BOOLEAN, `value_json` JSON, `value_date` DATETIME, `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, `updated_by_user_id` BINARY(16), PRIMARY KEY (`config_id`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE INDEX `users_index_0` ON `users` (`is_machine`);
CREATE INDEX `users_index_1` ON `users` (`name`);
CREATE INDEX `documents_index_org` ON `documents` (`org_id`);
CREATE INDEX `documents_index_org_type` ON `documents` (`org_id`,`document_type`);
CREATE INDEX `documents_index_2` ON `documents` (`document_type`);
CREATE INDEX `documents_index_3` ON `documents` (`external_database_id`);
CREATE INDEX `documents_index_4` ON `documents` (`received_at`);
CREATE INDEX `document_metadata_index_doc` ON `document_metadata` (`doc_id`);
CREATE INDEX `document_metadata_index_category` ON `document_metadata` (`category`);
CREATE INDEX `tasks_index_5` ON `tasks` (`workflow_instance_id`);
CREATE INDEX `tasks_index_6` ON `tasks` (`doc_id`);
CREATE INDEX `tasks_index_7` ON `tasks` (`status`);
CREATE INDEX `tasks_index_8` ON `tasks` (`task_type`);
CREATE INDEX `tasks_index_9` ON `tasks` (`business_process_type`);
CREATE INDEX `tasks_index_10` ON `tasks` (`assigned_to_user_id`,`status`);
CREATE INDEX `tasks_index_11` ON `tasks` (`doc_id`,`start_date`);
CREATE INDEX `tasks_index_12` ON `tasks` (`start_date`);
CREATE INDEX `tasks_index_13` ON `tasks` (`end_date`);
CREATE UNIQUE INDEX `document_versions_uq_doc_version` ON `document_versions` (`doc_id`,`version_number`);
CREATE INDEX `document_versions_index_task` ON `document_versions` (`task_id`);
CREATE INDEX `prediction_fields_index_28` ON `prediction_fields` (`field_key`);
CREATE INDEX `prediction_fields_index_type` ON `prediction_fields` (`version_id`,`field_type`);
CREATE INDEX `prediction_fields_index_version_key` ON `prediction_fields` (`version_id`,`field_key`);
CREATE INDEX `prediction_fields_index_parent` ON `prediction_fields` (`parent_field_id`);
CREATE INDEX `prediction_fields_index_meta` ON `prediction_fields` (`metadata_id`);
CREATE INDEX `task_actions_index_14` ON `task_actions` (`task_id`,`datetime`);
CREATE INDEX `task_actions_index_15` ON `task_actions` (`user_id`,`datetime`);
CREATE INDEX `task_actions_index_16` ON `task_actions` (`action`,`datetime`);
CREATE INDEX `task_actions_index_17` ON `task_actions` (`reassign_to_user_id`,`datetime`);
CREATE INDEX `task_edits_index_18` ON `task_edits` (`task_id`,`datetime`);
CREATE INDEX `task_edits_index_19` ON `task_edits` (`user_id`,`datetime`);
CREATE INDEX `task_edits_index_20` ON `task_edits` (`mode`,`datetime`);
CREATE INDEX `task_edits_index_21` ON `task_edits` (`edit_type`);
CREATE INDEX `dt_payment_conditions_index_29` ON `dt_payment_conditions` (`name`);
CREATE INDEX `dt_business_partners_index_30` ON `dt_business_partners` (`payment_condition_id`);
CREATE INDEX `dt_business_partners_index_31` ON `dt_business_partners` (`name`);
CREATE UNIQUE INDEX `dt_invoices_index_32` ON `dt_invoices` (`external_id`);
CREATE UNIQUE INDEX `config_kv_index_42` ON `config_kv` (`scope_type`,`scope_id`,`config_key`);
CREATE INDEX `config_kv_index_43` ON `config_kv` (`config_key`);
CREATE INDEX `config_kv_index_44` ON `config_kv` (`updated_at`);

ALTER TABLE `document_metadata` ADD CONSTRAINT `fk_dm_doc` FOREIGN KEY (`doc_id`) REFERENCES `documents` (`doc_id`);
ALTER TABLE `tasks` ADD CONSTRAINT `fk_tasks_wf` FOREIGN KEY (`workflow_instance_id`) REFERENCES `workflow_instances` (`workflow_instance_id`);
ALTER TABLE `tasks` ADD CONSTRAINT `fk_tasks_doc` FOREIGN KEY (`doc_id`) REFERENCES `documents` (`doc_id`);
ALTER TABLE `tasks` ADD CONSTRAINT `fk_tasks_user` FOREIGN KEY (`assigned_to_user_id`) REFERENCES `users` (`user_id`);
ALTER TABLE `document_versions` ADD CONSTRAINT `fk_dv_doc` FOREIGN KEY (`doc_id`) REFERENCES `documents` (`doc_id`);
ALTER TABLE `document_versions` ADD CONSTRAINT `fk_dv_task` FOREIGN KEY (`task_id`) REFERENCES `tasks` (`task_id`);
ALTER TABLE `document_versions` ADD CONSTRAINT `fk_dv_created_by` FOREIGN KEY (`created_by_user_id`) REFERENCES `users` (`user_id`);
ALTER TABLE `prediction_fields` ADD CONSTRAINT `fk_pf_version` FOREIGN KEY (`version_id`) REFERENCES `document_versions` (`version_id`);
ALTER TABLE `prediction_fields` ADD CONSTRAINT `fk_pf_parent` FOREIGN KEY (`parent_field_id`) REFERENCES `prediction_fields` (`field_id`);
ALTER TABLE `prediction_fields` ADD CONSTRAINT `fk_pf_modified_by` FOREIGN KEY (`modified_by`) REFERENCES `users` (`user_id`);
ALTER TABLE `task_actions` ADD CONSTRAINT `fk_ta_task` FOREIGN KEY (`task_id`) REFERENCES `tasks` (`task_id`);
ALTER TABLE `task_actions` ADD CONSTRAINT `fk_ta_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);
ALTER TABLE `task_actions` ADD CONSTRAINT `fk_ta_from_user` FOREIGN KEY (`reassign_from_user_id`) REFERENCES `users` (`user_id`);
ALTER TABLE `task_actions` ADD CONSTRAINT `fk_ta_to_user` FOREIGN KEY (`reassign_to_user_id`) REFERENCES `users` (`user_id`);
ALTER TABLE `task_edits` ADD CONSTRAINT `fk_te_task` FOREIGN KEY (`task_id`) REFERENCES `tasks` (`task_id`);
ALTER TABLE `task_edits` ADD CONSTRAINT `fk_te_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);
ALTER TABLE `task_exceptions` ADD CONSTRAINT `fk_tex_task` FOREIGN KEY (`task_id`) REFERENCES `tasks` (`task_id`);
ALTER TABLE `task_exceptions` ADD CONSTRAINT `fk_tex_resolver` FOREIGN KEY (`resolved_by_user_id`) REFERENCES `users` (`user_id`);
ALTER TABLE `dt_business_partners` ADD CONSTRAINT `fk_dtbp_pc` FOREIGN KEY (`payment_condition_id`) REFERENCES `dt_payment_conditions` (`id`);
ALTER TABLE `dt_invoices` ADD CONSTRAINT `fk_dti_bp` FOREIGN KEY (`business_partner_id`) REFERENCES `dt_business_partners` (`id`);
ALTER TABLE `dt_invoices` ADD CONSTRAINT `fk_dti_pc` FOREIGN KEY (`payment_condition_id`) REFERENCES `dt_payment_conditions` (`id`);
ALTER TABLE `dt_purchase_orders` ADD CONSTRAINT `fk_dtpo_pc` FOREIGN KEY (`payment_condition_id`) REFERENCES `dt_payment_conditions` (`id`);
ALTER TABLE `documents` ADD CONSTRAINT `fk_docs_ext_inv` FOREIGN KEY (`external_database_id`) REFERENCES `dt_invoices` (`external_id`);
ALTER TABLE `config_kv` ADD CONSTRAINT `fk_cfg_user` FOREIGN KEY (`updated_by_user_id`) REFERENCES `users` (`user_id`);
-- BLP Analytics KPI Model – DDL (DBML-aligned)

CREATE TABLE `users` (`user_id` BINARY(16) NOT NULL, `name` VARCHAR(255), `is_machine` BOOLEAN, `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, PRIMARY KEY (`user_id`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE `documents` (`doc_id` BINARY(16) NOT NULL, `org_id` BINARY(16) NOT NULL, `name` VARCHAR(255), `document_type` VARCHAR(64), `external_database_id` VARCHAR(128), `received_at` DATETIME, `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, PRIMARY KEY (`doc_id`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE `document_metadata` (`document_metadata_id` BINARY(16) NOT NULL, `doc_id` BINARY(16) NOT NULL, `category` VARCHAR(64) NOT NULL, `modified_by` VARCHAR(255), `created_by` VARCHAR(255), `updated_by` VARCHAR(255), `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, PRIMARY KEY (`document_metadata_id`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE `workflow_instances` (`workflow_instance_id` BINARY(16) NOT NULL, `name` VARCHAR(255), `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, PRIMARY KEY (`workflow_instance_id`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE `tasks` (`task_id` BINARY(16) NOT NULL, `workflow_instance_id` BINARY(16), `doc_id` BINARY(16), `task_type` VARCHAR(64), `business_process_type` VARCHAR(64), `status` ENUM('OPEN','DONE','CANCELLED'), `start_date` DATETIME, `end_date` DATETIME, `assigned_to_user_id` BINARY(16), `assigned_at` DATETIME, `sla_due_at` DATETIME, `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, PRIMARY KEY (`task_id`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE `document_versions` (`version_id` BINARY(16) NOT NULL, `doc_id` BINARY(16) NOT NULL, `task_id` BINARY(16), `version_number` INT NOT NULL, `created_by_user_id` BINARY(16), `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, PRIMARY KEY (`version_id`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE `prediction_fields` (`field_id` BINARY(16) NOT NULL, `version_id` BINARY(16) NOT NULL, `parent_field_id` BINARY(16), `metadata_id` BINARY(16), `field_key` VARCHAR(128), `field_type` ENUM('OBJECT','ARRAY','SCALAR') NOT NULL, `value_string` TEXT, `value_number` DECIMAL(18,6), `value_date` DATETIME, `value_bool` BOOLEAN, `modified_by` BINARY(16), `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, PRIMARY KEY (`field_id`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE `task_actions` (`action_id` BINARY(16) NOT NULL, `task_id` BINARY(16), `user_id` BINARY(16), `action` VARCHAR(64), `datetime` DATETIME, `external_id` VARCHAR(128), `external_system` VARCHAR(32), `reassign_from_user_id` BINARY(16), `reassign_to_user_id` BINARY(16), `reassign_comment` VARCHAR(255), `action_metadata_json` JSON, `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, PRIMARY KEY (`action_id`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE `task_edits` (`edit_id` BINARY(16) NOT NULL, `task_id` BINARY(16), `user_id` BINARY(16), `datetime` DATETIME, `mode` ENUM('GET','EDIT'), `edit_type` VARCHAR(128), `edit_value` TEXT, `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, PRIMARY KEY (`edit_id`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE `task_exceptions` (`exception_id` BINARY(16) NOT NULL, `task_id` BINARY(16), `scope` ENUM('HEADER','POSITION'), `position_type` VARCHAR(64), `position_id` VARCHAR(128), `todo_type` VARCHAR(128), `status` ENUM('OPEN','RESOLVED'), `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, `resolved_at` DATETIME, `resolved_by_user_id` BINARY(16), `deviation_amount` DECIMAL(18,2), `deviation_percent` DECIMAL(9,4), `risk_level` ENUM('LOW','MEDIUM','HIGH'), PRIMARY KEY (`exception_id`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE `dt_payment_conditions` (`id` BINARY(16) NOT NULL, `name` VARCHAR(255), `sconto_percent` DECIMAL(9,4), `sconto_days` INT, `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, PRIMARY KEY (`id`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE `dt_business_partners` (`id` BINARY(16) NOT NULL, `name` VARCHAR(255), `payment_condition_id` BINARY(16), `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, PRIMARY KEY (`id`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE `dt_invoices` (`id` BINARY(16) NOT NULL, `external_id` VARCHAR(128), `business_partner_id` BINARY(16), `total_amount` DECIMAL(18,2), `invoice_status` VARCHAR(64), `posting_date` DATETIME, `payment_date` DATETIME, `cash_discount_amount` DECIMAL(18,2), `payment_condition_id` BINARY(16), `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, PRIMARY KEY (`id`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE `dt_purchase_orders` (`id` BINARY(16) NOT NULL, `external_id` VARCHAR(128), `purchase_order_type` ENUM('NORMAL_ORDER','BLANKET_ORDER','BUDGET_ORDER','CONTRACT_ORDER','SCHEDULING_AGREEMENT','SERVICE_ORDER','CONSIGNMENT_STOCK_ORDER','FREIGHT_ORDER'), `payment_condition_id` BINARY(16), `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, PRIMARY KEY (`id`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE `dt_delivery_notes` (`id` BINARY(16) NOT NULL, `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, PRIMARY KEY (`id`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE `config_kv` (`config_id` BINARY(16) NOT NULL, `scope_type` ENUM('GLOBAL','ORG','WORKFLOW','DASHBOARD','KPI'), `scope_id` BINARY(16), `config_key` VARCHAR(128), `value_type` ENUM('STRING','NUMBER','BOOL','JSON','DATE'), `value_string` TEXT, `value_number` DECIMAL(18,6), `value_bool` BOOLEAN, `value_json` JSON, `value_date` DATETIME, `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, `updated_by_user_id` BINARY(16), PRIMARY KEY (`config_id`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE INDEX `users_index_0` ON `users` (`is_machine`);
CREATE INDEX `users_index_1` ON `users` (`name`);
CREATE INDEX `documents_index_org` ON `documents` (`org_id`);
CREATE INDEX `documents_index_org_type` ON `documents` (`org_id`,`document_type`);
CREATE INDEX `documents_index_2` ON `documents` (`document_type`);
CREATE INDEX `documents_index_3` ON `documents` (`external_database_id`);
CREATE INDEX `documents_index_4` ON `documents` (`received_at`);
CREATE INDEX `document_metadata_index_doc` ON `document_metadata` (`doc_id`);
CREATE INDEX `document_metadata_index_category` ON `document_metadata` (`category`);
CREATE INDEX `tasks_index_5` ON `tasks` (`workflow_instance_id`);
CREATE INDEX `tasks_index_6` ON `tasks` (`doc_id`);
CREATE INDEX `tasks_index_7` ON `tasks` (`status`);
CREATE INDEX `tasks_index_8` ON `tasks` (`task_type`);
CREATE INDEX `tasks_index_9` ON `tasks` (`business_process_type`);
CREATE INDEX `tasks_index_10` ON `tasks` (`assigned_to_user_id`,`status`);
CREATE INDEX `tasks_index_11` ON `tasks` (`doc_id`,`start_date`);
CREATE INDEX `tasks_index_12` ON `tasks` (`start_date`);
CREATE INDEX `tasks_index_13` ON `tasks` (`end_date`);
CREATE UNIQUE INDEX `document_versions_uq_doc_version` ON `document_versions` (`doc_id`,`version_number`);
CREATE INDEX `document_versions_index_task` ON `document_versions` (`task_id`);
CREATE INDEX `prediction_fields_index_28` ON `prediction_fields` (`field_key`);
CREATE INDEX `prediction_fields_index_type` ON `prediction_fields` (`version_id`,`field_type`);
CREATE INDEX `prediction_fields_index_version_key` ON `prediction_fields` (`version_id`,`field_key`);
CREATE INDEX `prediction_fields_index_parent` ON `prediction_fields` (`parent_field_id`);
CREATE INDEX `prediction_fields_index_meta` ON `prediction_fields` (`metadata_id`);
CREATE INDEX `task_actions_index_14` ON `task_actions` (`task_id`,`datetime`);
CREATE INDEX `task_actions_index_15` ON `task_actions` (`user_id`,`datetime`);
CREATE INDEX `task_actions_index_16` ON `task_actions` (`action`,`datetime`);
CREATE INDEX `task_actions_index_17` ON `task_actions` (`reassign_to_user_id`,`datetime`);
CREATE INDEX `task_edits_index_18` ON `task_edits` (`task_id`,`datetime`);
CREATE INDEX `task_edits_index_19` ON `task_edits` (`user_id`,`datetime`);
CREATE INDEX `task_edits_index_20` ON `task_edits` (`mode`,`datetime`);
CREATE INDEX `task_edits_index_21` ON `task_edits` (`edit_type`);
CREATE INDEX `dt_payment_conditions_index_29` ON `dt_payment_conditions` (`name`);
CREATE INDEX `dt_business_partners_index_30` ON `dt_business_partners` (`payment_condition_id`);
CREATE INDEX `dt_business_partners_index_31` ON `dt_business_partners` (`name`);
CREATE UNIQUE INDEX `dt_invoices_index_32` ON `dt_invoices` (`external_id`);
CREATE UNIQUE INDEX `config_kv_index_42` ON `config_kv` (`scope_type`,`scope_id`,`config_key`);
CREATE INDEX `config_kv_index_43` ON `config_kv` (`config_key`);
CREATE INDEX `config_kv_index_44` ON `config_kv` (`updated_at`);

ALTER TABLE `document_metadata` ADD CONSTRAINT `fk_dm_doc` FOREIGN KEY (`doc_id`) REFERENCES `documents` (`doc_id`);
ALTER TABLE `tasks` ADD CONSTRAINT `fk_tasks_wf` FOREIGN KEY (`workflow_instance_id`) REFERENCES `workflow_instances` (`workflow_instance_id`);
ALTER TABLE `tasks` ADD CONSTRAINT `fk_tasks_doc` FOREIGN KEY (`doc_id`) REFERENCES `documents` (`doc_id`);
ALTER TABLE `tasks` ADD CONSTRAINT `fk_tasks_user` FOREIGN KEY (`assigned_to_user_id`) REFERENCES `users` (`user_id`);
ALTER TABLE `document_versions` ADD CONSTRAINT `fk_dv_doc` FOREIGN KEY (`doc_id`) REFERENCES `documents` (`doc_id`);
ALTER TABLE `document_versions` ADD CONSTRAINT `fk_dv_task` FOREIGN KEY (`task_id`) REFERENCES `tasks` (`task_id`);
ALTER TABLE `document_versions` ADD CONSTRAINT `fk_dv_created_by` FOREIGN KEY (`created_by_user_id`) REFERENCES `users` (`user_id`);
ALTER TABLE `prediction_fields` ADD CONSTRAINT `fk_pf_version` FOREIGN KEY (`version_id`) REFERENCES `document_versions` (`version_id`);
ALTER TABLE `prediction_fields` ADD CONSTRAINT `fk_pf_parent` FOREIGN KEY (`parent_field_id`) REFERENCES `prediction_fields` (`field_id`);
ALTER TABLE `prediction_fields` ADD CONSTRAINT `fk_pf_modified_by` FOREIGN KEY (`modified_by`) REFERENCES `users` (`user_id`);
ALTER TABLE `task_actions` ADD CONSTRAINT `fk_ta_task` FOREIGN KEY (`task_id`) REFERENCES `tasks` (`task_id`);
ALTER TABLE `task_actions` ADD CONSTRAINT `fk_ta_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);
ALTER TABLE `task_actions` ADD CONSTRAINT `fk_ta_from_user` FOREIGN KEY (`reassign_from_user_id`) REFERENCES `users` (`user_id`);
ALTER TABLE `task_actions` ADD CONSTRAINT `fk_ta_to_user` FOREIGN KEY (`reassign_to_user_id`) REFERENCES `users` (`user_id`);
ALTER TABLE `task_edits` ADD CONSTRAINT `fk_te_task` FOREIGN KEY (`task_id`) REFERENCES `tasks` (`task_id`);
ALTER TABLE `task_edits` ADD CONSTRAINT `fk_te_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);
ALTER TABLE `task_exceptions` ADD CONSTRAINT `fk_tex_task` FOREIGN KEY (`task_id`) REFERENCES `tasks` (`task_id`);
ALTER TABLE `task_exceptions` ADD CONSTRAINT `fk_tex_resolver` FOREIGN KEY (`resolved_by_user_id`) REFERENCES `users` (`user_id`);
ALTER TABLE `dt_business_partners` ADD CONSTRAINT `fk_dtbp_pc` FOREIGN KEY (`payment_condition_id`) REFERENCES `dt_payment_conditions` (`id`);
ALTER TABLE `dt_invoices` ADD CONSTRAINT `fk_dti_bp` FOREIGN KEY (`business_partner_id`) REFERENCES `dt_business_partners` (`id`);
ALTER TABLE `dt_invoices` ADD CONSTRAINT `fk_dti_pc` FOREIGN KEY (`payment_condition_id`) REFERENCES `dt_payment_conditions` (`id`);
ALTER TABLE `dt_purchase_orders` ADD CONSTRAINT `fk_dtpo_pc` FOREIGN KEY (`payment_condition_id`) REFERENCES `dt_payment_conditions` (`id`);
ALTER TABLE `documents` ADD CONSTRAINT `fk_docs_ext_inv` FOREIGN KEY (`external_database_id`) REFERENCES `dt_invoices` (`external_id`);
ALTER TABLE `config_kv` ADD CONSTRAINT `fk_cfg_user` FOREIGN KEY (`updated_by_user_id`) REFERENCES `users` (`user_id`);
-- ============================================================
-- BLP Analytics KPI Model – DDL
-- Aligned to current DBML contract
-- ============================================================

CREATE TABLE `users` (`user_id` BINARY(16) NOT NULL, `name` VARCHAR(255), `is_machine` BOOLEAN,
                      `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                      `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                      PRIMARY KEY (`user_id`)) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

CREATE TABLE `documents` (`doc_id` BINARY(16) NOT NULL, `org_id` BINARY(16) NOT NULL, `name` VARCHAR(255),
                          `document_type` VARCHAR(64), `external_database_id` VARCHAR(128), `received_at` DATETIME,
                          `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                          `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                          PRIMARY KEY (`doc_id`)) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

CREATE TABLE `document_metadata` (`document_metadata_id` BINARY(16) NOT NULL, `doc_id` BINARY(16) NOT NULL,
                                  `category` VARCHAR(64) NOT NULL, `modified_by` VARCHAR(255), `created_by` VARCHAR(255),
                                  `updated_by` VARCHAR(255), `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                                  PRIMARY KEY (`document_metadata_id`)) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

CREATE TABLE `workflow_instances` (`workflow_instance_id` BINARY(16) NOT NULL, `name` VARCHAR(255),
                                   `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                   `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                                   PRIMARY KEY (`workflow_instance_id`)) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

CREATE TABLE `tasks` (`task_id` BINARY(16) NOT NULL, `workflow_instance_id` BINARY(16), `doc_id` BINARY(16),
                      `task_type` VARCHAR(64), `business_process_type` VARCHAR(64),
                      `status` ENUM ('OPEN', 'DONE', 'CANCELLED'),
                      `start_date` DATETIME, `end_date` DATETIME, `assigned_to_user_id` BINARY(16),
                      `assigned_at` DATETIME, `sla_due_at` DATETIME,
                      `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                      `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                      PRIMARY KEY (`task_id`)) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

CREATE TABLE `document_versions` (`version_id` BINARY(16) NOT NULL, `doc_id` BINARY(16) NOT NULL, `task_id` BINARY(16),
                                  `version_number` INT NOT NULL, `created_by_user_id` BINARY(16),
                                  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                  PRIMARY KEY (`version_id`)) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

CREATE TABLE `prediction_fields` (`field_id` BINARY(16) NOT NULL, `version_id` BINARY(16) NOT NULL,
                                  `parent_field_id` BINARY(16), `metadata_id` BINARY(16), `field_key` VARCHAR(128),
                                  `field_type` ENUM ('OBJECT', 'ARRAY', 'SCALAR') NOT NULL,
                                  `value_string` TEXT, `value_number` DECIMAL(18, 6), `value_date` DATETIME,
                                  `value_bool` BOOLEAN, `modified_by` BINARY(16),
                                  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                                  PRIMARY KEY (`field_id`)) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

CREATE TABLE `task_actions` (`action_id` BINARY(16) NOT NULL, `task_id` BINARY(16), `user_id` BINARY(16),
                             `action` VARCHAR(64), `datetime` DATETIME, `external_id` VARCHAR(128), `external_system` VARCHAR(32),
                             `reassign_from_user_id` BINARY(16), `reassign_to_user_id` BINARY(16), `reassign_comment` VARCHAR(255),
                             `action_metadata_json` JSON, `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                             `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                             PRIMARY KEY (`action_id`)) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

CREATE TABLE `task_edits` (`edit_id` BINARY(16) NOT NULL, `task_id` BINARY(16), `user_id` BINARY(16), `datetime` DATETIME,
                           `mode` ENUM ('GET', 'EDIT'), `edit_type` VARCHAR(128), `edit_value` TEXT,
                           `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                           `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                           PRIMARY KEY (`edit_id`)) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

CREATE TABLE `task_exceptions` (`exception_id` BINARY(16) NOT NULL, `task_id` BINARY(16),
                                `scope` ENUM ('HEADER', 'POSITION'), `position_type` VARCHAR(64), `position_id` VARCHAR(128),
                                `todo_type` VARCHAR(128), `status` ENUM ('OPEN', 'RESOLVED'),
                                `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                                `resolved_at` DATETIME, `resolved_by_user_id` BINARY(16),
                                `deviation_amount` DECIMAL(18, 2), `deviation_percent` DECIMAL(9, 4),
                                `risk_level` ENUM ('LOW', 'MEDIUM', 'HIGH'),
                                PRIMARY KEY (`exception_id`)) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

CREATE TABLE `dt_payment_conditions` (`id` BINARY(16) NOT NULL, `name` VARCHAR(255), `sconto_percent` DECIMAL(9, 4), `sconto_days` INT,
                                      `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                      `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                                      PRIMARY KEY (`id`)) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

CREATE TABLE `dt_business_partners` (`id` BINARY(16) NOT NULL, `name` VARCHAR(255), `payment_condition_id` BINARY(16),
                                     `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                     `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                                     PRIMARY KEY (`id`)) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

CREATE TABLE `dt_invoices` (`id` BINARY(16) NOT NULL, `external_id` VARCHAR(128), `business_partner_id` BINARY(16),
                            `total_amount` DECIMAL(18, 2), `invoice_status` VARCHAR(64), `posting_date` DATETIME,
                            `payment_date` DATETIME, `cash_discount_amount` DECIMAL(18, 2), `payment_condition_id` BINARY(16),
                            `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                            `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                            PRIMARY KEY (`id`)) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

CREATE TABLE `dt_purchase_orders` (`id` BINARY(16) NOT NULL, `external_id` VARCHAR(128),
                                   `purchase_order_type` ENUM ('NORMAL_ORDER', 'BLANKET_ORDER', 'BUDGET_ORDER', 'CONTRACT_ORDER',
                                       'SCHEDULING_AGREEMENT', 'SERVICE_ORDER', 'CONSIGNMENT_STOCK_ORDER', 'FREIGHT_ORDER'),
                                   `payment_condition_id` BINARY(16),
                                   `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                   `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                                   PRIMARY KEY (`id`)) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

CREATE TABLE `dt_delivery_notes` (`id` BINARY(16) NOT NULL,
                                  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                                  PRIMARY KEY (`id`)) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

CREATE TABLE `config_kv` (`config_id` BINARY(16) NOT NULL, `scope_type` ENUM ('GLOBAL', 'ORG', 'WORKFLOW', 'DASHBOARD', 'KPI'),
                          `scope_id` BINARY(16), `config_key` VARCHAR(128),
                          `value_type` ENUM ('STRING', 'NUMBER', 'BOOL', 'JSON', 'DATE'),
                          `value_string` TEXT, `value_number` DECIMAL(18, 6), `value_bool` BOOLEAN, `value_json` JSON, `value_date` DATETIME,
                          `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                          `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                          `updated_by_user_id` BINARY(16), PRIMARY KEY (`config_id`)) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

CREATE INDEX `users_index_0` ON `users` (`is_machine`);
CREATE INDEX `users_index_1` ON `users` (`name`);
CREATE INDEX `documents_index_org` ON `documents` (`org_id`);
CREATE INDEX `documents_index_org_type` ON `documents` (`org_id`, `document_type`);
CREATE INDEX `documents_index_2` ON `documents` (`document_type`);
CREATE INDEX `documents_index_3` ON `documents` (`external_database_id`);
CREATE INDEX `documents_index_4` ON `documents` (`received_at`);
CREATE INDEX `document_metadata_index_doc` ON `document_metadata` (`doc_id`);
CREATE INDEX `document_metadata_index_category` ON `document_metadata` (`category`);
CREATE INDEX `tasks_index_5` ON `tasks` (`workflow_instance_id`);
CREATE INDEX `tasks_index_6` ON `tasks` (`doc_id`);
CREATE INDEX `tasks_index_7` ON `tasks` (`status`);
CREATE INDEX `tasks_index_8` ON `tasks` (`task_type`);
CREATE INDEX `tasks_index_9` ON `tasks` (`business_process_type`);
CREATE INDEX `tasks_index_10` ON `tasks` (`assigned_to_user_id`, `status`);
CREATE INDEX `tasks_index_11` ON `tasks` (`doc_id`, `start_date`);
CREATE INDEX `tasks_index_12` ON `tasks` (`start_date`);
CREATE INDEX `tasks_index_13` ON `tasks` (`end_date`);
CREATE UNIQUE INDEX `document_versions_uq_doc_version` ON `document_versions` (`doc_id`, `version_number`);
CREATE INDEX `document_versions_index_task` ON `document_versions` (`task_id`);
CREATE INDEX `prediction_fields_index_28` ON `prediction_fields` (`field_key`);
CREATE INDEX `prediction_fields_index_type` ON `prediction_fields` (`version_id`, `field_type`);
CREATE INDEX `prediction_fields_index_version_key` ON `prediction_fields` (`version_id`, `field_key`);
CREATE INDEX `prediction_fields_index_parent` ON `prediction_fields` (`parent_field_id`);
CREATE INDEX `prediction_fields_index_meta` ON `prediction_fields` (`metadata_id`);
CREATE INDEX `task_actions_index_14` ON `task_actions` (`task_id`, `datetime`);
CREATE INDEX `task_actions_index_15` ON `task_actions` (`user_id`, `datetime`);
CREATE INDEX `task_actions_index_16` ON `task_actions` (`action`, `datetime`);
CREATE INDEX `task_actions_index_17` ON `task_actions` (`reassign_to_user_id`, `datetime`);
CREATE INDEX `task_edits_index_18` ON `task_edits` (`task_id`, `datetime`);
CREATE INDEX `task_edits_index_19` ON `task_edits` (`user_id`, `datetime`);
CREATE INDEX `task_edits_index_20` ON `task_edits` (`mode`, `datetime`);
CREATE INDEX `task_edits_index_21` ON `task_edits` (`edit_type`);
CREATE INDEX `dt_payment_conditions_index_29` ON `dt_payment_conditions` (`name`);
CREATE INDEX `dt_business_partners_index_30` ON `dt_business_partners` (`payment_condition_id`);
CREATE INDEX `dt_business_partners_index_31` ON `dt_business_partners` (`name`);
CREATE UNIQUE INDEX `dt_invoices_index_32` ON `dt_invoices` (`external_id`);
CREATE INDEX `config_kv_index_42` ON `config_kv` (`scope_type`, `scope_id`, `config_key`);
CREATE INDEX `config_kv_index_43` ON `config_kv` (`config_key`);
CREATE INDEX `config_kv_index_44` ON `config_kv` (`updated_at`);

ALTER TABLE `document_metadata` ADD CONSTRAINT `fk_dm_doc` FOREIGN KEY (`doc_id`) REFERENCES `documents` (`doc_id`);
ALTER TABLE `tasks` ADD CONSTRAINT `fk_tasks_wf` FOREIGN KEY (`workflow_instance_id`) REFERENCES `workflow_instances` (`workflow_instance_id`);
ALTER TABLE `tasks` ADD CONSTRAINT `fk_tasks_doc` FOREIGN KEY (`doc_id`) REFERENCES `documents` (`doc_id`);
ALTER TABLE `tasks` ADD CONSTRAINT `fk_tasks_user` FOREIGN KEY (`assigned_to_user_id`) REFERENCES `users` (`user_id`);
ALTER TABLE `document_versions` ADD CONSTRAINT `fk_dv_doc` FOREIGN KEY (`doc_id`) REFERENCES `documents` (`doc_id`);
ALTER TABLE `document_versions` ADD CONSTRAINT `fk_dv_task` FOREIGN KEY (`task_id`) REFERENCES `tasks` (`task_id`);
ALTER TABLE `document_versions` ADD CONSTRAINT `fk_dv_created_by` FOREIGN KEY (`created_by_user_id`) REFERENCES `users` (`user_id`);
ALTER TABLE `prediction_fields` ADD CONSTRAINT `fk_pf_version` FOREIGN KEY (`version_id`) REFERENCES `document_versions` (`version_id`);
ALTER TABLE `prediction_fields` ADD CONSTRAINT `fk_pf_parent` FOREIGN KEY (`parent_field_id`) REFERENCES `prediction_fields` (`field_id`);
ALTER TABLE `prediction_fields` ADD CONSTRAINT `fk_pf_modified_by` FOREIGN KEY (`modified_by`) REFERENCES `users` (`user_id`);
ALTER TABLE `task_actions` ADD CONSTRAINT `fk_ta_task` FOREIGN KEY (`task_id`) REFERENCES `tasks` (`task_id`);
ALTER TABLE `task_actions` ADD CONSTRAINT `fk_ta_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);
ALTER TABLE `task_actions` ADD CONSTRAINT `fk_ta_from_user` FOREIGN KEY (`reassign_from_user_id`) REFERENCES `users` (`user_id`);
ALTER TABLE `task_actions` ADD CONSTRAINT `fk_ta_to_user` FOREIGN KEY (`reassign_to_user_id`) REFERENCES `users` (`user_id`);
ALTER TABLE `task_edits` ADD CONSTRAINT `fk_te_task` FOREIGN KEY (`task_id`) REFERENCES `tasks` (`task_id`);
ALTER TABLE `task_edits` ADD CONSTRAINT `fk_te_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);
ALTER TABLE `task_exceptions` ADD CONSTRAINT `fk_tex_task` FOREIGN KEY (`task_id`) REFERENCES `tasks` (`task_id`);
ALTER TABLE `task_exceptions` ADD CONSTRAINT `fk_tex_resolver` FOREIGN KEY (`resolved_by_user_id`) REFERENCES `users` (`user_id`);
ALTER TABLE `dt_business_partners` ADD CONSTRAINT `fk_dtbp_pc` FOREIGN KEY (`payment_condition_id`) REFERENCES `dt_payment_conditions` (`id`);
ALTER TABLE `dt_invoices` ADD CONSTRAINT `fk_dti_bp` FOREIGN KEY (`business_partner_id`) REFERENCES `dt_business_partners` (`id`);
ALTER TABLE `dt_invoices` ADD CONSTRAINT `fk_dti_pc` FOREIGN KEY (`payment_condition_id`) REFERENCES `dt_payment_conditions` (`id`);
ALTER TABLE `dt_purchase_orders` ADD CONSTRAINT `fk_dtpo_pc` FOREIGN KEY (`payment_condition_id`) REFERENCES `dt_payment_conditions` (`id`);
ALTER TABLE `documents` ADD CONSTRAINT `fk_docs_ext_inv` FOREIGN KEY (`external_database_id`) REFERENCES `dt_invoices` (`external_id`);
ALTER TABLE `config_kv` ADD CONSTRAINT `fk_cfg_user` FOREIGN KEY (`updated_by_user_id`) REFERENCES `users` (`user_id`);
-- ============================================================
-- BLP Analytics KPI Model – DDL
-- Aligned to current DBML contract
-- ============================================================

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
    `status`                ENUM ('OPEN', 'DONE', 'CANCELLED'),
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
    `version_id`          BINARY(16) NOT NULL,
    `doc_id`              BINARY(16) NOT NULL,
    `task_id`             BINARY(16),
    `version_number`      INT        NOT NULL,
    `created_by_user_id`  BINARY(16),
    `created_at`          DATETIME   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`version_id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

CREATE TABLE `prediction_fields`
(
    `field_id`         BINARY(16)                       NOT NULL,
    `version_id`       BINARY(16)                       NOT NULL,
    `parent_field_id`  BINARY(16),
    `metadata_id`      BINARY(16),
    `field_key`        VARCHAR(128),
    `field_type`       ENUM ('OBJECT', 'ARRAY', 'SCALAR') NOT NULL,
    `value_string`     TEXT,
    `value_number`     DECIMAL(18, 6),
    `value_date`       DATETIME,
    `value_bool`       BOOLEAN,
    `modified_by`      BINARY(16),
    `created_at`       DATETIME                         NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at`       DATETIME                         NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`field_id`)
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
    PRIMARY KEY (`action_id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

CREATE TABLE `task_edits`
(
    `edit_id`    BINARY(16) NOT NULL,
    `task_id`    BINARY(16),
    `user_id`    BINARY(16),
    `datetime`   DATETIME,
    `mode`       ENUM ('GET', 'EDIT'),
    `edit_type`  VARCHAR(128),
    `edit_value` TEXT,
    `created_at` DATETIME   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME   NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`edit_id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

CREATE TABLE `task_exceptions`
(
    `exception_id`        BINARY(16) NOT NULL,
    `task_id`             BINARY(16),
    `scope`               ENUM ('HEADER', 'POSITION'),
    `position_type`       VARCHAR(64),
    `position_id`         VARCHAR(128),
    `todo_type`           VARCHAR(128),
    `status`              ENUM ('OPEN', 'RESOLVED'),
    `created_at`          DATETIME   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at`          DATETIME   NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `resolved_at`         DATETIME,
    `resolved_by_user_id` BINARY(16),
    `deviation_amount`    DECIMAL(18, 2),
    `deviation_percent`   DECIMAL(9, 4),
    `risk_level`          ENUM ('LOW', 'MEDIUM', 'HIGH'),
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
    PRIMARY KEY (`id`)
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
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

CREATE TABLE `dt_purchase_orders`
(
    `id`                   BINARY(16) NOT NULL,
    `external_id`          VARCHAR(128),
    `purchase_order_type`  ENUM ('NORMAL_ORDER', 'BLANKET_ORDER', 'BUDGET_ORDER', 'CONTRACT_ORDER',
        'SCHEDULING_AGREEMENT', 'SERVICE_ORDER', 'CONSIGNMENT_STOCK_ORDER', 'FREIGHT_ORDER'),
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
    `scope_type`         ENUM ('GLOBAL', 'ORG', 'WORKFLOW', 'DASHBOARD', 'KPI'),
    `scope_id`           BINARY(16),
    `config_key`         VARCHAR(128),
    `value_type`         ENUM ('STRING', 'NUMBER', 'BOOL', 'JSON', 'DATE'),
    `value_string`       TEXT,
    `value_number`       DECIMAL(18, 6),
    `value_bool`         BOOLEAN,
    `value_json`         JSON,
    `value_date`         DATETIME,
    `created_at`         DATETIME   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at`         DATETIME   NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `updated_by_user_id` BINARY(16),
    PRIMARY KEY (`config_id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

-- ============================================================
-- Indexes
-- ============================================================
CREATE INDEX `users_index_0` ON `users` (`is_machine`);
CREATE INDEX `users_index_1` ON `users` (`name`);

CREATE INDEX `documents_index_org` ON `documents` (`org_id`);
CREATE INDEX `documents_index_org_type` ON `documents` (`org_id`, `document_type`);
CREATE INDEX `documents_index_2` ON `documents` (`document_type`);
CREATE INDEX `documents_index_3` ON `documents` (`external_database_id`);
CREATE INDEX `documents_index_4` ON `documents` (`received_at`);

CREATE INDEX `document_metadata_index_doc` ON `document_metadata` (`doc_id`);
CREATE INDEX `document_metadata_index_category` ON `document_metadata` (`category`);

CREATE INDEX `tasks_index_5` ON `tasks` (`workflow_instance_id`);
CREATE INDEX `tasks_index_6` ON `tasks` (`doc_id`);
CREATE INDEX `tasks_index_7` ON `tasks` (`status`);
CREATE INDEX `tasks_index_8` ON `tasks` (`task_type`);
CREATE INDEX `tasks_index_9` ON `tasks` (`business_process_type`);
CREATE INDEX `tasks_index_10` ON `tasks` (`assigned_to_user_id`, `status`);
CREATE INDEX `tasks_index_11` ON `tasks` (`doc_id`, `start_date`);
CREATE INDEX `tasks_index_12` ON `tasks` (`start_date`);
CREATE INDEX `tasks_index_13` ON `tasks` (`end_date`);

CREATE UNIQUE INDEX `document_versions_uq_doc_version` ON `document_versions` (`doc_id`, `version_number`);
CREATE INDEX `document_versions_index_task` ON `document_versions` (`task_id`);

CREATE INDEX `prediction_fields_index_28` ON `prediction_fields` (`field_key`);
CREATE INDEX `prediction_fields_index_type` ON `prediction_fields` (`version_id`, `field_type`);
CREATE INDEX `prediction_fields_index_version_key` ON `prediction_fields` (`version_id`, `field_key`);
CREATE INDEX `prediction_fields_index_parent` ON `prediction_fields` (`parent_field_id`);
CREATE INDEX `prediction_fields_index_meta` ON `prediction_fields` (`metadata_id`);

CREATE INDEX `task_actions_index_14` ON `task_actions` (`task_id`, `datetime`);
CREATE INDEX `task_actions_index_15` ON `task_actions` (`user_id`, `datetime`);
CREATE INDEX `task_actions_index_16` ON `task_actions` (`action`, `datetime`);
CREATE INDEX `task_actions_index_17` ON `task_actions` (`reassign_to_user_id`, `datetime`);

CREATE INDEX `task_edits_index_18` ON `task_edits` (`task_id`, `datetime`);
CREATE INDEX `task_edits_index_19` ON `task_edits` (`user_id`, `datetime`);
CREATE INDEX `task_edits_index_20` ON `task_edits` (`mode`, `datetime`);
CREATE INDEX `task_edits_index_21` ON `task_edits` (`edit_type`);

CREATE INDEX `dt_payment_conditions_index_29` ON `dt_payment_conditions` (`name`);
CREATE INDEX `dt_business_partners_index_30` ON `dt_business_partners` (`payment_condition_id`);
CREATE INDEX `dt_business_partners_index_31` ON `dt_business_partners` (`name`);
CREATE UNIQUE INDEX `dt_invoices_index_32` ON `dt_invoices` (`external_id`);
CREATE INDEX `config_kv_index_42` ON `config_kv` (`scope_type`, `scope_id`, `config_key`);
CREATE INDEX `config_kv_index_43` ON `config_kv` (`config_key`);
CREATE INDEX `config_kv_index_44` ON `config_kv` (`updated_at`);

-- ============================================================
-- Foreign keys
-- ============================================================
ALTER TABLE `document_metadata`
    ADD CONSTRAINT `fk_dm_doc`
        FOREIGN KEY (`doc_id`) REFERENCES `documents` (`doc_id`);

ALTER TABLE `tasks`
    ADD CONSTRAINT `fk_tasks_wf`
        FOREIGN KEY (`workflow_instance_id`) REFERENCES `workflow_instances` (`workflow_instance_id`);
ALTER TABLE `tasks`
    ADD CONSTRAINT `fk_tasks_doc`
        FOREIGN KEY (`doc_id`) REFERENCES `documents` (`doc_id`);
ALTER TABLE `tasks`
    ADD CONSTRAINT `fk_tasks_user`
        FOREIGN KEY (`assigned_to_user_id`) REFERENCES `users` (`user_id`);

ALTER TABLE `document_versions`
    ADD CONSTRAINT `fk_dv_doc`
        FOREIGN KEY (`doc_id`) REFERENCES `documents` (`doc_id`);
ALTER TABLE `document_versions`
    ADD CONSTRAINT `fk_dv_task`
        FOREIGN KEY (`task_id`) REFERENCES `tasks` (`task_id`);
ALTER TABLE `document_versions`
    ADD CONSTRAINT `fk_dv_created_by`
        FOREIGN KEY (`created_by_user_id`) REFERENCES `users` (`user_id`);

ALTER TABLE `prediction_fields`
    ADD CONSTRAINT `fk_pf_version`
        FOREIGN KEY (`version_id`) REFERENCES `document_versions` (`version_id`);
ALTER TABLE `prediction_fields`
    ADD CONSTRAINT `fk_pf_parent`
        FOREIGN KEY (`parent_field_id`) REFERENCES `prediction_fields` (`field_id`);
ALTER TABLE `prediction_fields`
    ADD CONSTRAINT `fk_pf_modified_by`
        FOREIGN KEY (`modified_by`) REFERENCES `users` (`user_id`);

ALTER TABLE `task_actions`
    ADD CONSTRAINT `fk_ta_task`
        FOREIGN KEY (`task_id`) REFERENCES `tasks` (`task_id`);
ALTER TABLE `task_actions`
    ADD CONSTRAINT `fk_ta_user`
        FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);
ALTER TABLE `task_actions`
    ADD CONSTRAINT `fk_ta_from_user`
        FOREIGN KEY (`reassign_from_user_id`) REFERENCES `users` (`user_id`);
ALTER TABLE `task_actions`
    ADD CONSTRAINT `fk_ta_to_user`
        FOREIGN KEY (`reassign_to_user_id`) REFERENCES `users` (`user_id`);

ALTER TABLE `task_edits`
    ADD CONSTRAINT `fk_te_task`
        FOREIGN KEY (`task_id`) REFERENCES `tasks` (`task_id`);
ALTER TABLE `task_edits`
    ADD CONSTRAINT `fk_te_user`
        FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);

ALTER TABLE `task_exceptions`
    ADD CONSTRAINT `fk_tex_task`
        FOREIGN KEY (`task_id`) REFERENCES `tasks` (`task_id`);
ALTER TABLE `task_exceptions`
    ADD CONSTRAINT `fk_tex_resolver`
        FOREIGN KEY (`resolved_by_user_id`) REFERENCES `users` (`user_id`);

ALTER TABLE `dt_business_partners`
    ADD CONSTRAINT `fk_dtbp_pc`
        FOREIGN KEY (`payment_condition_id`) REFERENCES `dt_payment_conditions` (`id`);
ALTER TABLE `dt_invoices`
    ADD CONSTRAINT `fk_dti_bp`
        FOREIGN KEY (`business_partner_id`) REFERENCES `dt_business_partners` (`id`);
ALTER TABLE `dt_invoices`
    ADD CONSTRAINT `fk_dti_pc`
        FOREIGN KEY (`payment_condition_id`) REFERENCES `dt_payment_conditions` (`id`);
ALTER TABLE `dt_purchase_orders`
    ADD CONSTRAINT `fk_dtpo_pc`
        FOREIGN KEY (`payment_condition_id`) REFERENCES `dt_payment_conditions` (`id`);

ALTER TABLE `documents`
    ADD CONSTRAINT `fk_docs_ext_inv`
        FOREIGN KEY (`external_database_id`) REFERENCES `dt_invoices` (`external_id`);

ALTER TABLE `config_kv`
    ADD CONSTRAINT `fk_cfg_user`
        FOREIGN KEY (`updated_by_user_id`) REFERENCES `users` (`user_id`);
-- -----------------------------------------------
-- Core actors
-- -----------------------------------------------
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

-- -----------------------------------------------
-- Documents
-- -----------------------------------------------
CREATE TABLE `documents`
(
    `doc_id`               BINARY(16) NOT NULL,
    `org_id`               BINARY(16) NOT NULL COMMENT 'Tenant / organisation identifier',
    `name`                 VARCHAR(255),
    `document_type`        VARCHAR(64),
    `external_database_id` VARCHAR(128) COMMENT 'ERP external identifier. Links to dt_invoices.external_id when written back + synced',
    `received_at`          DATETIME COMMENT 'Document ingested/created in BLP',
    `created_at`           DATETIME   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at`           DATETIME   NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`doc_id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

-- -----------------------------------------------
-- Document status history (temporal)
-- -----------------------------------------------
CREATE TABLE `document_status`
(
    `document_status_id` BINARY(16)  NOT NULL,
    `doc_id`             BINARY(16)  NOT NULL,
    `category`           VARCHAR(64) NOT NULL COMMENT 'e.g. IMPORTED, NOT_CHECKED, CORRECTED, FETCHED',
    `version_start_date` DATETIME    NOT NULL,
    `version_end_date`   DATETIME COMMENT 'nullable; NULL = active status',
    `modified_by`        VARCHAR(255) COMMENT 'free-text actor identifier',
    `created_by`         VARCHAR(255) COMMENT 'free-text creator identifier',
    `updated_by`         VARCHAR(255) COMMENT 'free-text updater identifier',
    `created_at`         DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at`         DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`document_status_id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

-- -----------------------------------------------
-- Workflow
-- -----------------------------------------------
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
    `task_type`             VARCHAR(64) COMMENT 'e.g. approval, sachliche_pruefung, matching, posting',
    `business_process_type` VARCHAR(64) COMMENT 'Used for KPI scoping; aligned with dashboard config',
    `status`                ENUM ('OPEN','DONE','CANCELLED'), -- FIX: quoted enum values
    `start_date`            DATETIME,
    `end_date`              DATETIME,
    `assigned_to_user_id`   BINARY(16) COMMENT 'nullable - current assignee',
    `assigned_at`           DATETIME COMMENT 'nullable - when current assignee took ownership',
    `sla_due_at`            DATETIME COMMENT 'nullable - SLA based due timestamp',
    `created_at`            DATETIME   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at`            DATETIME   NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`task_id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

-- -----------------------------------------------
-- Task actions
-- -----------------------------------------------
CREATE TABLE `task_actions`
(
    `action_id`             BINARY(16) NOT NULL,
    `task_id`               BINARY(16),
    `user_id`               BINARY(16),
    `action`                VARCHAR(64) COMMENT 'enum-like string, e.g. approve, decline, ask_for_correction, CATEGORY_CHANGE, REASSIGN_USER, complete, start',
    `datetime`              DATETIME,
    `external_id`           VARCHAR(128) COMMENT 'nullable; ERP id if known/available at change time',
    `external_system`       VARCHAR(32) COMMENT 'nullable; e.g. SAP|D365|INFOR',
    `reassign_from_user_id` BINARY(16) COMMENT 'nullable; set when action=REASSIGN_USER',
    `reassign_to_user_id`   BINARY(16) COMMENT 'nullable; set when action=REASSIGN_USER',
    `reassign_comment`      VARCHAR(255) COMMENT 'nullable',
    `action_metadata_json`  JSON,
    `created_at`            DATETIME   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at`            DATETIME   NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`action_id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

-- -----------------------------------------------
-- Task edits
-- -----------------------------------------------
CREATE TABLE `task_edits`
(
    `edit_id`    BINARY(16) NOT NULL,
    `task_id`    BINARY(16),
    `user_id`    BINARY(16),
    `datetime`   DATETIME,
    `mode`       ENUM ('GET','EDIT'), -- FIX: quoted enum values
    `edit_type`  VARCHAR(128),
    `edit_value` TEXT,
    `created_at` DATETIME   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME   NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`edit_id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

-- -----------------------------------------------
-- Task exceptions (todos / checks)
-- -----------------------------------------------
CREATE TABLE `task_exceptions`
(
    `exception_id`        BINARY(16) NOT NULL,
    `task_id`             BINARY(16),
    `scope`               ENUM ('HEADER','POSITION'),                                                       -- FIX: quoted enum values
    `position_type`       VARCHAR(64) COMMENT 'nullable if HEADER; e.g. INVOICE_LINE, PO_LINE, SERVICE_LINE, GENERIC_LINE',
    `position_id`         VARCHAR(128) COMMENT 'nullable if HEADER; stable position key, string to support OCR row ids etc.',
    `todo_type`           VARCHAR(128) COMMENT 'e.g. unit_price_mismatch, payment_term_mismatch, missing_supplier, etc.',
    `status`              ENUM ('OPEN','RESOLVED'),                                                         -- FIX: quoted enum values
    `created_at`          DATETIME   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at`          DATETIME   NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `resolved_at`         DATETIME,
    `resolved_by_user_id` BINARY(16) COMMENT 'nullable if still open',
    `deviation_amount`    DECIMAL(18, 2) COMMENT 'nullable - e.g. CHF deviation',
    `deviation_percent`   DECIMAL(9, 4) COMMENT 'nullable - e.g. 0.0350 for 3.5%',
    `risk_level`          ENUM ('LOW','MEDIUM','HIGH') COMMENT 'optional - can also be derived via config', -- FIX: quoted
    PRIMARY KEY (`exception_id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

-- -----------------------------------------------
-- Position fields metadata (position tagging)
-- -----------------------------------------------
CREATE TABLE `prediction_fields_metadata`
(
    `prediction_fields_metadata_id` BINARY(16) NOT NULL,
    `field_key`                     VARCHAR(128),
    `value_string`                  VARCHAR(128),
    `created_at`                    DATETIME   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at`                    DATETIME   NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`prediction_fields_metadata_id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

-- -----------------------------------------------
-- Prediction fields (unified header + positions, tree structure, temporal versioning)
-- -----------------------------------------------
CREATE TABLE `prediction_fields`
(
    `field_id`           BINARY(16)                       NOT NULL,
    `parent_field_id`    BINARY(16) COMMENT 'nullable; tree parent – nested JSON is modeled as children',
    `metadata_id`        BINARY(16) COMMENT 'nullable; links to prediction_fields_metadata for position tagging',
    `task_id`            BINARY(16),
    `field_key`          VARCHAR(128),
    `field_type`         ENUM ('OBJECT','ARRAY','SCALAR') NOT NULL COMMENT 'OBJECT = named children, ARRAY = ordered children, SCALAR = leaf value',
    `value_string`       TEXT,
    `value_number`       DECIMAL(18, 6),
    `value_date`         DATETIME,
    `value_bool`         BOOLEAN,
    `version_start_date` DATETIME,
    `version_end_date`   DATETIME COMMENT 'nullable; NULL = current version',
    `modified_by`        BINARY(16),
    `created_at`         DATETIME                         NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at`         DATETIME                         NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`field_id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

-- -----------------------------------------------
-- Digital Twin – Payment conditions
-- -----------------------------------------------
CREATE TABLE `dt_payment_conditions`
(
    `id`             BINARY(16) NOT NULL,
    `name`           VARCHAR(255),
    `sconto_percent` DECIMAL(9, 4) COMMENT 'e.g. 0.0200 for 2%',
    `sconto_days`    INT COMMENT 'discount window length in days',
    `created_at`     DATETIME   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at`     DATETIME   NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

-- -----------------------------------------------
-- Digital Twin – Business partners
-- -----------------------------------------------
CREATE TABLE `dt_business_partners`
(
    `id`                   BINARY(16) NOT NULL,
    `name`                 VARCHAR(255),
    `payment_condition_id` BINARY(16),
    `created_at`           DATETIME   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at`           DATETIME   NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

-- -----------------------------------------------
-- Digital Twin – Invoices
-- -----------------------------------------------
CREATE TABLE `dt_invoices`
(
    `id`                   BINARY(16) NOT NULL,
    `external_id`          VARCHAR(128) COMMENT 'ERP invoice id. Join target for documents.external_database_id',
    `business_partner_id`  BINARY(16),
    `total_amount`         DECIMAL(18, 2),
    `invoice_status`       VARCHAR(64),
    `posting_date`         DATETIME COMMENT 'ERP posting date',
    `payment_date`         DATETIME COMMENT 'ERP payment execution date',
    `cash_discount_amount` DECIMAL(18, 2) COMMENT 'Actual cash discount taken',
    `payment_condition_id` BINARY(16) COMMENT 'Payment condition applied in ERP, if available',
    `created_at`           DATETIME   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at`           DATETIME   NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

-- -----------------------------------------------
-- Digital Twin – Purchase orders
-- -----------------------------------------------
CREATE TABLE `dt_purchase_orders`
(
    `id`                   BINARY(16) NOT NULL,
    `external_id`          VARCHAR(128) UNIQUE COMMENT 'ERP PO id used in prediction_fields via field_key=po_external_id',
    `purchase_order_type`  ENUM ( -- FIX: quoted enum values
        'NORMAL_ORDER','BLANKET_ORDER','BUDGET_ORDER','CONTRACT_ORDER',
        'SCHEDULING_AGREEMENT','SERVICE_ORDER','CONSIGNMENT_STOCK_ORDER','FREIGHT_ORDER'
        ),
    `payment_condition_id` BINARY(16) COMMENT 'Potential payment condition for PO-related invoices',
    `created_at`           DATETIME   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at`           DATETIME   NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

-- -----------------------------------------------
-- Digital Twin – Delivery notes
-- -----------------------------------------------
CREATE TABLE `dt_delivery_notes`
(
    `id`         BINARY(16) NOT NULL,
    `created_at` DATETIME   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME   NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

-- -----------------------------------------------
-- Config key-value store
-- -----------------------------------------------
CREATE TABLE `config_kv`
(
    `config_id`          BINARY(16) NOT NULL,
    `scope_type`         ENUM ('GLOBAL','ORG','WORKFLOW','DASHBOARD','KPI'), -- FIX: quoted enum values
    `scope_id`           BINARY(16) COMMENT 'nullable when GLOBAL',
    `config_key`         VARCHAR(128) COMMENT 'e.g. low_touch_threshold, reversal_status_set, todo_minutes_constant',
    `value_type`         ENUM ('STRING','NUMBER','BOOL','JSON','DATE'),      -- FIX: quoted enum values
    `value_string`       TEXT,
    `value_number`       DECIMAL(18, 6),
    `value_bool`         BOOLEAN,
    `value_json`         JSON,
    `value_date`         DATETIME,
    `created_at`         DATETIME   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at`         DATETIME   NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `updated_by_user_id` BINARY(16) COMMENT 'nullable',
    PRIMARY KEY (`config_id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;


-- ============================================================
-- Indexes
-- ============================================================

CREATE INDEX `users_index_0` ON `users` (`is_machine`);
CREATE INDEX `users_index_1` ON `users` (`name`);

CREATE INDEX `documents_index_org` ON `documents` (`org_id`);
CREATE INDEX `documents_index_org_type` ON `documents` (`org_id`, `document_type`);
CREATE INDEX `documents_index_2` ON `documents` (`document_type`);
CREATE INDEX `documents_index_3` ON `documents` (`external_database_id`);
CREATE INDEX `documents_index_4` ON `documents` (`received_at`);

CREATE INDEX `document_status_index_doc` ON `document_status` (`doc_id`);
CREATE INDEX `document_status_index_category` ON `document_status` (`category`);
CREATE INDEX `document_status_index_active` ON `document_status` (`doc_id`, `version_end_date`);
CREATE INDEX `document_status_index_version` ON `document_status` (`version_start_date`, `version_end_date`);

CREATE INDEX `tasks_index_5` ON `tasks` (`workflow_instance_id`);
CREATE INDEX `tasks_index_6` ON `tasks` (`doc_id`);
CREATE INDEX `tasks_index_7` ON `tasks` (`status`);
CREATE INDEX `tasks_index_8` ON `tasks` (`task_type`);
CREATE INDEX `tasks_index_9` ON `tasks` (`business_process_type`);
CREATE INDEX `tasks_index_10` ON `tasks` (`assigned_to_user_id`, `status`);
CREATE INDEX `tasks_index_11` ON `tasks` (`doc_id`, `start_date`);
CREATE INDEX `tasks_index_12` ON `tasks` (`start_date`);
CREATE INDEX `tasks_index_13` ON `tasks` (`end_date`);

CREATE INDEX `task_actions_index_14` ON `task_actions` (`task_id`, `datetime`);
CREATE INDEX `task_actions_index_15` ON `task_actions` (`user_id`, `datetime`);
CREATE INDEX `task_actions_index_16` ON `task_actions` (`action`, `datetime`);
CREATE INDEX `task_actions_index_17` ON `task_actions` (`reassign_to_user_id`, `datetime`);

CREATE INDEX `task_edits_index_18` ON `task_edits` (`task_id`, `datetime`);
CREATE INDEX `task_edits_index_19` ON `task_edits` (`user_id`, `datetime`);
CREATE INDEX `task_edits_index_20` ON `task_edits` (`mode`, `datetime`);
CREATE INDEX `task_edits_index_21` ON `task_edits` (`edit_type`);

CREATE INDEX `task_exceptions_index_22` ON `task_exceptions` (`task_id`, `status`);
CREATE INDEX `task_exceptions_index_23` ON `task_exceptions` (`todo_type`, `status`);
CREATE INDEX `task_exceptions_index_24` ON `task_exceptions` (`created_at`);
CREATE INDEX `task_exceptions_index_25` ON `task_exceptions` (`resolved_at`);
CREATE INDEX `task_exceptions_index_26` ON `task_exceptions` (`resolved_by_user_id`, `resolved_at`);
CREATE INDEX `task_exceptions_index_27` ON `task_exceptions` (`scope`, `todo_type`, `status`);

CREATE INDEX `prediction_fields_index_28` ON `prediction_fields` (`field_key`);
CREATE INDEX `prediction_fields_index_type` ON `prediction_fields` (`task_id`, `field_type`);
CREATE INDEX `prediction_fields_index_task` ON `prediction_fields` (`task_id`, `field_key`);
CREATE INDEX `prediction_fields_index_parent` ON `prediction_fields` (`parent_field_id`);
CREATE INDEX `prediction_fields_index_meta` ON `prediction_fields` (`metadata_id`);
CREATE INDEX `prediction_fields_index_version` ON `prediction_fields` (`task_id`, `version_start_date`, `version_end_date`);

-- IMPROVEMENT: index on prediction_fields_metadata for lookups by field_key
CREATE INDEX `prediction_fields_metadata_index_key` ON `prediction_fields_metadata` (`field_key`);

CREATE INDEX `dt_payment_conditions_index_29` ON `dt_payment_conditions` (`name`);

CREATE INDEX `dt_business_partners_index_30` ON `dt_business_partners` (`payment_condition_id`);
CREATE INDEX `dt_business_partners_index_31` ON `dt_business_partners` (`name`);

CREATE UNIQUE INDEX `dt_invoices_index_32` ON `dt_invoices` (`external_id`);
CREATE INDEX `dt_invoices_index_33` ON `dt_invoices` (`business_partner_id`);
CREATE INDEX `dt_invoices_index_34` ON `dt_invoices` (`invoice_status`);
CREATE INDEX `dt_invoices_index_35` ON `dt_invoices` (`posting_date`);
CREATE INDEX `dt_invoices_index_36` ON `dt_invoices` (`payment_date`);
CREATE INDEX `dt_invoices_index_37` ON `dt_invoices` (`payment_condition_id`);

CREATE INDEX `dt_purchase_orders_index_38` ON `dt_purchase_orders` (`external_id`);
CREATE INDEX `dt_purchase_orders_index_39` ON `dt_purchase_orders` (`purchase_order_type`);
CREATE INDEX `dt_purchase_orders_index_40` ON `dt_purchase_orders` (`payment_condition_id`);

CREATE INDEX `dt_delivery_notes_index_41` ON `dt_delivery_notes` (`created_at`);

CREATE UNIQUE INDEX `config_kv_index_42` ON `config_kv` (`scope_type`, `scope_id`, `config_key`);
CREATE INDEX `config_kv_index_43` ON `config_kv` (`config_key`);
CREATE INDEX `config_kv_index_44` ON `config_kv` (`updated_at`);


-- ============================================================
-- Foreign keys
-- ============================================================

ALTER TABLE `prediction_fields`
    ADD CONSTRAINT `fk_pf_metadata`
        FOREIGN KEY (`metadata_id`) REFERENCES `prediction_fields_metadata` (`prediction_fields_metadata_id`);

-- FIX: original had metadata_id → tasks which is wrong; the task_id column should reference tasks
ALTER TABLE `prediction_fields`
    ADD CONSTRAINT `fk_pf_task`
        FOREIGN KEY (`task_id`) REFERENCES `tasks` (`task_id`);

ALTER TABLE `prediction_fields`
    ADD CONSTRAINT `fk_pf_parent`
        FOREIGN KEY (`parent_field_id`) REFERENCES `prediction_fields` (`field_id`);

-- IMPROVEMENT: FK for modified_by → users
ALTER TABLE `prediction_fields`
    ADD CONSTRAINT `fk_pf_modified_by`
        FOREIGN KEY (`modified_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL;

ALTER TABLE `document_status`
    ADD CONSTRAINT `fk_ds_doc`
        FOREIGN KEY (`doc_id`) REFERENCES `documents` (`doc_id`) ON DELETE CASCADE;

ALTER TABLE `tasks`
    ADD CONSTRAINT `fk_tasks_wf`
        FOREIGN KEY (`workflow_instance_id`) REFERENCES `workflow_instances` (`workflow_instance_id`);

ALTER TABLE `tasks`
    ADD CONSTRAINT `fk_tasks_doc`
        FOREIGN KEY (`doc_id`) REFERENCES `documents` (`doc_id`);

ALTER TABLE `tasks`
    ADD CONSTRAINT `fk_tasks_user`
        FOREIGN KEY (`assigned_to_user_id`) REFERENCES `users` (`user_id`);

ALTER TABLE `task_actions`
    ADD CONSTRAINT `fk_ta_task`
        FOREIGN KEY (`task_id`) REFERENCES `tasks` (`task_id`);

ALTER TABLE `task_actions`
    ADD CONSTRAINT `fk_ta_user`
        FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);

ALTER TABLE `task_actions`
    ADD CONSTRAINT `fk_ta_from_user`
        FOREIGN KEY (`reassign_from_user_id`) REFERENCES `users` (`user_id`);

ALTER TABLE `task_actions`
    ADD CONSTRAINT `fk_ta_to_user`
        FOREIGN KEY (`reassign_to_user_id`) REFERENCES `users` (`user_id`);

ALTER TABLE `task_edits`
    ADD CONSTRAINT `fk_te_task`
        FOREIGN KEY (`task_id`) REFERENCES `tasks` (`task_id`);

ALTER TABLE `task_edits`
    ADD CONSTRAINT `fk_te_user`
        FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);

ALTER TABLE `task_exceptions`
    ADD CONSTRAINT `fk_tex_task`
        FOREIGN KEY (`task_id`) REFERENCES `tasks` (`task_id`);

ALTER TABLE `task_exceptions`
    ADD CONSTRAINT `fk_tex_resolver`
        FOREIGN KEY (`resolved_by_user_id`) REFERENCES `users` (`user_id`);

ALTER TABLE `dt_business_partners`
    ADD CONSTRAINT `fk_dtbp_pc`
        FOREIGN KEY (`payment_condition_id`) REFERENCES `dt_payment_conditions` (`id`);

ALTER TABLE `dt_invoices`
    ADD CONSTRAINT `fk_dti_bp`
        FOREIGN KEY (`business_partner_id`) REFERENCES `dt_business_partners` (`id`);

ALTER TABLE `dt_invoices`
    ADD CONSTRAINT `fk_dti_pc`
        FOREIGN KEY (`payment_condition_id`) REFERENCES `dt_payment_conditions` (`id`);

ALTER TABLE `dt_purchase_orders`
    ADD CONSTRAINT `fk_dtpo_pc`
        FOREIGN KEY (`payment_condition_id`) REFERENCES `dt_payment_conditions` (`id`);

ALTER TABLE `documents`
    ADD CONSTRAINT `fk_docs_ext_inv`
        FOREIGN KEY (`external_database_id`) REFERENCES `dt_invoices` (`external_id`);

ALTER TABLE `config_kv`
    ADD CONSTRAINT `fk_cfg_user`
        FOREIGN KEY (`updated_by_user_id`) REFERENCES `users` (`user_id`);


-- ============================================================
-- Views
-- ============================================================

-- ---------------------------------------------------------
-- v_current_predictions
-- Flat view: document + task + current prediction fields
-- Only version_end_date IS NULL (= active version)
-- Use to filter by any prediction value, e.g.:
--   SELECT * FROM v_current_predictions
--   WHERE field_key = 'InvoiceType' AND value_string = 'MM';
-- ---------------------------------------------------------
CREATE OR REPLACE VIEW `v_current_predictions` AS
SELECT d.doc_id,
       d.org_id,
       d.name           AS doc_name,
       d.document_type,
       d.external_database_id,
       d.received_at,
       t.task_id,
       t.task_type,
       t.business_process_type,
       t.status         AS task_status,
       t.start_date     AS task_start_date,
       t.end_date       AS task_end_date,
       pf.field_id,
       pf.parent_field_id,
       pf.field_key,
       pf.field_type,
       pf.value_string,
       pf.value_number,
       pf.value_date,
       pf.value_bool,
       pf.version_start_date,
       pf.modified_by,
       pf.created_at    AS field_created_at,
       pf.metadata_id,
       pfm.field_key    AS metadata_key,
       pfm.value_string AS metadata_value
FROM documents d
         JOIN tasks t ON t.doc_id = d.doc_id
         JOIN prediction_fields pf ON pf.task_id = t.task_id
    AND pf.version_end_date IS NULL
         LEFT JOIN prediction_fields_metadata pfm
                   ON pfm.prediction_fields_metadata_id = pf.metadata_id;


-- ---------------------------------------------------------
-- v_zero_touch_predictions
-- Same as v_current_predictions but restricted to documents
-- where NO human user (is_machine = FALSE) appears in
-- task_edits, task_actions, or task_exceptions.
-- ---------------------------------------------------------
CREATE OR REPLACE VIEW `v_zero_touch_predictions` AS
SELECT d.doc_id,
       d.org_id,
       d.name           AS doc_name,
       d.document_type,
       d.external_database_id,
       d.received_at,
       t.task_id,
       t.task_type,
       t.business_process_type,
       t.status         AS task_status,
       t.start_date     AS task_start_date,
       t.end_date       AS task_end_date,
       pf.field_id,
       pf.parent_field_id,
       pf.field_key,
       pf.field_type,
       pf.value_string,
       pf.value_number,
       pf.value_date,
       pf.value_bool,
       pf.version_start_date,
       pf.modified_by,
       pf.created_at    AS field_created_at,
       pf.metadata_id,
       pfm.field_key    AS metadata_key,
       pfm.value_string AS metadata_value
FROM documents d
         JOIN tasks t ON t.doc_id = d.doc_id
         JOIN prediction_fields pf ON pf.task_id = t.task_id
    AND pf.version_end_date IS NULL
         LEFT JOIN prediction_fields_metadata pfm
                   ON pfm.prediction_fields_metadata_id = pf.metadata_id
WHERE NOT EXISTS (SELECT 1
                  FROM task_edits te
                           JOIN users u ON u.user_id = te.user_id AND u.is_machine = FALSE
                  WHERE te.task_id = t.task_id)
  AND NOT EXISTS (SELECT 1
                  FROM task_actions ta
                  WHERE ta.task_id = t.task_id
                    AND (EXISTS (SELECT 1 FROM users u WHERE u.user_id = ta.user_id AND u.is_machine = FALSE)
                      OR EXISTS (SELECT 1
                                 FROM users u
                                 WHERE u.user_id = ta.reassign_from_user_id
                                   AND u.is_machine = FALSE)
                      OR EXISTS (SELECT 1
                                 FROM users u
                                 WHERE u.user_id = ta.reassign_to_user_id
                                   AND u.is_machine = FALSE)))
  AND NOT EXISTS (SELECT 1
                  FROM task_exceptions tex
                           JOIN users u ON u.user_id = tex.resolved_by_user_id AND u.is_machine = FALSE
                  WHERE tex.task_id = t.task_id);
