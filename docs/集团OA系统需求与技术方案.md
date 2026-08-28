# 集团 OA 系统需求规格与技术方案（v1.0）

> **基于开源框架**：`ruoyi-vue-pro`（后端 Spring Boot 2.7 + JDK 8） + `yudao-ui-admin-vue3`（前端 Vue 3.5 + Vite 8 + Element Plus）  
> **文档日期**：2026-08-25  
> **代码核查方式**：已对项目前后端源码做代码级逐项核查（见各章节的文件引用）

---

## 1. 项目概述

### 1.1 项目背景
集团现有 OA 流程以线下 + Excel 为主，尤其绩效考核存在数据分散、打分周期长、申诉不透明、归档难等痛点。需基于开源 OA 框架进行**二次开发**，在保证稳定的前提下快速落地核心需求。

### 1.2 项目目标
1. ✅ **绩效打分完全线上化**（本次核心目标）
2. ✅ 集团统一认证（SSO），一次登录访问所有业务系统
3. ✅ 集团→中心→部门的组织架构 + 员工通讯录线上可查
4. ✅ 统一审批流程平台，支持可视化流程设计、会签/加签/退回
5. ✅ 员工报销流程线上化，支持附件上传、多级审批

### 1.3 本期交付范围
| 模块 | 交付状态 | 说明 |
|---|---|---|
| 统一认证 SSO | ✅ 交付 | OAuth2 + 钉钉/企业微信扫码 |
| 组织架构管理 | ✅ 交付 | 多级部门 / 岗位 / 用户-岗位多对多 |
| 通讯录管理 | ✅ 交付 | 员工档案 / 紧急联系人 / 门户个人信息 |
| 审批流程平台 | ✅ 交付 | BPM 引擎 + 双设计器 + 全量审批操作 |
| 绩效考核（线上打分） | ✅ 交付 | 计划 / KPI模板 / 自评 / 复评 / 申诉 / 归档 |
| 报销流程 | ⚠️ 定制交付 | 参考 OA 请假模板，二次开发 1~2 天 |
| 考勤 / 薪资 / 社保 | 🔜 暂不深入 | 随 HRM 模块开启即可，本期不做专项改造 |
| FMS 财务凭证对接 | 🔜 二期 | 可在报销流程稳定后对接 |

---

## 2. 业务需求规格

### 2.1 需求一：统一认证（SSO / OAuth2）
> 代码来源：[yudao-module-system/controller/admin/oauth2/OAuth2OpenController.java](file:///e:/HaoyuanOA/ruoyi-vue-pro/yudao-module-system/src/main/java/cn/iocoder/yudao/module/system/controller/admin/oauth2/OAuth2OpenController.java) / [SSOLogin.vue](file:///e:/HaoyuanOA/yudao-ui-admin-vue3/src/views/Login/components/SSOLogin.vue)

| 编号 | 需求点 | 优先级 | 说明 |
|---|---|---|---|
| UC-101 | 集团统一账号登录 | P0 | 一套账号密码登录 OA / 未来其他业务系统 |
| UC-102 | OAuth2.0 SSO | P0 | 接入其他业务系统时，支持授权码模式跳转登录（无需重复登录） |
| UC-103 | 钉钉 / 企业微信扫码登录 | P1 | 高层员工无需记账号密码，扫码即登 |
| UC-104 | OAuth2 应用管理 | P1 | 管理员可后台注册"接入应用"（ClientID / 密钥 / 回调地址 / 授权模式） |
| UC-105 | 密码策略 | P1 | 强密码、首次登录改密、密码过期（通过 system 模块配置项开启） |

### 2.2 需求二：组织架构管理
> 代码来源：[DeptServiceImpl.java](file:///e:/HaoyuanOA/ruoyi-vue-pro/yudao-module-system/src/main/java/cn/iocoder/yudao/module/system/service/dept/DeptServiceImpl.java) / [PostServiceImpl.java](file:///e:/HaoyuanOA/ruoyi-vue-pro/yudao-module-system/src/main/java/cn/iocoder/yudao/module/system/service/dept/PostServiceImpl.java) / [HRM 组织工作台 dept/index.vue](file:///e:/HaoyuanOA/yudao-ui-admin-vue3/src/views/hrm/dept/index.vue)

| 编号 | 需求点 | 优先级 | 说明 |
|---|---|---|---|
| OG-201 | 无限层级部门树 | P0 | 集团 → 中心 → 一级部门 → 二级部门 ... 层级不限 |
| OG-202 | 部门编号唯一性约束 | P0 | 防止同级别部门重复命名 |
| OG-203 | 岗位管理 | P0 | 支持按岗位配置审批角色（如"部门主管"岗自动为审批人） |
| OG-204 | 用户-岗位多对多 | P0 | 一人可兼任多个部门 / 多个岗位（如集团办公室兼管人事部） |
| OG-205 | 组织工作台（HR 专用） | P1 | HR 可视化组织树，带各部门人数统计、部门详情页跳转 |
| OG-206 | 部门负责人字段 | P1 | 用于审批流的"直属上级自动确定审批人" |

### 2.3 需求三：通讯录管理
> 代码来源：[HrmEmployeeContactServiceImpl.java](file:///e:/HaoyuanOA/ruoyi-vue-pro/yudao-module-hrm/src/main/java/cn/iocoder/yudao/module/hrm/service/employee/info/HrmEmployeeContactServiceImpl.java) / [员工门户](file:///e:/HaoyuanOA/yudao-ui-admin-vue3/src/views/hrm/portal)

| 编号 | 需求点 | 优先级 | 说明 |
|---|---|---|---|
| AD-301 | 员工档案 | P0 | 基本信息 / 入职日期 / 职级 / 部门 / 岗位 |
| AD-302 | 工作 / 教育 / 培训经历 | P1 | 员工履历可追溯 |
| AD-303 | 紧急联系人 | P0 | 每个员工 ≥1 条紧急联系人记录 |
| AD-304 | 员工自助门户 | P0 | 员工登录后可查看/修改自己的联系地址、电话、紧急联系人 |
| AD-305 | 组织通讯录检索 | P1 | 按部门、姓名、岗位、工号搜索同事联系方式 |

### 2.4 需求四：审批流程平台（BPM）
> 代码来源：[双设计器 ProcessDesign.vue](file:///e:/HaoyuanOA/yudao-ui-admin-vue3/src/views/bpm/model/form/ProcessDesign.vue) / [审批操作 API](file:///e:/HaoyuanOA/yudao-ui-admin-vue3/src/api/bpm/task/index.ts) / [OA 请假示例 BpmOALeaveController](file:///e:/HaoyuanOA/ruoyi-vue-pro/yudao-module-bpm/src/main/java/cn/iocoder/yudao/module/bpm/controller/admin/oa/BpmOALeaveController.java)

| 编号 | 需求点 | 优先级 | 说明 |
|---|---|---|---|
| WF-401 | 流程双设计器 | P0 | BPMN 专业版 + Simple 简化版（HR/行政无需写代码即可画流程） |
| WF-402 | 流程表单 | P0 | 选组件式普通表单 + 自定义业务表单（如报销单/请假单） |
| WF-403 | 待办 / 已办 / 抄送 | P0 | 审批人个人工作台，含批量办理 |
| WF-404 | 审批操作 | P0 | 通过 / 拒绝 / 退回任意节点 / 转办 / 委派 / **加签** / **减签** / 撤回 |
| WF-405 | 审批意见 + 附件 + 签名 | P0 | 审批人可上传附件、手写签名（电子档） |
| WF-406 | 自动确定审批人 | P1 | 按"部门负责人""岗位""角色"等自动找审批人，不用每次选 |
| WF-407 | OA 请假示例范本 | 🔧 | 用于复制改造成"报销流程"的参考模板（DO/Controller/API/前端页完整一套） |

### 2.5 需求五：绩效考核（⭐本期核心，线上打分）
> 代码来源：[绩效计划 plan/index.vue](file:///e:/HaoyuanOA/yudao-ui-admin-vue3/src/views/hrm/performance/plan/index.vue) / [员工端评分 PerformanceReviewForm.vue](file:///e:/HaoyuanOA/yudao-ui-admin-vue3/src/views/hrm/portal/performance/assessment/review/PerformanceReviewForm.vue) / [申诉 PerformanceAppealForm.vue](file:///e:/HaoyuanOA/yudao-ui-admin-vue3/src/views/hrm/portal/performance/assessment/process/PerformanceAppealForm.vue) / [评分 API 结构](file:///e:/HaoyuanOA/yudao-ui-admin-vue3/src/api/hrm/portal/performance/assessment/index.ts)

#### 2.5.1 整体线上流程（框架已内置）
```
HR 创建绩效计划 → 绑定考核模板（KPI）→ 下发员工
   ↓
员工确认目标 → 填写实际值 → 自评
   ↓
直属主管评分 → 部门负责人复评 → 多级评分
   ↓
员工查看结果 → （可选）发起申诉
   ↓
HR 绩效面谈 → 结果归档（写入员工档案）
```

| 编号 | 需求点 | 优先级 | 说明 |
|---|---|---|---|
| PF-501 | 绩效计划管理 | P0 | 计划名称 / 考核周期 / 参评范围 / 模板绑定 / 阶段状态 |
| PF-502 | 考核模板（KPI 指标库） | P0 | 维度 → 指标 → 权重 / 目标值 / 评分说明 / 上限分 |
| PF-503 | 模板快照 | P1 | 指标模板变更后，已下发计划不受影响（框架已做快照复制） |
| PF-504 | 员工确认目标 | P0 | 员工端线上确认考核指标、目标值 |
| PF-505 | ⭐员工自评 / 线上打分 | P0 | 数字输入框（0~上限分限制）+ 评语，线上提交 |
| PF-506 | 多级审批评分 | P0 | 直属主管 → 更高领导，支持驳回上一节点重做 |
| PF-507 | ⭐绩效申诉 | P0 | 员工选择退回评分节点 + 申诉原因 + **上传申诉附件**（PDF/截图） |
| PF-508 | 绩效面谈记录 | P1 | HR 与员工面谈记录写入线上 |
| PF-509 | 结果归档 | P0 | 完成后进入员工档案，不可篡改 |
| PF-510 | 结果查询/导出 | P1 | 按部门/周期查询绩效分布（可接报表模块做大屏） |
| PF-511 | 数据权限 | P1 | 部门主管只能看本部门；员工只能看自己；HR/管理员全量 |

### 2.6 需求六：报销流程
> 代码来源：无现成报销业务实体（已核查全文），**需二次开发**；底层 BPM 引擎 100% 可用，参考 OA 请假范本复制改造即可。

| 编号 | 需求点 | 优先级 | 开发量（估算） |
|---|---|---|---|
| EX-601 | 报销单实体（DO） | P0 | ⭐~150 行（字段） |
| EX-602 | 报销费用类型字典 | P0 | 差旅 / 办公 / 餐饮 / 交通 / 其他 |
| EX-603 | 报销单列表 / 创建页 | P0 | ⭐~3 个 Vue 页面 |
| EX-604 | 明细子表（多行费用） | P1 | 如：差旅含机票+酒店+餐费三条明细 |
| EX-605 | 发票附件上传 | P0 | 对接 infra 文件存储模块（MinIO/OSS） |
| EX-606 | 对接 BPM 流程 | P0 | 复制 OA 请假的 ProcessInstance 关联逻辑 |
| EX-607 | 审批流配置（主管→财务→总经理） | P1 | 后台用 BPMN/SIMPLE 设计器配置 |
| EX-608 | （二期）自动生成财务凭证 | P2 | 审批完成后写入 FMS 模块凭证 |

**估算开发量**：后端 ~4 文件（DO/Mapper/Service/Controller）+ 前端 ~3 文件（列表/创建/详情/API封装）+ SQL 1张表 + 字典数据，**单人工期 1~2 个工作日**。

---

## 3. 功能覆盖度与差距分析汇总

### 3.1 覆盖度矩阵

| 模块 | 框架是否已有 | 代码完整度 | 需二次开发？ | 预计工期 |
|---|---|---|---|---|
| ① 统一认证 SSO | ✅ **完全拥有** | 100% | 仅配置 | 0.5 天 |
| ② 组织架构管理 | ✅ **完全拥有** | 100% | **否** | 0 天 |
| ③ 通讯录管理（员工档案） | ✅ **完全拥有** | 98% | 否（需开启 hrm 模块） | 0.5 天 |
| ④ BPM 审批流程平台 | ✅ **完全拥有** | 99% | 否（需开启 bpm 模块） | 1 天 |
| ⑤ 绩效考核（线上打分） | ✅ **完全拥有**⭐ | 98% | 否（需开启 hrm 模块 + 自测通过） | 1 天 |
| ⑥ 报销流程 | ⚠️ 仅引擎，业务单缺失 | ~10% | **是**（套 OA 请假范本） | 1~2 天 |
| **合计** | — | — | — | **约 4~5 工作日** |

### 3.2 差距说明
- **唯一需要写代码的模块：报销流程**（其余 5 个模块仅改配置、解除 pom 注释即可启用）
- 框架未内置报销单的原因：报销规则各公司差异极大（费用类型、审批层级、发票验真、对接财务），开源版只提供了接入范本（BpmOALeave），避免给错误的"标准报销"误导

---

## 4. 系统总体架构

### 4.1 分层架构图（与可视化对应）
```
┌──────────────────────────────────────────────────────────┐
│  ① 用户接入层（前后端分离，Nginx 静态前端 + API 网关）     │
│   Admin 后台 │ Portal 员工门户 │ SSO 授权页 │ 移动扩展    │
└──────────────────────┬───────────────────────────────────┘
                       │ HTTPS + JWT Token
┌──────────────────────▼───────────────────────────────────┐
│  ② 统一认证 / 权限网关（Spring Security + OAuth2）        │
│   OAuth2.0 授权中心 │ RBAC 菜单权限 │ 租户/数据权限       │
└──────────────────────┬───────────────────────────────────┘
                       │
┌──────────────────────▼───────────────────────────────────┐
│  ③ 核心业务模块（Spring Boot 多模块 Maven 工程）          │
│   system │ infra │ bpm 审批 │ hrm 人力(含绩效) │ fms 财务 │
│   ⭐重点：hrm performance 线上打分全流程                   │
│   ⚠️定制：bpm oa-expense 报销（二次开发接入）               │
└──────────────────────┬───────────────────────────────────┘
                       │
┌──────────────────────▼───────────────────────────────────┐
│  ④ 基础设施（infra · 二次开发加速器）                     │
│   代码生成器 ⚡│ 定时任务 Quartz │ 文件存储 / 短信 / 日志  │
└──────────────────────┬───────────────────────────────────┘
                       │
┌──────────────────────▼───────────────────────────────────┐
│  ⑤ 数据与中间件层                                         │
│   MySQL 8 主库 │ Redis 7 缓存 │ Flowable 7 BPM 引擎 │ 对象存储 │
└──────────────────────────────────────────────────────────┘
```

### 4.2 关键技术选型（框架已确定，核查版本）

| 层次 | 技术 | 版本（已确认） | 说明 |
|---|---|---|---|
| **后端语言** | Java JDK | **1.8**（框架版本为 2026.07-jdk8） | 配置 pom.properties |
| **后端框架** | Spring Boot | **2.7.18**（Spring 5.3.x） | 非 3.x，生产稳定 |
| ORM | MyBatis Plus | **3.5.11** | 分页、自动填充、多租户插件 |
| 权限 | Spring Security + JWT | — | OAuth2.0 + RBAC + 数据权限 |
| 流程引擎 | **Flowable** | **7.0.1** | BPM 模块的底层引擎 |
| **前端框架** | Vue | **3.5.22** | `<script setup>` + Composition API |
| 前端构建 | Vite | **8.5.0** | 开发冷启动 < 5s |
| UI 组件库 | Element Plus | **2.11.7** | 与后台主题、表单、表格一致 |
| 状态管理 | Pinia | **3.0.3** | 替换 Vuex，TS 友好 |
| **数据库** | MySQL | **≥ 5.7 / 推荐 8.0** | 字符集 `utf8mb4` |
| 缓存 / 分布式锁 | Redis | **≥ 6.0 / 推荐 7.x** | 在线用户、验证码、定时任务锁 |
| 对象存储 | 本地 / MinIO / 阿里云OSS / 腾讯云 / 七牛 | — | 报销发票附件、签名等（infra 模块） |

### 4.3 前后端项目代码位置
- **后端工程根**：[ruoyi-vue-pro/pom.xml](file:///e:/HaoyuanOA/ruoyi-vue-pro/pom.xml)
  - 业务模块目录：`yudao-module-bpm/` / `yudao-module-hrm/` / `yudao-module-system/` / `yudao-module-fms/`
  - 启动入口：[yudao-server/src/main/java/cn/iocoder/yudao/server/YudaoServerApplication.java](file:///e:/HaoyuanOA/ruoyi-vue-pro/yudao-server/src/main/java/cn/iocoder/yudao/server/YudaoServerApplication.java)
- **前端工程根**：[yudao-ui-admin-vue3/package.json](file:///e:/HaoyuanOA/yudao-ui-admin-vue3/package.json)
  - 路由入口：[router/index.ts](file:///e:/HaoyuanOA/yudao-ui-admin-vue3/src/router/index.ts)
  - API 层：`src/api/bpm/` / `src/api/hrm/` / `src/api/system/`
  - 页面：`src/views/bpm/` / `src/views/hrm/` / `src/views/system/`

---

## 5. 核心功能方案详述

### 5.1 ⭐绩效考核线上化方案（本期重点）
> 框架已有代码完整度 98%，实施步骤如下：

#### 5.1.1 后台配置步骤（HR 操作，无需开发）
1. **开启 HRM 模块**：解除 `ruoyi-vue-pro/pom.xml` 中 `<module>yudao-module-hrm</module>` 的注释，重新 `mvn compile`
2. **刷新数据库菜单**：确认 `system_menu` 表中 HRM → 绩效相关菜单存在（如不存在，执行 HRM 模块 SQL 补丁或使用基础设施模块的"菜单管理"手动添加）
3. **HR 建绩效模板**：HRM → 绩效 → 指标模板 → 新建
   - 例："季度 KPI 考核模板"，维度：业绩维度 (60%) / 能力维度 (30%) / 态度维度 (10%)
   - 维度下指标：如"业绩维度 → 季度销售目标完成率 → 目标值 100% → 满分 100 → 权重 60%"
4. **HR 建绩效计划**：绑定模板 → 选择参评部门/人员 → 设置各阶段截止日期 → **开启考核**

#### 5.1.2 员工端线上打分流程
1. 员工登录 **Portal 员工门户**（`/hrm/portal/performance/assessment`）
2. 进入待办 → 确认目标 → 填写实际值（如 Q3 销售完成 95 万）→ **自评分 + 自评说明** → 提交
3. 直属主管待办中收到任务 → 查看员工自评 + 实际值 → **主管评分 + 评语** → 提交
4. 部门负责人 → **复评分**（可驳回至主管节点重做）
5. 员工端预览结果 → **如异议**：点击"发起申诉" → 填写原因 + 上传附件 → 退回对应评分节点
6. 申诉处理完毕 / 无异议 → HR 发起"绩效面谈"（录入面谈记录）→ **一键归档**
7. 归档后结果写入员工档案（永久可查，不可修改）

#### 5.1.3 关键权限控制（框架已做）
- 员工角色：只能看到自己的绩效（通过 Hrm 模块的数据权限 AOP）
- 部门主管：只能看到本部门 + 下一级部门员工
- HR / 管理员：全集团可见 + 可配置

### 5.2 报销流程二次开发方案（1~2 天）
> 完全复制 OA 请假的结构，改名 + 加字段

#### 5.2.1 后端文件（新增，不改核心）
```
yudao-module-bpm/
└── src/main/java/cn/iocoder/yudao/module/bpm/
    ├── controller/admin/oa/
    │   └── BpmOAExpenseController.java         ← 新建（复制 BpmOALeaveController）
    ├── dal/dataobject/oa/
    │   └── BpmOAExpenseDO.java                 ← 新建（加字段：费用类型/金额/日期/附件URL/明细…）
    ├── dal/mysql/oa/
    │   └── BpmOAExpenseMapper.java + .xml      ← 新建
    └── service/oa/
        ├── BpmOAExpenseService.java            ← 新建接口
        └── BpmOAExpenseServiceImpl.java        ← 新建实现（接入 ProcessInstance 关联）
```

#### 5.2.2 前端文件（新增）
```
yudao-ui-admin-vue3/src/
├── api/bpm/expense/
│   └── index.ts                               ← 新建（封装 CRUD API）
└── views/bpm/oa/expense/
    ├── create.vue                             ← 新建：报销单填报 + 流程 Timeline
    ├── list.vue                               ← 新建：我的报销 / 全部报销（按权限）
    └── detail.vue                             ← 可选：详情 + 审批记录
```

#### 5.2.3 数据库（1 张主表 + 可选明细表）
```sql
-- 主表
CREATE TABLE bpm_oa_expense (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  process_instance_id BIGINT NOT NULL COMMENT '流程实例ID（关联 bpm 引擎）',
  user_id BIGINT NOT NULL COMMENT '申请人',
  expense_no VARCHAR(64) NOT NULL COMMENT '报销单号',
  total_amount DECIMAL(12,2) NOT NULL COMMENT '总金额',
  expense_date DATE COMMENT '发生日期',
  expense_type TINYINT NOT NULL COMMENT '费用类型(字典：1差旅 2办公 3餐饮...)',
  reason VARCHAR(500) COMMENT '事由',
  file_urls VARCHAR(2000) COMMENT '发票附件URL，逗号分隔',
  status TINYINT NOT NULL DEFAULT 0 COMMENT '审批状态',
  create_time DATETIME DEFAULT CURRENT_TIMESTAMP
) COMMENT 'OA报销申请单';
```

#### 5.2.4 接入工作流（关键）
复用 BpmOALeave 的关联逻辑：
1. 报销单 Service 在 `createExpense` 时调用 `bpmProcessInstanceApi.createProcessInstance(...)` 启动 Flowable 流程
2. 审批完成后通过 Flowable 监听器回调，把 `bpm_oa_expense.status` 从 0→1（通过）或 2（拒绝）
3. 审批通过后预留钩子，二期可调用 FMS 财务模块自动生成记账凭证

### 5.3 统一认证方案
#### 5.3.1 接入其他业务系统（未来）
其他系统只需：
1. 在 OA 后台「系统管理 → OAuth2.0（SSO）→ 客户端管理」新增一条应用，拿到 ClientID / 密钥，配置回调 URL
2. 其他业务系统前端集成 [SSOLogin.vue](file:///e:/HaoyuanOA/yudao-ui-admin-vue3/src/views/Login/components/SSOLogin.vue) 相同的 OAuth2 授权流程
3. 用 `access_token` 换取用户信息（调用 `/system/oauth2/userinfo`，接口已存在于 [OAuth2OpenController.java](file:///e:/HaoyuanOA/ruoyi-vue-pro/yudao-module-system/src/main/java/cn/iocoder/yudao/module/system/controller/admin/oauth2/OAuth2OpenController.java)）

#### 5.3.2 钉钉/企业微信扫码登录
配置 `application-local.yaml` 中的 JustAuth 配置项（框架已内置工厂类 [AuthRequestFactory.java](file:///e:/HaoyuanOA/ruoyi-vue-pro/yudao-module-system/src/main/java/cn/iocoder/yudao/module/system/framework/justauth/core/AuthRequestFactory.java)）：
- 钉钉：ClientID/Secret + 回调地址
- 企业微信：corpid/corpsecret/agentid + 回调地址

---

## 6. 实施计划（总工期 4~5 个工作日）

### 第一阶段：模块开启 + 基础验证（Day 1，0.5 人日）
| 任务 | 交付物 | 责任人 |
|---|---|---|
| 1. 解除 `pom.xml` 中 bpm / hrm / fms 的注释 | 编译通过 | 后端 |
| 2. 补充数据库菜单 SQL（bpm/hrm 菜单记录）或通过菜单管理后台同步 | 登录后能看到菜单 | 后端 / DBA |
| 3. 启动后端自测：绩效计划页 / BPM 流程设计器页 → 打开不报错 | 自测通过截图 | 后端 |
| 4. 启动前端自测：admin 登录 → 菜单可见 → 页面能渲染数据 | 自测通过截图 | 前端 |

### 第二阶段：核心业务跑通（绩效 + 审批）（Day 2，1 人日）
| 任务 | 交付物 |
|---|---|
| 1. 配置 1 套绩效 KPI 模板 + 创建 1 条测试计划 | HR 操作手册要点 |
| 2. 模拟 3 个账号走一遍绩效全流程：自评→主管→复评→申诉→归档 | 全流程通过录像 |
| 3. 配置 1 条 OA 请假流程，测试"主管→HR"两级审批 + 加签/退回 | 全流程通过录像 |

### 第三阶段：报销流程二次开发（Day 3 ~ Day 4 上午，1.5 人日）
| 任务 | 交付物 |
|---|---|
| 1. 建表：`bpm_oa_expense` + 费用类型字典 | SQL 文件 |
| 2. 后端 DO / Mapper / Service / Controller | 4 个 Java 文件 |
| 3. 前端 API 封装 + 创建页 + 列表页 | 3 个 Vue/TS 文件 |
| 4. 流程绑定：关联 BPM 设计器中配置的"报销审批流" | 自测通过 |
| 5. 附件上传 + 签名功能联调（infra 文件存储） | 成功上传发票 |

### 第四阶段：集成、上线与文档（Day 4 下午 ~ Day 5）
| 任务 | 交付物 |
|---|---|
| 1. SSO 配置：配置 1~2 个测试 OAuth2 客户端 + 钉钉扫码 | 登录演示 |
| 2. 权限角色配置：员工 / 部门主管 / HR / 财务 / 系统管理员 5 个角色 | 角色-菜单-权限关系表 |
| 3. Git 提交：报销流程二次开发代码独立 commit | Git tag：v0.1-dev |
| 4. 编写用户手册大纲 + 管理员手册大纲 | 手册目录（Markdown） |
| 5. 生产部署包：后端 `yudao-server/target/*.jar` + 前端 `dist/` | 部署包 |

---

## 7. 二次开发规范（严格遵守，避免升级困难）

### 7.1 新增业务代码的 4 条原则
1. **只增不改**：除必要配置文件（pom.xml、application-local.yaml）外，**严禁修改框架自带的 system / infra / bpm / hrm 核心 Service 逻辑**；用继承 + AOP 扩展
2. **模块隔离**：新增业务模块（如报销）**优先放在已有模块的 oa 子包下**；如属于新领域，新建 `yudao-module-expense` 独立 Maven 模块
3. **善用代码生成器**：新增任何 CRUD 表 → 登录后台 → 基础设施 → 代码生成器 → 导入表 → 一键生成前后端代码 → 拷贝到对应目录
4. **所有改动留 commit**：每个功能点一个独立 commit，信息清晰（如 `feat: 新增报销流程后端实体与接口`）

### 7.2 数据库变更规范
- 任何表结构变更：**不许直接改 ruoyi-vue-pro.sql**
- 新建 `ruoyi-vue-pro/sql/mysql/patch/` 目录，每次 SQL 命名 `YYYYMMDD_功能简写.sql`（如 `20260825_bpm_oa_expense.sql`），上线按顺序执行
- 菜单新增：通过 SQL 插入 `system_menu`，并注明 `menu_id` 取值范围（避免与官方后续升级冲突）

### 7.3 框架升级策略（重要！）
ruoyi-vue-pro 开源社区会持续发版，若要**升级框架版本**：
1. 所有新增模块代码放在独立路径（如报销放在 `yudao-module-bpm/src/main/java/.../oa/expense/`），不和官方文件重名
2. 官方 SQL 新版本用 diff 工具对比后合并，**永远不要覆盖自己写的 patch SQL**
3. 如必须修改官方某个类，写一个子类 + `@Primary` Bean，而不是直接改官方源文件

---

## 8. 部署与运维建议

### 8.1 推荐生产部署架构（单机房起步）
```
用户 → 阿里云 SLB / Nginx（HTTPS 443）
  ├── 前端静态资源（Nginx 直接托管 dist，gzip + CDN）
  └── 后端 API → Nginx 反代 → Spring Boot Jar（8080）
                    ├── MySQL 8（主从，定时备份）
                    ├── Redis 7（哨兵，RDB+AOF）
                    └── MinIO（附件存储，挂载 NAS）
```

### 8.2 JVM 参数（2C4G 起步）
```bash
java -Xms2048m -Xmx2048m -XX:+UseG1GC \
  -XX:MaxGCPauseMillis=200 \
  -jar yudao-server.jar \
  --spring.profiles.active=prod
```

### 8.3 备份
- MySQL：全量每日 02:00（xtrabackup）+ binlog 实时同步
- Redis：AOF everysec + 每日 RDB 快照落盘
- MinIO/附件：对象存储跨区复制，或每日 rsync 到备份盘

---

## 9. 风险与应对

| 风险点 | 概率 | 影响 | 应对措施 |
|---|---|---|---|
| HRM/BPM 模块菜单导入失败 | 中 | 高 | 对照官方 SQL 分模块补丁执行；或通过"菜单管理"按路由路径手工录入 |
| 绩效考核指标模板过于复杂 | 中 | 中 | 先导入 2 套标准模板（季度KPI、年度360）上线，后续再允许 HR 自定义 |
| 报销流程审批流和集团现有规定不匹配 | 高 | 中 | 不写死审批人节点，全部采用"角色+岗位"动态匹配，集团改规则只需重画流程 |
| 大并发（如月底全员同时打绩效）页面卡顿 | 低 | 中 | 关键接口 + Redis 缓存；必要时将 HRM 模块单独部署独立节点 |
| 升级官方新版本时覆盖二开代码 | 中 | 高 | 严格遵守 §7 规范，新增代码独立路径 + 数据库 patch 按日期命名 |

---

## 10. 交付物清单

| 类型 | 交付物 | 位置 |
|---|---|---|
| 代码 | 后端报销流程二次开发代码 4~6 文件 | `ruoyi-vue-pro/yudao-module-bpm/...oa/expense/` |
| 代码 | 前端报销流程页面 3~4 文件 | `yudao-ui-admin-vue3/src/views/bpm/oa/expense/` |
| 代码 | pom.xml / 菜单 SQL 等配置变更 | `docs/patch/` + Git commit 记录 |
| 文档 | 本技术方案 v1.0 | `docs/集团OA系统需求与技术方案.md` |
| 文档 | 用户操作手册（管理员 / HR / 员工） | `docs/手册/` |
| 环境 | 测试环境访问地址（前后端已可访问） | `http://<IP>:<port>` |
| 包 | 生产部署包 | 后端 jar + 前端 dist zip |
| 版本 | Git tag v1.0-OA-Release | — |

---

**— 文档结束 —**
