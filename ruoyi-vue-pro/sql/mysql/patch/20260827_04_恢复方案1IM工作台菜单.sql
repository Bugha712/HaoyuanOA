-- =====================================================
-- 恢复「方案一」形态：独立顶级目录「IM工作台」→ 子菜单「聊天」
-- 说明：顶级目录 path 用 /im-workbench（带斜杠、与 1418 /im 不冲突、vue-router 可用）
-- =====================================================

-- ① 先删除已回退残留的 2200/2101（若不存在则无影响）
DELETE FROM `system_menu` WHERE `id` IN (2200, 2101) AND `deleted` = b'0';

-- ② 新建顶级目录「IM工作台」(id=2200, type=1, parent=0)
INSERT INTO `system_menu`
(`id`,`name`,`permission`,`type`,`sort`,`parent_id`,`path`,`icon`,`component`,`component_name`,`status`,`visible`,`keep_alive`,`always_show`,`creator`,`create_time`,`updater`,`update_time`,`deleted`)
VALUES
(2200,'IM工作台','',1,99,0,'/im-workbench','','','',0,1,1,1,'1',NOW(),'1',NOW(),b'0');

-- ③ 新建子菜单「聊天」(id=2101, type=2, parent=2200, component=im/home/index, path=home)
INSERT INTO `system_menu`
(`id`,`name`,`permission`,`type`,`sort`,`parent_id`,`path`,`icon`,`component`,`component_name`,`status`,`visible`,`keep_alive`,`always_show`,`creator`,`create_time`,`updater`,`update_time`,`deleted`)
VALUES
(2101,'聊天','',2,1,2200,'home','','im/home/index','',0,1,1,1,'1',NOW(),'1',NOW(),b'0');

-- ④ 校验
SELECT id, name, path, component, type, parent_id FROM `system_menu` WHERE id IN (2200, 2101, 1418);