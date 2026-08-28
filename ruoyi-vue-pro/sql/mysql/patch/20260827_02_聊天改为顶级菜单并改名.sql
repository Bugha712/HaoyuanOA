-- =====================================================
-- 修复 IM 聊天界面：改为顶级菜单全屏显示，消除外壳错乱
-- 操作：2101「聊天」→ 顶级菜单(type=2,parent=0)并改名「IM工作台」；删除空目录 2100
-- 说明：顶级菜单 component 留空、path='/im/home'，前端按 path 匹配全屏组件 im/home/index.vue
--       无父目录 Layout 外壳 → 聊天界面全屏且内容完整
-- =====================================================

-- ① 备份当前两条菜单记录
CREATE TABLE IF NOT EXISTS `system_menu_bak_20260827` LIKE `system_menu`;
INSERT INTO `system_menu_bak_20260827`
SELECT * FROM `system_menu` WHERE `id` IN (2100, 2101);

-- ② 校验备份成功
SELECT id, name, path, type, parent_id, component FROM `system_menu_bak_20260827` WHERE id IN (2100, 2101);

-- ③ 将 2101「聊天」改为顶级菜单并改名「IM工作台」
UPDATE `system_menu`
SET    `parent_id`  = 0,
       `path`       = '/im/home',
       `component`  = '',
       `name`       = 'IM工作台'
WHERE  `id` = 2101
  AND  `deleted` = b'0';

-- ④ 删除空目录 2100「IM工作台」
DELETE FROM `system_menu` WHERE `id` = 2100 AND `type` = 1 AND `deleted` = b'0';

-- ⑤ 校验最终结果
SELECT id, name, path, component, type, parent_id FROM `system_menu` WHERE id IN (2100, 2101);