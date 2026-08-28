-- =====================================================
-- 新增「IM 工作台」顶级菜单 + 「聊天」子菜单
-- 说明：前端静态路由 /im -> /im/home -> /im/home/conversation 已存在（im/home/index.vue 全屏聊天壳），
--       但菜单表缺少入口，导致侧边栏无法进入真正的 IM 聊天界面。
--       本脚本补齐入口。admin（超级管理员）登录后会被自动授予全部菜单，无需额外配权限。
-- 使用方法：在 Navicat 中连接 ruoyi-vue-pro 数据库，执行本脚本，然后刷新前端页面即可。
-- =====================================================

-- 1) 顶级「IM 工作台」目录（type=1 目录，parent_id=0）
INSERT INTO `system_menu` (`id`, `name`, `permission`, `type`, `sort`, `parent_id`, `path`, `icon`, `component`, `component_name`, `status`, `visible`, `keep_alive`, `always_show`, `creator`, `create_time`, `updater`, `update_time`, `deleted`)
VALUES (2100, 'IM工作台', '', 1, 500, 0, 'im', 'ep:chat-dot-round', NULL, NULL, 0, b'1', b'1', b'1', 'admin', NOW(), '1', NOW(), b'0');

-- 2) 「聊天」子菜单（type=2 菜单，component 指向全屏聊天壳，自动 redirect 到 /im/home/conversation）
INSERT INTO `system_menu` (`id`, `name`, `permission`, `type`, `sort`, `parent_id`, `path`, `icon`, `component`, `component_name`, `status`, `visible`, `keep_alive`, `always_show`, `creator`, `create_time`, `updater`, `update_time`, `deleted`)
VALUES (2101, '聊天', '', 2, 1, 2100, 'home', 'ep:chat-dot-round', 'im/home/index', 'ImHome', 0, b'1', b'1', b'1', 'admin', NOW(), '1', NOW(), b'0');