-- ============================================================
-- 补丁编号: 20260825_01
-- 作用    : 在 Navicat 中执行，验证 BPM 工作流 和 HRM 人力资源 模块的菜单、
--           字典、定时任务是否已存在（因 ruoyi-vue-pro.sql 已包含全部数据，
--           如果用户是完整执行过主 SQL，结果应为全部存在）
-- 日期    : 2026-08-25
-- ============================================================

USE `ruoyi-vue-pro`;

-- ① 检查关键菜单（12 条顶级/一级菜单）
SELECT
  id AS 菜单ID,
  name AS 菜单名称,
  parent_id AS 父级ID,
  path AS 路由路径,
  component AS 前端组件,
  CASE status WHEN 0 THEN '启用' ELSE '停用' END AS 状态,
  CASE visible WHEN b'1' THEN '显示' ELSE '隐藏' END AS 可见
FROM `system_menu`
WHERE id IN (
  148,    -- 工作流程 (BPM 顶级)
  149,    -- 模型管理
  150,    -- 流程表单
  156,    -- 流程模型
  163,    -- 审批中心
  164,    -- 我的流程
  166,    -- 待办任务
  167,    -- 已办任务
  115,    -- 请假查询（OA请假示例）
  1476,   -- HRM 人力资源 (HRM 顶级)
  1585,   -- 绩效管理
  1635,   -- 组织管理（HRM 组织工作台）
  1614,   -- 员工端门户 顶级
  1619    -- 员工端-绩效管理
)
ORDER BY id;

-- ② 检查 HRM 字典类型（8 个绩效相关 + 1 个请假类型）
SELECT id, name, type, status FROM `system_dict_type`
WHERE type IN (
  'hrm_performance_plan_status',
  'hrm_performance_stage_status',
  'hrm_performance_appeal_status',
  'hrm_performance_score_calculation',
  'hrm_performance_upper_limit_type',
  'hrm_performance_yes_no',
  'hrm_performance_assessment_stage_status',
  'bpm_process_instance_status',
  'bpm_task_status',
  'bpm_comment_type',
  'bpm_oa_leave_type'
)
ORDER BY id;

-- ③ 检查 HRM 绩效申诉超期处理定时任务
SELECT id, name, status, handler_name, cron_expression FROM `infra_job` WHERE id = 7112;
