-- =====================================================
-- 修复租户套餐表 menu_ids 列长度
-- 说明：启用 BPM/HRM/IM 模块后菜单总数超过 200 个，
--       menu_ids JSON 数组字符串可能超过原列长度限制
-- 使用方法：在 Navicat 中执行
-- =====================================================

ALTER TABLE `system_tenant_package` MODIFY COLUMN `menu_ids` varchar(4096) NOT NULL COMMENT '关联的菜单编号';