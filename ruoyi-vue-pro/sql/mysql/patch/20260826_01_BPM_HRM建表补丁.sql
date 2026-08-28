-- =====================================================
-- BPM + HRM 模块业务表建表补丁 (MySQL 5.7+)
-- 说明：主 SQL 脚本 ruoyi-vue-pro.sql 仅包含 system/infra 核心表
--       BPM/HRM 模块的建表语句需通过本补丁单独导入
-- Flowable 引擎表（act_*）由后端启动时自动创建，无需手动导入
-- 使用方法：在 Navicat 中连接 ruoyi-vue-pro 数据库，执行本脚本
-- =====================================================

-- =====================================================
-- 一、BPM 模块业务表（8张）
-- =====================================================

-- 1. 用户组
CREATE TABLE IF NOT EXISTS `bpm_user_group` (
    `id` bigint NOT NULL AUTO_INCREMENT,
    `name` varchar(63) NOT NULL,
    `description` varchar(255) DEFAULT '',
    `status` tinyint NOT NULL,
    `user_ids` varchar(1024) DEFAULT NULL,
    `creator` varchar(64) DEFAULT '',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updater` varchar(64) DEFAULT '',
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `deleted` bit(1) NOT NULL DEFAULT b'0',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='用户组';

-- 2. 分类
CREATE TABLE IF NOT EXISTS `bpm_category` (
    `id` bigint NOT NULL AUTO_INCREMENT,
    `name` varchar(63) NOT NULL,
    `code` varchar(63) NOT NULL,
    `description` varchar(255) DEFAULT '',
    `status` tinyint NOT NULL,
    `sort` int NOT NULL DEFAULT 0,
    `creator` varchar(64) DEFAULT '',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updater` varchar(64) DEFAULT '',
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `deleted` bit(1) NOT NULL DEFAULT b'0',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='分类';

-- 3. 动态表单
CREATE TABLE IF NOT EXISTS `bpm_form` (
    `id` bigint NOT NULL AUTO_INCREMENT,
    `name` varchar(63) NOT NULL,
    `status` tinyint NOT NULL,
    `fields` text,
    `conf` text,
    `remark` varchar(255) DEFAULT NULL,
    `creator` varchar(64) DEFAULT '',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updater` varchar(64) DEFAULT '',
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `deleted` bit(1) NOT NULL DEFAULT b'0',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='动态表单';

-- 4. OA请假申请
CREATE TABLE IF NOT EXISTS `bpm_oa_leave` (
    `id` bigint NOT NULL AUTO_INCREMENT COMMENT '请假表单主键',
    `user_id` bigint NOT NULL COMMENT '申请人的用户编号',
    `type` tinyint NOT NULL COMMENT '请假类型',
    `reason` varchar(255) NOT NULL COMMENT '原因',
    `start_time` datetime NOT NULL COMMENT '开始时间',
    `end_time` datetime NOT NULL COMMENT '结束时间',
    `day` bigint NOT NULL COMMENT '请假天数',
    `status` tinyint NOT NULL DEFAULT 0 COMMENT '审批结果',
    `process_instance_id` varchar(64) DEFAULT '' COMMENT '流程编号',
    `creator` varchar(64) DEFAULT '',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updater` varchar(64) DEFAULT '',
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `deleted` bit(1) NOT NULL DEFAULT b'0',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='OA请假申请';

-- 5. 流程抄送
CREATE TABLE IF NOT EXISTS `bpm_process_instance_copy` (
    `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
    `start_user_id` bigint NOT NULL COMMENT '发起人Id',
    `process_instance_name` varchar(255) DEFAULT '' COMMENT '流程名',
    `process_instance_id` varchar(64) DEFAULT '' COMMENT '流程实例的编号',
    `process_definition_id` varchar(64) DEFAULT '' COMMENT '流程定义编号',
    `category` varchar(64) DEFAULT '' COMMENT '流程分类',
    `activity_id` varchar(64) DEFAULT '' COMMENT '流程活动的编号',
    `activity_name` varchar(255) DEFAULT '' COMMENT '流程活动的名字',
    `task_id` varchar(64) DEFAULT '' COMMENT '任务编号',
    `user_id` bigint NOT NULL COMMENT '被抄送的用户编号',
    `reason` varchar(255) DEFAULT '' COMMENT '抄送意见',
    `creator` varchar(64) DEFAULT '',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updater` varchar(64) DEFAULT '',
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `deleted` bit(1) NOT NULL DEFAULT b'0',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='流程抄送';

-- 6. BPM 流程监听器
CREATE TABLE IF NOT EXISTS `bpm_process_listener` (
    `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID，自增',
    `name` varchar(63) NOT NULL COMMENT '监听器名字',
    `status` tinyint NOT NULL COMMENT '状态',
    `type` varchar(63) NOT NULL COMMENT '监听类型',
    `event` varchar(63) NOT NULL COMMENT '监听事件',
    `value_type` varchar(63) NOT NULL COMMENT '值类型',
    `value` varchar(255) NOT NULL COMMENT '值',
    `creator` varchar(64) DEFAULT '',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updater` varchar(64) DEFAULT '',
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `deleted` bit(1) NOT NULL DEFAULT b'0',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='BPM流程监听器';

-- 7. BPM 流程表达式
CREATE TABLE IF NOT EXISTS `bpm_process_expression` (
    `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
    `name` varchar(63) NOT NULL COMMENT '表达式名字',
    `status` tinyint NOT NULL COMMENT '表达式状态',
    `expression` varchar(255) NOT NULL COMMENT '表达式',
    `creator` varchar(64) DEFAULT '',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updater` varchar(64) DEFAULT '',
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `deleted` bit(1) NOT NULL DEFAULT b'0',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='BPM流程表达式';

-- 8. BPM 流程定义拓展信息
CREATE TABLE IF NOT EXISTS `bpm_process_definition_info` (
    `id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
    `process_definition_id` varchar(64) NOT NULL COMMENT '流程定义的编号',
    `model_id` varchar(64) NOT NULL COMMENT '流程模型的编号',
    `model_type` tinyint NOT NULL COMMENT '流程模型的类型',
    `category` varchar(64) DEFAULT '' COMMENT '流程分类的编码',
    `icon` varchar(255) DEFAULT '' COMMENT '图标',
    `description` varchar(255) DEFAULT '' COMMENT '描述',
    `form_type` tinyint NOT NULL COMMENT '表单类型',
    `form_id` bigint DEFAULT NULL COMMENT '动态表单编号',
    `form_conf` text COMMENT '表单的配置',
    `form_fields` text COMMENT '表单项的数组',
    `form_custom_create_path` varchar(255) DEFAULT '' COMMENT '自定义表单的提交路径',
    `form_custom_view_path` varchar(255) DEFAULT '' COMMENT '自定义表单的查看路径',
    `simple_model` text COMMENT 'SIMPLE设计器模型数据json格式',
    `visible` bit(1) NOT NULL DEFAULT b'1' COMMENT '是否可见',
    `sort` bigint NOT NULL DEFAULT 0 COMMENT '排序值',
    `start_user_ids` varchar(1024) DEFAULT NULL COMMENT '可发起用户编号数组',
    `start_dept_ids` varchar(1024) DEFAULT NULL COMMENT '可发起部门编号数组',
    `manager_user_ids` varchar(1024) DEFAULT NULL COMMENT '可管理用户编号数组',
    `allow_cancel_running_process` bit(1) NOT NULL DEFAULT b'1' COMMENT '是否允许撤销审批中的申请',
    `allow_withdraw_task` bit(1) NOT NULL DEFAULT b'1' COMMENT '是否允许审批人撤回任务',
    `process_id_rule` text COMMENT '流程ID规则',
    `auto_approval_type` tinyint DEFAULT NULL COMMENT '自动去重类型',
    `title_setting` text COMMENT '标题设置',
    `summary_setting` text COMMENT '摘要设置',
    `process_before_trigger_setting` text COMMENT '流程前置通知设置',
    `process_after_trigger_setting` text COMMENT '流程后置通知设置',
    `task_before_trigger_setting` text COMMENT '任务前置通知设置',
    `task_after_trigger_setting` text COMMENT '任务后置通知设置',
    `print_template_setting` text COMMENT '自定义打印模板设置',
    `creator` varchar(64) DEFAULT '',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updater` varchar(64) DEFAULT '',
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `deleted` bit(1) NOT NULL DEFAULT b'0',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='BPM流程定义拓展信息';

-- =====================================================
-- 二、HRM 模块业务表（50张）
-- =====================================================

-- 1. 员工档案
CREATE TABLE IF NOT EXISTS `hrm_employee` (
    `id` bigint NOT NULL AUTO_INCREMENT,
    `name` varchar(255) NOT NULL,
    `job_number` varchar(64) DEFAULT NULL,
    `user_id` bigint DEFAULT NULL,
    `mobile` varchar(255) DEFAULT NULL,
    `country` varchar(64) DEFAULT NULL,
    `nation` varchar(64) DEFAULT NULL,
    `id_type` tinyint DEFAULT NULL,
    `id_number` varchar(255) DEFAULT NULL,
    `sex` tinyint DEFAULT NULL,
    `email` varchar(255) DEFAULT NULL,
    `native_place` varchar(128) DEFAULT NULL,
    `birthday` datetime DEFAULT NULL,
    `age` int DEFAULT NULL,
    `address` varchar(255) DEFAULT NULL,
    `highest_education` tinyint DEFAULT NULL,
    `dept_id` bigint DEFAULT NULL,
    `leader_employee_id` bigint DEFAULT NULL,
    `entry_status` tinyint DEFAULT NULL,
    `status` tinyint DEFAULT NULL,
    `type` tinyint DEFAULT NULL,
    `entry_time` datetime DEFAULT NULL,
    `probation` int DEFAULT NULL,
    `regular_time` datetime DEFAULT NULL,
    `leave_time` datetime DEFAULT NULL,
    `post_name` varchar(255) DEFAULT NULL,
    `post_level` varchar(255) DEFAULT NULL,
    `work_city` varchar(64) DEFAULT NULL,
    `work_address` varchar(255) DEFAULT NULL,
    `work_detail_address` varchar(255) DEFAULT NULL,
    `channel_id` bigint DEFAULT NULL,
    `company_age_start_time` datetime DEFAULT NULL,
    `company_age` int DEFAULT NULL,
    `candidate_id` bigint DEFAULT NULL,
    `remark` varchar(500) DEFAULT NULL,
    `creator` varchar(64) DEFAULT '',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updater` varchar(64) DEFAULT '',
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `deleted` bit(1) NOT NULL DEFAULT b'0',
    `tenant_id` bigint NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 2. 员工教育经历
CREATE TABLE IF NOT EXISTS `hrm_employee_education_experience` (
    `id` bigint NOT NULL AUTO_INCREMENT,
    `employee_id` bigint NOT NULL,
    `education` tinyint DEFAULT NULL,
    `graduate_school` varchar(255) DEFAULT NULL,
    `major` varchar(255) DEFAULT NULL,
    `admission_time` datetime DEFAULT NULL,
    `graduation_time` datetime DEFAULT NULL,
    `teaching_methods` tinyint DEFAULT NULL,
    `first_degree` tinyint(1) DEFAULT NULL,
    `sort` int DEFAULT NULL,
    `creator` varchar(64) DEFAULT '',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updater` varchar(64) DEFAULT '',
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `deleted` bit(1) NOT NULL DEFAULT b'0',
    `tenant_id` bigint NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 3. 员工工作经历
CREATE TABLE IF NOT EXISTS `hrm_employee_work_experience` (
    `id` bigint NOT NULL AUTO_INCREMENT,
    `employee_id` bigint NOT NULL,
    `work_unit` varchar(255) DEFAULT NULL,
    `post_name` varchar(255) DEFAULT NULL,
    `start_time` datetime DEFAULT NULL,
    `end_time` datetime DEFAULT NULL,
    `reason` varchar(1024) DEFAULT NULL,
    `witness_name` varchar(255) DEFAULT NULL,
    `witness_phone` varchar(32) DEFAULT NULL,
    `remark` varchar(500) DEFAULT NULL,
    `sort` int DEFAULT NULL,
    `creator` varchar(64) DEFAULT '',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updater` varchar(64) DEFAULT '',
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `deleted` bit(1) NOT NULL DEFAULT b'0',
    `tenant_id` bigint NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 4. 员工培训经历
CREATE TABLE IF NOT EXISTS `hrm_employee_training_experience` (
    `id` bigint NOT NULL AUTO_INCREMENT,
    `employee_id` bigint NOT NULL,
    `course` varchar(128) DEFAULT NULL,
    `organization_name` varchar(128) DEFAULT NULL,
    `start_time` datetime DEFAULT NULL,
    `end_time` datetime DEFAULT NULL,
    `duration` varchar(64) DEFAULT NULL,
    `result` varchar(64) DEFAULT NULL,
    `certificate_name` varchar(128) DEFAULT NULL,
    `remark` varchar(500) DEFAULT NULL,
    `sort` int DEFAULT NULL,
    `creator` varchar(64) DEFAULT '',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updater` varchar(64) DEFAULT '',
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `deleted` bit(1) NOT NULL DEFAULT b'0',
    `tenant_id` bigint NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 5. 员工证书
CREATE TABLE IF NOT EXISTS `hrm_employee_certificate` (
    `id` bigint NOT NULL AUTO_INCREMENT,
    `employee_id` bigint NOT NULL,
    `name` varchar(255) DEFAULT NULL,
    `level` varchar(255) DEFAULT NULL,
    `no` varchar(255) DEFAULT NULL,
    `start_time` datetime DEFAULT NULL,
    `end_time` datetime DEFAULT NULL,
    `issuing_authority` varchar(255) DEFAULT NULL,
    `issuing_time` datetime DEFAULT NULL,
    `remark` varchar(500) DEFAULT NULL,
    `sort` int DEFAULT NULL,
    `creator` varchar(64) DEFAULT '',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updater` varchar(64) DEFAULT '',
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `deleted` bit(1) NOT NULL DEFAULT b'0',
    `tenant_id` bigint NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 6. 员工联系人
CREATE TABLE IF NOT EXISTS `hrm_employee_contact` (
    `id` bigint NOT NULL AUTO_INCREMENT,
    `employee_id` bigint NOT NULL,
    `name` varchar(64) DEFAULT NULL,
    `relation` varchar(64) DEFAULT NULL,
    `phone` varchar(40) DEFAULT NULL,
    `work_unit` varchar(128) DEFAULT NULL,
    `post_name` varchar(128) DEFAULT NULL,
    `address` varchar(255) DEFAULT NULL,
    `sort` int DEFAULT NULL,
    `creator` varchar(64) DEFAULT '',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updater` varchar(64) DEFAULT '',
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `deleted` bit(1) NOT NULL DEFAULT b'0',
    `tenant_id` bigint NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 7. 员工合同
CREATE TABLE IF NOT EXISTS `hrm_employee_contract` (
    `id` bigint NOT NULL AUTO_INCREMENT,
    `employee_id` bigint NOT NULL,
    `no` varchar(128) DEFAULT NULL,
    `type` tinyint DEFAULT NULL,
    `start_time` datetime DEFAULT NULL,
    `end_time` datetime DEFAULT NULL,
    `term` int DEFAULT NULL,
    `status` tinyint DEFAULT NULL,
    `sign_company` varchar(255) DEFAULT NULL,
    `sign_time` datetime DEFAULT NULL,
    `remark` varchar(500) DEFAULT NULL,
    `expire_remind` tinyint(1) DEFAULT NULL,
    `sort` int DEFAULT NULL,
    `file_urls` varchar(2048) DEFAULT NULL,
    `creator` varchar(64) DEFAULT '',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updater` varchar(64) DEFAULT '',
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `deleted` bit(1) NOT NULL DEFAULT b'0',
    `tenant_id` bigint NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 8. 员工文件
CREATE TABLE IF NOT EXISTS `hrm_employee_file` (
    `id` bigint NOT NULL AUTO_INCREMENT,
    `employee_id` bigint NOT NULL,
    `type` tinyint NOT NULL,
    `url` varchar(512) NOT NULL,
    `creator` varchar(64) DEFAULT '',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updater` varchar(64) DEFAULT '',
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `deleted` bit(1) NOT NULL DEFAULT b'0',
    `tenant_id` bigint NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 9. 员工变更记录
CREATE TABLE IF NOT EXISTS `hrm_employee_change_record` (
    `id` bigint NOT NULL AUTO_INCREMENT,
    `employee_id` bigint NOT NULL,
    `type` tinyint DEFAULT NULL,
    `reason` tinyint DEFAULT NULL,
    `old_dept_id` bigint DEFAULT NULL,
    `new_dept_id` bigint DEFAULT NULL,
    `old_post_name` varchar(255) DEFAULT NULL,
    `new_post_name` varchar(255) DEFAULT NULL,
    `old_post_level` varchar(255) DEFAULT NULL,
    `new_post_level` varchar(255) DEFAULT NULL,
    `old_work_address` varchar(255) DEFAULT NULL,
    `new_work_address` varchar(255) DEFAULT NULL,
    `old_leader_employee_id` bigint DEFAULT NULL,
    `new_leader_employee_id` bigint DEFAULT NULL,
    `probation` int DEFAULT NULL,
    `effect_time` datetime DEFAULT NULL,
    `applied_time` datetime DEFAULT NULL,
    `remark` varchar(500) DEFAULT NULL,
    `creator` varchar(64) DEFAULT '',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updater` varchar(64) DEFAULT '',
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `deleted` bit(1) NOT NULL DEFAULT b'0',
    `tenant_id` bigint NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 10. 员工离职信息
CREATE TABLE IF NOT EXISTS `hrm_employee_quit_info` (
    `id` bigint NOT NULL AUTO_INCREMENT,
    `employee_id` bigint NOT NULL,
    `plan_quit_time` datetime DEFAULT NULL,
    `apply_quit_time` datetime DEFAULT NULL,
    `salary_settlement_time` datetime DEFAULT NULL,
    `type` tinyint DEFAULT NULL,
    `reason` tinyint DEFAULT NULL,
    `remark` varchar(500) DEFAULT NULL,
    `old_employee_status` tinyint DEFAULT NULL,
    `creator` varchar(64) DEFAULT '',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updater` varchar(64) DEFAULT '',
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `deleted` bit(1) NOT NULL DEFAULT b'0',
    `tenant_id` bigint NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 11. 考勤请假记录
CREATE TABLE IF NOT EXISTS `hrm_attendance_leave` (
    `id` bigint NOT NULL AUTO_INCREMENT,
    `employee_id` bigint NOT NULL,
    `type` varchar(64) DEFAULT NULL,
    `start_time` datetime DEFAULT NULL,
    `end_time` datetime DEFAULT NULL,
    `day` decimal(10, 2) DEFAULT NULL,
    `reason` varchar(300) DEFAULT NULL,
    `remark` varchar(500) DEFAULT NULL,
    `approval_status` tinyint NOT NULL,
    `process_instance_id` varchar(64) DEFAULT NULL,
    `approval_time` datetime DEFAULT NULL,
    `approval_reason` varchar(500) DEFAULT NULL,
    `creator` varchar(64) DEFAULT '',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updater` varchar(64) DEFAULT '',
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `deleted` bit(1) NOT NULL DEFAULT b'0',
    `tenant_id` bigint NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_hrm_attendance_leave_process_instance_id` (`process_instance_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 12. HRM配置
CREATE TABLE IF NOT EXISTS `hrm_config` (
    `id` bigint NOT NULL AUTO_INCREMENT,
    `type` tinyint NOT NULL,
    `value` varchar(255) NOT NULL,
    `sort` int DEFAULT NULL,
    `creator` varchar(64) DEFAULT '',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updater` varchar(64) DEFAULT '',
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `deleted` bit(1) NOT NULL DEFAULT b'0',
    `tenant_id` bigint NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 13. 员工个人备注
CREATE TABLE IF NOT EXISTS `hrm_employee_personal_note` (
    `id` bigint NOT NULL AUTO_INCREMENT,
    `employee_id` bigint NOT NULL,
    `content` varchar(1024) NOT NULL,
    `reminder_time` datetime NOT NULL,
    `creator` varchar(64) DEFAULT '',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updater` varchar(64) DEFAULT '',
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `deleted` bit(1) NOT NULL DEFAULT b'0',
    `tenant_id` bigint NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 14. 招聘职位类型
CREATE TABLE IF NOT EXISTS `hrm_recruit_post_type` (
    `id` bigint NOT NULL AUTO_INCREMENT,
    `name` varchar(40) DEFAULT NULL,
    `parent_id` bigint DEFAULT NULL,
    `sort` int DEFAULT NULL,
    `status` tinyint DEFAULT NULL,
    `creator` varchar(64) DEFAULT '',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updater` varchar(64) DEFAULT '',
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `deleted` bit(1) NOT NULL DEFAULT b'0',
    `tenant_id` bigint NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 15. 招聘渠道
CREATE TABLE IF NOT EXISTS `hrm_recruit_channel` (
    `id` bigint NOT NULL AUTO_INCREMENT,
    `system_flag` bit(1) DEFAULT b'0',
    `status` tinyint DEFAULT NULL,
    `name` varchar(255) NOT NULL,
    `sort` int DEFAULT NULL,
    `remark` varchar(500) DEFAULT NULL,
    `creator` varchar(64) DEFAULT '',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updater` varchar(64) DEFAULT '',
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `deleted` bit(1) NOT NULL DEFAULT b'0',
    `tenant_id` bigint NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 16. 招聘职位
CREATE TABLE IF NOT EXISTS `hrm_recruit_post` (
    `id` bigint NOT NULL AUTO_INCREMENT,
    `post_name` varchar(255) NOT NULL,
    `dept_id` bigint DEFAULT NULL,
    `job_nature` tinyint DEFAULT NULL,
    `area_id` int DEFAULT NULL,
    `recruit_num` int DEFAULT NULL,
    `reason` varchar(255) DEFAULT NULL,
    `work_time` tinyint DEFAULT NULL,
    `education_require` tinyint DEFAULT NULL,
    `min_salary` decimal(10, 2) DEFAULT NULL,
    `max_salary` decimal(10, 2) DEFAULT NULL,
    `salary_unit` tinyint DEFAULT NULL,
    `min_age` int DEFAULT NULL,
    `max_age` int DEFAULT NULL,
    `latest_entry_time` datetime DEFAULT NULL,
    `owner_employee_id` bigint DEFAULT NULL,
    `interview_employee_ids` varchar(255) DEFAULT NULL,
    `description` TEXT DEFAULT NULL,
    `emergency_level` tinyint DEFAULT NULL,
    `post_type_id` bigint DEFAULT NULL,
    `status` tinyint DEFAULT NULL,
    `stop_reason` varchar(255) DEFAULT NULL,
    `creator` varchar(64) DEFAULT '',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updater` varchar(64) DEFAULT '',
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `deleted` bit(1) NOT NULL DEFAULT b'0',
    `tenant_id` bigint NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 17. 招聘候选人
CREATE TABLE IF NOT EXISTS `hrm_recruit_candidate` (
    `id` bigint NOT NULL AUTO_INCREMENT,
    `name` varchar(255) NOT NULL,
    `mobile` varchar(255) NOT NULL,
    `sex` tinyint NOT NULL,
    `age` int DEFAULT NULL,
    `email` varchar(255) DEFAULT NULL,
    `post_id` bigint NOT NULL,
    `stage_number` int DEFAULT NULL,
    `work_time` int DEFAULT NULL,
    `education` tinyint NOT NULL,
    `graduate_school` varchar(255) DEFAULT NULL,
    `latest_work_place` varchar(255) DEFAULT NULL,
    `channel_id` bigint DEFAULT NULL,
    `remark` varchar(255) DEFAULT NULL,
    `status` tinyint DEFAULT NULL,
    `eliminate` varchar(255) DEFAULT NULL,
    `status_update_time` datetime DEFAULT NULL,
    `entry_time` datetime DEFAULT NULL,
    `resume_urls` TEXT DEFAULT NULL,
    `creator` varchar(64) DEFAULT '',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updater` varchar(64) DEFAULT '',
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `deleted` bit(1) NOT NULL DEFAULT b'0',
    `tenant_id` bigint NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 18. 招聘面试
CREATE TABLE IF NOT EXISTS `hrm_recruit_interview` (
    `id` bigint NOT NULL AUTO_INCREMENT,
    `candidate_id` bigint NOT NULL,
    `type` tinyint DEFAULT NULL,
    `stage_number` int DEFAULT NULL,
    `interview_employee_id` bigint DEFAULT NULL,
    `other_interview_employee_ids` varchar(255) DEFAULT NULL,
    `interview_time` datetime DEFAULT NULL,
    `address` varchar(255) DEFAULT NULL,
    `remark` varchar(500) DEFAULT NULL,
    `result` tinyint DEFAULT NULL,
    `evaluate` varchar(255) DEFAULT NULL,
    `cancel_reason` varchar(255) DEFAULT NULL,
    `creator` varchar(64) DEFAULT '',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updater` varchar(64) DEFAULT '',
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `deleted` bit(1) NOT NULL DEFAULT b'0',
    `tenant_id` bigint NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 19. 考勤组
CREATE TABLE IF NOT EXISTS `hrm_attendance_group` (
    `id` bigint NOT NULL AUTO_INCREMENT,
    `name` varchar(50) NOT NULL,
    `dept_ids` TEXT DEFAULT NULL,
    `employee_ids` TEXT DEFAULT NULL,
    `open_wifi_card` tinyint(1) NOT NULL DEFAULT 0,
    `open_point_card` tinyint(1) NOT NULL DEFAULT 0,
    `shifts` TEXT NOT NULL,
    `rest` tinyint(1) NOT NULL DEFAULT 1,
    `special_dates` TEXT NOT NULL,
    `points` TEXT NOT NULL,
    `wifis` TEXT NOT NULL,
    `deduct_rule` TEXT NOT NULL,
    `default_status` tinyint(1) NOT NULL DEFAULT 0,
    `creator` varchar(64) DEFAULT '',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updater` varchar(64) DEFAULT '',
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `deleted` bit(1) NOT NULL DEFAULT b'0',
    `tenant_id` bigint NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 20. 考勤节假日
CREATE TABLE IF NOT EXISTS `hrm_attendance_holiday` (
    `id` bigint NOT NULL AUTO_INCREMENT,
    `date` datetime NOT NULL,
    `type` tinyint DEFAULT 2,
    `creator` varchar(64) DEFAULT '',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updater` varchar(64) DEFAULT '',
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `deleted` bit(1) NOT NULL DEFAULT b'0',
    `tenant_id` bigint NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 21. 考勤打卡记录
CREATE TABLE IF NOT EXISTS `hrm_attendance_clock` (
    `id` bigint NOT NULL AUTO_INCREMENT,
    `employee_id` bigint DEFAULT NULL,
    `clock_time` datetime NOT NULL,
    `type` tinyint NOT NULL,
    `attendance_time` datetime NOT NULL,
    `source_type` tinyint DEFAULT 2,
    `status` tinyint DEFAULT 0,
    `stage` int DEFAULT 1,
    `address` varchar(255) DEFAULT NULL,
    `longitude` decimal(10, 6) DEFAULT NULL,
    `latitude` decimal(10, 6) DEFAULT NULL,
    `ssid` varchar(50) DEFAULT NULL,
    `mac` varchar(50) DEFAULT NULL,
    `remark` varchar(255) DEFAULT NULL,
    `creator` varchar(64) DEFAULT '',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updater` varchar(64) DEFAULT '',
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `deleted` bit(1) NOT NULL DEFAULT b'0',
    `tenant_id` bigint NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 22. 薪资配置
CREATE TABLE IF NOT EXISTS `hrm_salary_config` (
    `id` bigint NOT NULL AUTO_INCREMENT,
    `cycle_start_day` int DEFAULT NULL,
    `cycle_end_day` int DEFAULT NULL,
    `social_security_month_type` tinyint DEFAULT NULL,
    `start_year` int DEFAULT NULL,
    `start_month` int DEFAULT NULL,
    `creator` varchar(64) DEFAULT '',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updater` varchar(64) DEFAULT '',
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `deleted` bit(1) NOT NULL DEFAULT b'0',
    `tenant_id` bigint NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_hrm_salary_config_tenant_id` (`tenant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 23. 薪资计税规则
CREATE TABLE IF NOT EXISTS `hrm_salary_tax_rule` (
    `id` bigint NOT NULL AUTO_INCREMENT,
    `name` varchar(64) NOT NULL,
    `type` tinyint DEFAULT NULL,
    `tax_enabled` bit(1) DEFAULT NULL,
    `threshold` decimal(12, 2) DEFAULT NULL,
    `decimal_scale` int DEFAULT NULL,
    `cycle_type` tinyint DEFAULT NULL,
    `creator` varchar(64) DEFAULT '',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updater` varchar(64) DEFAULT '',
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `deleted` bit(1) NOT NULL DEFAULT b'0',
    `tenant_id` bigint NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 24. 薪资组
CREATE TABLE IF NOT EXISTS `hrm_salary_group` (
    `id` bigint NOT NULL AUTO_INCREMENT,
    `name` varchar(64) NOT NULL,
    `salary_standard` decimal(12, 2) DEFAULT NULL,
    `change_rule` varchar(255) DEFAULT NULL,
    `dept_ids` TEXT DEFAULT NULL,
    `employee_ids` TEXT DEFAULT NULL,
    `tax_rule_id` bigint DEFAULT NULL,
    `creator` varchar(64) DEFAULT '',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updater` varchar(64) DEFAULT '',
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `deleted` bit(1) NOT NULL DEFAULT b'0',
    `tenant_id` bigint NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 25. 薪资项模板
CREATE TABLE IF NOT EXISTS `hrm_salary_option_template` (
    `id` bigint NOT NULL AUTO_INCREMENT,
    `code` int NOT NULL,
    `parent_code` int NOT NULL DEFAULT 0,
    `name` varchar(64) NOT NULL,
    `remark` varchar(255) DEFAULT NULL,
    `system_flag` tinyint(1) NOT NULL DEFAULT 0,
    `type` tinyint NOT NULL DEFAULT 1,
    `tax_enabled` tinyint(1) NOT NULL DEFAULT 1,
    `visible` tinyint(1) NOT NULL DEFAULT 1,
    `calculate_enabled` tinyint(1) NOT NULL DEFAULT 1,
    `creator` varchar(64) DEFAULT '',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updater` varchar(64) DEFAULT '',
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `deleted` bit(1) NOT NULL DEFAULT b'0',
    `tenant_id` bigint NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_hrm_salary_option_template_code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 26. 薪资项
CREATE TABLE IF NOT EXISTS `hrm_salary_option` (
    `id` bigint NOT NULL AUTO_INCREMENT,
    `code` int NOT NULL,
    `parent_code` int NOT NULL DEFAULT 0,
    `name` varchar(64) NOT NULL,
    `remark` varchar(255) DEFAULT NULL,
    `system_flag` tinyint(1) NOT NULL DEFAULT 0,
    `template_id` bigint DEFAULT NULL,
    `type` tinyint NOT NULL DEFAULT 1,
    `tax_enabled` tinyint(1) NOT NULL DEFAULT 1,
    `visible` tinyint(1) NOT NULL DEFAULT 1,
    `calculate_enabled` tinyint(1) NOT NULL DEFAULT 1,
    `enabled` tinyint(1) NOT NULL DEFAULT 1,
    `creator` varchar(64) DEFAULT '',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updater` varchar(64) DEFAULT '',
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `deleted` bit(1) NOT NULL DEFAULT b'0',
    `tenant_id` bigint NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_hrm_salary_option_tenant_code` (`tenant_id`, `code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 27. 员工薪资档案
CREATE TABLE IF NOT EXISTS `hrm_salary_employee_info` (
    `id` bigint NOT NULL AUTO_INCREMENT,
    `employee_id` bigint NOT NULL,
    `change_reason` tinyint DEFAULT NULL,
    `effect_time` datetime DEFAULT NULL,
    `change_type` tinyint DEFAULT NULL,
    `probation_salary` decimal(12, 2) DEFAULT NULL,
    `regular_salary` decimal(12, 2) DEFAULT NULL,
    `remark` varchar(500) DEFAULT NULL,
    `salary_options` TEXT DEFAULT NULL,
    `probation_salary_options` TEXT DEFAULT NULL,
    `creator` varchar(64) DEFAULT '',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updater` varchar(64) DEFAULT '',
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `deleted` bit(1) NOT NULL DEFAULT b'0',
    `tenant_id` bigint NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_hrm_salary_employee_info_employee_id` (`employee_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 28. 薪资调整记录
CREATE TABLE IF NOT EXISTS `hrm_salary_change_record` (
    `id` bigint NOT NULL AUTO_INCREMENT,
    `employee_id` bigint NOT NULL,
    `type` tinyint DEFAULT NULL,
    `reason` tinyint DEFAULT NULL,
    `effect_time` datetime DEFAULT NULL,
    `before_total` decimal(12, 2) DEFAULT NULL,
    `after_total` decimal(12, 2) DEFAULT NULL,
    `probation_before_total` decimal(12, 2) DEFAULT NULL,
    `probation_after_total` decimal(12, 2) DEFAULT NULL,
    `salary_options` TEXT DEFAULT NULL,
    `probation_salary_options` TEXT DEFAULT NULL,
    `status` tinyint DEFAULT NULL,
    `remark` varchar(500) DEFAULT NULL,
    `creator` varchar(64) DEFAULT '',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updater` varchar(64) DEFAULT '',
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `deleted` bit(1) NOT NULL DEFAULT b'0',
    `tenant_id` bigint NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 29. 薪资调整模板
CREATE TABLE IF NOT EXISTS `hrm_salary_change_template` (
    `id` bigint NOT NULL AUTO_INCREMENT,
    `name` varchar(64) NOT NULL,
    `default_status` tinyint(1) NOT NULL DEFAULT 0,
    `options` TEXT DEFAULT NULL,
    `creator` varchar(64) DEFAULT '',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updater` varchar(64) DEFAULT '',
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `deleted` bit(1) NOT NULL DEFAULT b'0',
    `tenant_id` bigint NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 30. 薪资月度记录
CREATE TABLE IF NOT EXISTS `hrm_salary_month_record` (
    `id` bigint NOT NULL AUTO_INCREMENT,
    `title` varchar(128) DEFAULT NULL,
    `year` int NOT NULL,
    `month` int NOT NULL,
    `employee_count` int DEFAULT NULL,
    `start_time` datetime DEFAULT NULL,
    `end_time` datetime DEFAULT NULL,
    `expected_pay_salary` decimal(12, 2) DEFAULT NULL,
    `personal_tax` decimal(12, 2) DEFAULT NULL,
    `real_pay_salary` decimal(12, 2) DEFAULT NULL,
    `personal_insurance_amount` decimal(12, 2) DEFAULT NULL,
    `personal_provident_fund_amount` decimal(12, 2) DEFAULT NULL,
    `corporate_insurance_amount` decimal(12, 2) DEFAULT NULL,
    `corporate_provident_fund_amount` decimal(12, 2) DEFAULT NULL,
    `option_headers` TEXT DEFAULT NULL,
    `status` tinyint DEFAULT NULL,
    `creator` varchar(64) DEFAULT '',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updater` varchar(64) DEFAULT '',
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `deleted` bit(1) NOT NULL DEFAULT b'0',
    `tenant_id` bigint NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 31. 薪资月度员工记录
CREATE TABLE IF NOT EXISTS `hrm_salary_month_employee_record` (
    `id` bigint NOT NULL AUTO_INCREMENT,
    `month_record_id` bigint NOT NULL,
    `employee_id` bigint NOT NULL,
    `actual_work_day` decimal(10, 2) DEFAULT NULL,
    `need_work_day` decimal(10, 2) DEFAULT NULL,
    `year` int NOT NULL,
    `month` int NOT NULL,
    `expected_pay_salary` decimal(12, 2) DEFAULT NULL,
    `taxable_salary` decimal(12, 2) DEFAULT NULL,
    `personal_tax` decimal(12, 2) DEFAULT NULL,
    `real_pay_salary` decimal(12, 2) DEFAULT NULL,
    `option_values` TEXT DEFAULT NULL,
    `creator` varchar(64) DEFAULT '',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updater` varchar(64) DEFAULT '',
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `deleted` bit(1) NOT NULL DEFAULT b'0',
    `tenant_id` bigint NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 32. 工资条模板
CREATE TABLE IF NOT EXISTS `hrm_salary_slip_template` (
    `id` bigint NOT NULL AUTO_INCREMENT,
    `name` varchar(64) NOT NULL,
    `hide_empty` tinyint(1) NOT NULL DEFAULT 0,
    `default_status` tinyint(1) NOT NULL DEFAULT 0,
    `options` TEXT NOT NULL,
    `creator` varchar(64) DEFAULT '',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updater` varchar(64) DEFAULT '',
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `deleted` bit(1) NOT NULL DEFAULT b'0',
    `tenant_id` bigint NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 33. 工资条发送记录
CREATE TABLE IF NOT EXISTS `hrm_salary_slip_send_record` (
    `id` bigint NOT NULL AUTO_INCREMENT,
    `month_record_id` bigint NOT NULL,
    `employee_count` int DEFAULT NULL,
    `send_employee_count` int DEFAULT NULL,
    `year` int NOT NULL,
    `month` int NOT NULL,
    `creator` varchar(64) DEFAULT '',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updater` varchar(64) DEFAULT '',
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `deleted` bit(1) NOT NULL DEFAULT b'0',
    `tenant_id` bigint NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 34. 工资条
CREATE TABLE IF NOT EXISTS `hrm_salary_slip` (
    `id` bigint NOT NULL AUTO_INCREMENT,
    `send_record_id` bigint NOT NULL,
    `month_employee_record_id` bigint NOT NULL,
    `employee_id` bigint NOT NULL,
    `year` int NOT NULL,
    `month` int NOT NULL,
    `read_status` tinyint DEFAULT NULL,
    `real_pay_salary` decimal(12, 2) DEFAULT NULL,
    `remark` varchar(500) DEFAULT NULL,
    `options` TEXT NOT NULL,
    `creator` varchar(64) DEFAULT '',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updater` varchar(64) DEFAULT '',
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `deleted` bit(1) NOT NULL DEFAULT b'0',
    `tenant_id` bigint NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 35. 社保方案
CREATE TABLE IF NOT EXISTS `hrm_insurance_scheme` (
    `id` bigint NOT NULL AUTO_INCREMENT,
    `name` varchar(64) NOT NULL,
    `area_id` int DEFAULT NULL,
    `household_type` varchar(64) DEFAULT NULL,
    `type` tinyint NOT NULL,
    `creator` varchar(64) DEFAULT '',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updater` varchar(64) DEFAULT '',
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `deleted` bit(1) NOT NULL DEFAULT b'0',
    `tenant_id` bigint NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 36. 社保方案项目
CREATE TABLE IF NOT EXISTS `hrm_insurance_scheme_project` (
    `id` bigint NOT NULL AUTO_INCREMENT,
    `scheme_id` bigint NOT NULL,
    `type` tinyint NOT NULL,
    `name` varchar(64) NOT NULL,
    `base_amount` decimal(12, 2) DEFAULT NULL,
    `corporate_rate` decimal(10, 2) DEFAULT NULL,
    `personal_rate` decimal(10, 2) DEFAULT NULL,
    `corporate_amount` decimal(12, 2) DEFAULT NULL,
    `personal_amount` decimal(12, 2) DEFAULT NULL,
    `creator` varchar(64) DEFAULT '',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updater` varchar(64) DEFAULT '',
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `deleted` bit(1) NOT NULL DEFAULT b'0',
    `tenant_id` bigint NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 37. 员工社保信息
CREATE TABLE IF NOT EXISTS `hrm_insurance_employee_info` (
    `id` bigint NOT NULL AUTO_INCREMENT,
    `employee_id` bigint NOT NULL,
    `first_social_security` tinyint(1) NOT NULL DEFAULT 0,
    `first_accumulation_fund` tinyint(1) NOT NULL DEFAULT 0,
    `social_security_number` varchar(64) DEFAULT NULL,
    `accumulation_fund_number` varchar(64) DEFAULT NULL,
    `social_security_start_month` datetime DEFAULT NULL,
    `scheme_id` bigint DEFAULT NULL,
    `creator` varchar(64) DEFAULT '',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updater` varchar(64) DEFAULT '',
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `deleted` bit(1) NOT NULL DEFAULT b'0',
    `tenant_id` bigint NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 38. 员工银行卡
CREATE TABLE IF NOT EXISTS `hrm_employee_salary_card` (
    `id` bigint NOT NULL AUTO_INCREMENT,
    `employee_id` bigint NOT NULL,
    `bank_card_number` varchar(64) DEFAULT NULL,
    `bank_area_id` int DEFAULT NULL,
    `bank_name` varchar(64) DEFAULT NULL,
    `bank_branch_name` varchar(128) DEFAULT NULL,
    `creator` varchar(64) DEFAULT '',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updater` varchar(64) DEFAULT '',
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `deleted` bit(1) NOT NULL DEFAULT b'0',
    `tenant_id` bigint NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 39. 社保月度记录
CREATE TABLE IF NOT EXISTS `hrm_insurance_month_record` (
    `id` bigint NOT NULL AUTO_INCREMENT,
    `title` varchar(128) DEFAULT NULL,
    `year` int NOT NULL,
    `month` int NOT NULL,
    `insured_employee_count` int DEFAULT NULL,
    `stopped_employee_count` int DEFAULT NULL,
    `status` tinyint DEFAULT NULL,
    `personal_insurance_amount` decimal(12, 2) DEFAULT NULL,
    `personal_provident_fund_amount` decimal(12, 2) DEFAULT NULL,
    `corporate_insurance_amount` decimal(12, 2) DEFAULT NULL,
    `corporate_provident_fund_amount` decimal(12, 2) DEFAULT NULL,
    `creator` varchar(64) DEFAULT '',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updater` varchar(64) DEFAULT '',
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `deleted` bit(1) NOT NULL DEFAULT b'0',
    `tenant_id` bigint NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 40. 社保月度员工记录
CREATE TABLE IF NOT EXISTS `hrm_insurance_month_employee_record` (
    `id` bigint NOT NULL AUTO_INCREMENT,
    `month_record_id` bigint NOT NULL,
    `employee_id` bigint NOT NULL,
    `scheme_id` bigint DEFAULT NULL,
    `year` int NOT NULL,
    `month` int NOT NULL,
    `personal_insurance_amount` decimal(12, 2) DEFAULT NULL,
    `personal_provident_fund_amount` decimal(12, 2) DEFAULT NULL,
    `corporate_insurance_amount` decimal(12, 2) DEFAULT NULL,
    `corporate_provident_fund_amount` decimal(12, 2) DEFAULT NULL,
    `status` tinyint DEFAULT NULL,
    `projects` TEXT NOT NULL,
    `creator` varchar(64) DEFAULT '',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updater` varchar(64) DEFAULT '',
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `deleted` bit(1) NOT NULL DEFAULT b'0',
    `tenant_id` bigint NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 41. 绩效考核模板
CREATE TABLE IF NOT EXISTS `hrm_performance_assessment_template` (
    `id` bigint NOT NULL AUTO_INCREMENT,
    `name` varchar(500) NOT NULL,
    `illustrate` varchar(1000) DEFAULT NULL,
    `score_calculation` tinyint DEFAULT 1,
    `upper_limit_type` tinyint DEFAULT 0,
    `upper_limit_score` decimal(10, 2) DEFAULT 100.00,
    `dimension_count` int DEFAULT 0,
    `quota_count` int DEFAULT 0,
    `dimensions` TEXT NOT NULL,
    `status` tinyint DEFAULT 0,
    `creator` varchar(64) DEFAULT '',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updater` varchar(64) DEFAULT '',
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `deleted` bit(1) NOT NULL DEFAULT b'0',
    `tenant_id` bigint NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 42. 绩效结果模板
CREATE TABLE IF NOT EXISTS `hrm_performance_result_template` (
    `id` bigint NOT NULL AUTO_INCREMENT,
    `name` varchar(255) NOT NULL,
    `levels` TEXT NOT NULL,
    `status` tinyint DEFAULT 0,
    `creator` varchar(64) DEFAULT '',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updater` varchar(64) DEFAULT '',
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `deleted` bit(1) NOT NULL DEFAULT b'0',
    `tenant_id` bigint NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 43. 绩效计划
CREATE TABLE IF NOT EXISTS `hrm_performance_plan` (
    `id` bigint NOT NULL AUTO_INCREMENT,
    `name` varchar(255) NOT NULL,
    `cycle_type` tinyint DEFAULT NULL,
    `cycle` varchar(255) DEFAULT NULL,
    `quarter` tinyint DEFAULT NULL,
    `start_time` datetime DEFAULT NULL,
    `end_time` datetime DEFAULT NULL,
    `description` varchar(1000) DEFAULT NULL,
    `scopes` TEXT NOT NULL,
    `assessment_template_id` bigint NOT NULL,
    `assessment_config` TEXT NOT NULL,
    `result_template_id` bigint NOT NULL,
    `result_config` TEXT NOT NULL,
    `quota_setting_type` tinyint NOT NULL DEFAULT 1,
    `target_confirmation` bit(1) NOT NULL DEFAULT b'0',
    `target_confirmation_stage` TEXT DEFAULT NULL,
    `review_stages` TEXT NOT NULL,
    `result_audit` bit(1) NOT NULL DEFAULT b'1',
    `result_audit_stages` TEXT DEFAULT NULL,
    `result_confirmation` bit(1) NOT NULL DEFAULT b'1',
    `appeal_stages` TEXT DEFAULT NULL,
    `appeal_timeout_days` int NOT NULL DEFAULT 2,
    `appeal_timeout_action` tinyint NOT NULL DEFAULT 1,
    `sync_to_salary` bit(1) DEFAULT b'0',
    `paid_for_month` varchar(20) DEFAULT NULL,
    `stage_type` tinyint DEFAULT 0,
    `status` tinyint DEFAULT 2,
    `operation_type` tinyint DEFAULT NULL,
    `terminate_time` datetime DEFAULT NULL,
    `creator` varchar(64) DEFAULT '',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updater` varchar(64) DEFAULT '',
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `deleted` bit(1) NOT NULL DEFAULT b'0',
    `tenant_id` bigint NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 44. 绩效考核
CREATE TABLE IF NOT EXISTS `hrm_performance_assessment` (
    `id` bigint NOT NULL AUTO_INCREMENT,
    `plan_id` bigint NOT NULL,
    `employee_id` bigint NOT NULL,
    `status` tinyint DEFAULT 2,
    `process_status` tinyint DEFAULT 1,
    `stage_type` tinyint DEFAULT 0,
    `stage_sort` int DEFAULT 0,
    `score` decimal(10, 2) DEFAULT 0.00,
    `result_level` varchar(64) DEFAULT NULL,
    `coefficient` decimal(10, 2) DEFAULT 1.00,
    `target_confirmation_result` tinyint DEFAULT NULL,
    `target_confirmation_comment` varchar(1000) DEFAULT NULL,
    `target_confirmation_time` datetime DEFAULT NULL,
    `self_comment` varchar(2000) DEFAULT NULL,
    `reviewer_comment` varchar(2000) DEFAULT NULL,
    `result_comment` varchar(2000) DEFAULT NULL,
    `result_confirmation_time` datetime DEFAULT NULL,
    `result_audit_status` tinyint DEFAULT NULL,
    `result_audit_time` datetime DEFAULT NULL,
    `result_audit_reason` varchar(1000) DEFAULT NULL,
    `appeal_reason` varchar(1000) DEFAULT NULL,
    `appeal_file_urls` varchar(2000) DEFAULT NULL,
    `appeal_submit_time` datetime DEFAULT NULL,
    `appeal_status` tinyint DEFAULT 0,
    `appeal_time` datetime DEFAULT NULL,
    `appeal_comment` varchar(1000) DEFAULT NULL,
    `archive_time` datetime DEFAULT NULL,
    `creator` varchar(64) DEFAULT '',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updater` varchar(64) DEFAULT '',
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `deleted` bit(1) NOT NULL DEFAULT b'0',
    `tenant_id` bigint NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 45. 绩效考核申诉记录
CREATE TABLE IF NOT EXISTS `hrm_performance_assessment_appeal_record` (
    `id` bigint NOT NULL AUTO_INCREMENT,
    `assessment_id` bigint NOT NULL,
    `stage_id` bigint NOT NULL,
    `status` tinyint NOT NULL,
    `creator` varchar(64) DEFAULT '',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updater` varchar(64) DEFAULT '',
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `deleted` bit(1) NOT NULL DEFAULT b'0',
    `tenant_id` bigint NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 46. 绩效考核操作记录
CREATE TABLE IF NOT EXISTS `hrm_performance_assessment_action_record` (
    `id` bigint NOT NULL AUTO_INCREMENT,
    `assessment_id` bigint NOT NULL,
    `stage_id` bigint DEFAULT NULL,
    `employee_id` bigint DEFAULT NULL,
    `type` tinyint NOT NULL,
    `title` varchar(128) NOT NULL,
    `content` varchar(2000) DEFAULT NULL,
    `file_urls` varchar(2000) DEFAULT NULL,
    `status` tinyint DEFAULT NULL,
    `creator` varchar(64) DEFAULT '',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updater` varchar(64) DEFAULT '',
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `deleted` bit(1) NOT NULL DEFAULT b'0',
    `tenant_id` bigint NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 47. 绩效考核阶段
CREATE TABLE IF NOT EXISTS `hrm_performance_assessment_stage` (
    `id` bigint NOT NULL AUTO_INCREMENT,
    `assessment_id` bigint NOT NULL,
    `type` tinyint NOT NULL,
    `name` varchar(128) NOT NULL,
    `handler_employee_id` bigint DEFAULT NULL,
    `rater_type` tinyint DEFAULT NULL,
    `weight` decimal(10, 2) DEFAULT NULL,
    `scoring_type` tinyint DEFAULT NULL,
    `visible_content` tinyint DEFAULT NULL,
    `required_setting` bit(1) DEFAULT NULL,
    `reject_authority` bit(1) DEFAULT NULL,
    `sort` int NOT NULL DEFAULT 0,
    `status` tinyint NOT NULL DEFAULT 0,
    `score` decimal(10, 2) DEFAULT NULL,
    `result_level` varchar(64) DEFAULT NULL,
    `comment` varchar(2000) DEFAULT NULL,
    `reject_reason` varchar(1000) DEFAULT NULL,
    `submit_time` datetime DEFAULT NULL,
    `deadline_time` datetime DEFAULT NULL,
    `creator` varchar(64) DEFAULT '',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updater` varchar(64) DEFAULT '',
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `deleted` bit(1) NOT NULL DEFAULT b'0',
    `tenant_id` bigint NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 48. 绩效考核指标评分
CREATE TABLE IF NOT EXISTS `hrm_performance_assessment_quota_score` (
    `id` bigint NOT NULL AUTO_INCREMENT,
    `assessment_stage_id` bigint NOT NULL,
    `assessment_quota_id` bigint NOT NULL,
    `score` decimal(10, 2) NOT NULL,
    `comment` varchar(1000) DEFAULT NULL,
    `creator` varchar(64) DEFAULT '',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updater` varchar(64) DEFAULT '',
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `deleted` bit(1) NOT NULL DEFAULT b'0',
    `tenant_id` bigint NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 49. 绩效考核维度
CREATE TABLE IF NOT EXISTS `hrm_performance_assessment_dimension` (
    `id` bigint NOT NULL AUTO_INCREMENT,
    `assessment_id` bigint NOT NULL,
    `name` varchar(255) NOT NULL,
    `quota_type` tinyint DEFAULT NULL,
    `weight` decimal(10, 2) DEFAULT NULL,
    `remark` varchar(255) DEFAULT NULL,
    `allow_edit` bit(1) NOT NULL DEFAULT b'0',
    `sort` int NOT NULL DEFAULT 0,
    `creator` varchar(64) DEFAULT '',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updater` varchar(64) DEFAULT '',
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `deleted` bit(1) NOT NULL DEFAULT b'0',
    `tenant_id` bigint NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 50. 绩效考核指标
CREATE TABLE IF NOT EXISTS `hrm_performance_assessment_quota` (
    `id` bigint NOT NULL AUTO_INCREMENT,
    `assessment_id` bigint NOT NULL,
    `dimension_id` bigint NOT NULL,
    `preset` bit(1) NOT NULL DEFAULT b'1',
    `name` varchar(255) DEFAULT NULL,
    `description` varchar(1000) DEFAULT NULL,
    `standard` varchar(1000) DEFAULT NULL,
    `weight` decimal(10, 2) DEFAULT 100.00,
    `score_type` tinyint DEFAULT NULL,
    `target_value` varchar(1000) DEFAULT NULL,
    `actual_value` varchar(1000) DEFAULT NULL,
    `self_score` decimal(10, 2) DEFAULT 0.00,
    `reviewer_score` decimal(10, 2) DEFAULT 0.00,
    `final_score` decimal(10, 2) DEFAULT 0.00,
    `sort` int DEFAULT 0,
    `creator` varchar(64) DEFAULT '',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updater` varchar(64) DEFAULT '',
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `deleted` bit(1) NOT NULL DEFAULT b'0',
    `tenant_id` bigint NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
