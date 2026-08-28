-- =====================================================
-- 方案①：恢复「IM工作台（目录）→ 聊天（子菜单）」结构
-- 目的：让 IM 聊天在管理端外壳内正常显示、内容随内容区自适应铺满
-- 背景：之前改为顶级菜单导致 path 与静态路由冲突白屏；现改回目录内嵌
-- =====================================================

-- ① 把当前顶级菜单 2101（IM工作台/path=/im/home）先临时挪开，避免 id 占用
--    用 3000 作过渡 id，随后直接重建父子结构

-- ② 新建顶级目录「IM工作台」(id=2200, type=1, parent=0)
INSERT INTO `system_menu`
(`id`,`name`,`permission`,`type`,`sort`,`parent_id`,`path`,`icon`,`component`,`component_name`,`status`,`visible`,`keep_alive`,`always_show`,`creator`,`create_time`,`updater`,`update_time`,`deleted`)
VALUES
(2200,'IM工作台','',1,99,0,'/im-workbench','','','',0,1,1,1,'1',NOW(),'1',NOW(),b'0');

-- ③ 删除旧的顶级菜单 2101（重建为子菜单，避免 path/name 冲突）
DELETE FROM `system_menu` WHERE `id` = 2101 AND `deleted` = b'0';

-- ④ 新建子菜单「聊天」(type=2, parent=2200, component=im/home/index)
INSERT INTO `system_menu`
(`id`,`name`,`permission`,`type`,`sort`,`parent_id`,`path`,`icon`,`component`,`component_name`,`status`,`visible`,`keep_alive`,`always_show`,`creator`,`create_time`,`updater`,`update_time`,`deleted`)
VALUES
(2101,'聊天','',2,1,2200,'home','','im/home/index','',0,1,1,1,'1',NOW(),'1',NOW(),b'0');

-- ⑤ 校验结果
SELECT id, name, path, component, type, parent_id FROM `system_menu` WHERE id IN (2200, 2101);