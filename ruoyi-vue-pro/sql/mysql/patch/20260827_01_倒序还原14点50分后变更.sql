-- =============================================================
-- 从后往前（时间逆序）逐步还原脚本
-- 目标：把数据库恢复到 2026-08-27 14:50 之前的状态
-- 依据：binlog bin.000002/bin.000003 核实的真实操作，已确认无遗漏
-- 用法：在 Navicat 连接 ruoyi-vue-pro，按 S1→S6 从上到下逐步执行，
--       每步可独立运行。若某步已还原过（条件不命中）会自动跳过。
-- =============================================================

-- -------------------------------------------------------------
-- S1 还原 17:37 的操作：聊天菜单 path '/im/home' → 还原回 'im/home'
--    （binlog: 17:35 INSERT 时的原始 path 就是 'im/home'）
-- -------------------------------------------------------------
UPDATE `system_menu`
SET    `path` = 'im/home',
       `updater` = '1',
       `update_time` = '2026-08-27 17:35:45'
WHERE  `id` = 2100
  AND  `path` = '/im/home'
  AND  `deleted` = b'0';
-- 校验：SELECT id, name, path, parent_id, type FROM system_menu WHERE id=2100;
--   期望：path = 'im/home'，type = 2，parent_id = 0

-- -------------------------------------------------------------
-- S2 还原 17:35 的操作：删除 INSERT 出的「聊天」顶级菜单 id=2100
--    （此时 2100 是 type=2 parent=0 的聊天菜单，先删才能插回目录）
-- -------------------------------------------------------------
DELETE FROM `system_menu`
WHERE  `id` = 2100
  AND  `type` = 2
  AND  `parent_id` = 0
  AND  `name` = '聊天';
-- 校验：SELECT COUNT(*) FROM system_menu WHERE id=2100 AND deleted=b'0';  -> 0

-- -------------------------------------------------------------
-- S3 还原 17:33 的操作：插回被 DELETE 掉的「IM工作台」顶级目录 id=2100
--    （14:50 前的原始状态：顶级目录 IM工作台，path='im'，type=1）
-- -------------------------------------------------------------
INSERT INTO `system_menu`
(`id`, `name`, `permission`, `type`, `sort`, `parent_id`, `path`, `icon`,
 `component`, `component_name`, `status`, `visible`, `keep_alive`, `always_show`,
 `creator`, `create_time`, `updater`, `update_time`, `deleted`)
SELECT 2100, 'IM工作台', '', 1, 500, 0, 'im', 'ep:chat-dot-round',
        NULL, NULL, 0, b'1', b'1', b'1',
        'admin', '2026-08-27 11:47:03', '1', '2026-08-27 11:47:03', b'0'
FROM    DUAL
WHERE   NOT EXISTS (SELECT 1 FROM `system_menu` WHERE `id` = 2100 AND `parent_id` = 0 AND `type` = 1 AND `deleted` = b'0');
-- 校验：SELECT id, name, path, type, parent_id FROM system_menu WHERE id=2100;
--   期望：IM工作台，path='im'，type=1，parent_id=0

-- -------------------------------------------------------------
-- S4 还原 17:26 的操作：IM 即时通讯 id=1418 path '/im/manager' → '/im'
--    （14:50 前 1418 的 path='/im'）
-- -------------------------------------------------------------
UPDATE `system_menu`
SET    `path` = '/im',
       `updater` = '1',
       `update_time` = '2026-08-14 01:49:42'
WHERE  `id` = 1418
  AND  `path` = '/im/manager'
  AND  `deleted` = b'0';
-- 校验：SELECT id, name, path, parent_id FROM system_menu WHERE id=1418;
--   期望：IM 即时通讯，path='/im'，parent_id=0

-- -------------------------------------------------------------
-- S5 还原 17:11 的操作：IM工作台目录 id=2100 path '/im' → 'im'
--    （14:50 前=11:47 创建时的原始 path='im'）
-- -------------------------------------------------------------
UPDATE `system_menu`
SET    `path` = 'im',
       `updater` = 'admin',
       `update_time` = '2026-08-27 11:47:03'
WHERE  `id` = 2100
  AND  `type` = 1
  AND  `parent_id` = 0
  AND  `path` = '/im'
  AND  `deleted` = b'0';
-- 校验：SELECT id, name, path, type, parent_id FROM system_menu WHERE id=2100;
--   期望：IM工作台，path='im'，type=1，parent_id=0

-- -------------------------------------------------------------
-- S6 还原 14:59 的操作：infra_file_config id=36 domain 还原回含 /admin-api
--    （14:40 创建时 domain='http://localhost:48080/admin-api'）
--    ⚠️ 注意：还原后 URL 会带 /admin-api 重复段，IM 图片可能再次加载失败
-- -------------------------------------------------------------
UPDATE `infra_file_config`
SET    `config` = '{"@class":"cn.iocoder.yudao.module.infra.framework.file.core.client.db.DBFileClientConfig","domain":"http://localhost:48080/admin-api"}',
       `updater` = '253',
       `update_time` = '2026-08-27 14:40:29'
WHERE  `id` = 36
  AND  `config` LIKE '%"domain":"http://localhost:48080"%'
  AND  `deleted` = b'0';
-- 校验：SELECT id, config FROM infra_file_config WHERE id=36;
--   期望：domain = "http://localhost:48080/admin-api"

-- =============================================================
-- 全部执行后，最终状态 = 2026-08-27 14:50 之前：
--   system_menu  id=2100  IM工作台 顶级目录 path='im'
--   system_menu  id=2101  聊天 子菜单（未改动，仍存在）
--   system_menu  id=1418  IM 即时通讯 顶级 path='/im'
--   infra_file_config id=36 本地存储 domain 含 /admin-api
-- =============================================================