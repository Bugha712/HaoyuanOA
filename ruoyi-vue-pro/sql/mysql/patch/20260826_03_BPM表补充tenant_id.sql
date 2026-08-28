-- =====================================================
-- BPM 表补充 tenant_id 列 (MySQL 5.7+)
-- 说明：多租户拦截器对所有未标注 @TenantIgnore 的表自动追加 tenant_id 过滤
--       所有 BPM 业务表均需包含 tenant_id 列
-- 使用方法：在 Navicat 中连接 ruoyi-vue-pro 数据库，执行本脚本
-- =====================================================

ALTER TABLE `bpm_user_group` ADD COLUMN `tenant_id` bigint NOT NULL DEFAULT 0;
ALTER TABLE `bpm_category` ADD COLUMN `tenant_id` bigint NOT NULL DEFAULT 0;
ALTER TABLE `bpm_form` ADD COLUMN `tenant_id` bigint NOT NULL DEFAULT 0;
ALTER TABLE `bpm_oa_leave` ADD COLUMN `tenant_id` bigint NOT NULL DEFAULT 0;
ALTER TABLE `bpm_process_instance_copy` ADD COLUMN `tenant_id` bigint NOT NULL DEFAULT 0;
ALTER TABLE `bpm_process_listener` ADD COLUMN `tenant_id` bigint NOT NULL DEFAULT 0;
ALTER TABLE `bpm_process_expression` ADD COLUMN `tenant_id` bigint NOT NULL DEFAULT 0;
ALTER TABLE `bpm_process_definition_info` ADD COLUMN `tenant_id` bigint NOT NULL DEFAULT 0;
