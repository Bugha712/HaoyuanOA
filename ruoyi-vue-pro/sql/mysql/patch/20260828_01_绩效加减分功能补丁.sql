-- =============================================================
-- 20260828_01 绩效加减分功能补丁
-- 说明：
--   1) 绩效考核模板增加「加减分项」配置（JSON），用于定义加分/减分规则；
--   2) 员工绩效考核实例增加「加减分记录」与「加减分小计」，用于在最终得分上进行加减分。
-- =============================================================

-- 1. 绩效考核模板：新增「加减分项」JSON 列
ALTER TABLE `hrm_performance_assessment_template`
    ADD COLUMN `bonus_penalty_items` TEXT NULL COMMENT '加减分项配置(JSON)' AFTER `dimensions`;

-- 2. 员工绩效考核：新增「加减分记录」JSON 列 与「加减分小计」列
ALTER TABLE `hrm_performance_assessment`
    ADD COLUMN `bonus_penalty_records` TEXT NULL COMMENT '加减分记录(JSON)' AFTER `archive_time`,
    ADD COLUMN `bonus_penalty_total` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '加减分小计' AFTER `bonus_penalty_records`;