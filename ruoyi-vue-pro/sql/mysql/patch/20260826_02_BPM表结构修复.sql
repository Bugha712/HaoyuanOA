-- =====================================================
-- BPM 表结构修复补丁 (MySQL 5.7+)
-- 说明：修复 bpm_category / bpm_form / bpm_user_group 表字段定义问题
-- 使用方法：在 Navicat 中连接 ruoyi-vue-pro 数据库，执行本脚本
-- =====================================================

-- 1. 修复 bpm_user_group：description 改为允许 NULL，user_ids 改大
ALTER TABLE `bpm_user_group` MODIFY COLUMN `description` varchar(255) DEFAULT '';
ALTER TABLE `bpm_user_group` MODIFY COLUMN `user_ids` varchar(1024) DEFAULT NULL;

-- 2. 修复 bpm_category：description 改为允许 NULL，sort 加默认值
ALTER TABLE `bpm_category` MODIFY COLUMN `description` varchar(255) DEFAULT '';
ALTER TABLE `bpm_category` MODIFY COLUMN `sort` int NOT NULL DEFAULT 0;

-- 3. 修复 bpm_form：fields 和 conf 改为 TEXT（表单 JSON 可能很长）
ALTER TABLE `bpm_form` MODIFY COLUMN `fields` text;
ALTER TABLE `bpm_form` MODIFY COLUMN `conf` text;
ALTER TABLE `bpm_form` MODIFY COLUMN `remark` varchar(255) DEFAULT NULL;
