# 列表页深灰商务高级风重设计

## 背景
当前列表页存在配色突兀（黑白绿对比强烈）、按钮颜色杂乱（success/primary/danger 同时出现）、表格样式粗糙、缺乏层次感等问题。需要将整体风格从 Supabase 暗绿终端风升级为深灰商务高级风（类似 Stripe Dashboard / AWS Console）。

## 设计目标
- 消除刺眼的绿色，改用冰蓝 `#64b5f6` 作为唯一强调色
- 深蓝灰基调 `#1a1a2e`，营造冷静、专业的数据面板氛围
- 表格采用"无边框+hover高亮+左侧指示条"的高级数据表格风格
- 按钮统一灰色调，仅 hover 时泛冰蓝，删除操作单独用暗红文字
- 搜索区与表格区有清晰的卡片层级分隔

## Token 映射（全局替换）

| Token | 旧值 | 新值 | 用途 |
|-------|------|------|------|
| page-bg | `#121212` | `#1a1a2e` | 页面主背景 |
| card-bg | `#2e2e2e` | `#252540` | 卡片/面板/表格容器 |
| header-bg | `#2e2e2e` | `#1e1e36` | 表头/顶部栏 |
| row-odd | `#121212` | `#1a1a2e` | 表格奇数行 |
| row-even | — | `#22223a` | 表格偶数行（交替） |
| row-hover | `#1a1a1a` | `#2d2d4a` | 表格行 hover |
| accent | `#3ecf8e` | `#64b5f6` | 主强调色（链接、激活、hover） |
| accent-light | `#00c573` | `#90caf9` | 强调色 hover 态 |
| accent-dark | `#006239` | `#1e3a5f` | 主按钮背景 |
| text-primary | `#fafafa` | `#e8eaf6` | 主标题/正文 |
| text-secondary | `#b4b4b4` | `#a0aec0` | 次要文字 |
| text-muted | `#898989` | `#6b7280` | 禁用/提示文字 |
| border | `#393939` | `#333355` | 边框/分隔线 |
| input-bg | `rgba(250,250,250,0.027)` | `#1e1e36` | 输入框背景 |
| danger-text | `#f56c6c` | `#ef5350` | 删除/危险操作文字 |
| danger-bg | `#5c1a1a` | `#3a1e2e` | 危险操作 hover 背景 |

## 组件重设计细节

### 搜索区（form-content）
- 背景：`#252540`
- 圆角：12px
- padding：20px 24px
- 输入框：背景 `#1e1e36`，边框 `#333355`，圆角 6px，文字 `#e8eaf6`
- 按钮：
  - 查询：`#1e3a5f` 背景，`#64b5f6` 文字，无边框
  - 新增/导出/导入：`#2a2a45` 背景，`#a0aec0` 文字，无边框，hover 变 `#333355` + `#64b5f6`
  - 删除：`#3a1e2e` 背景，`#ef5350` 文字

### 数据表格（.el-table）
- 表头：背景 `#1e1e36`，文字 `#a0aec0`，字号 13px，字重 500，全大写（text-transform: uppercase）
- 行高：48px
- 单元格 padding：12px 16px
- 奇数行：背景 `#1a1a2e`
- 偶数行：背景 `#22223a`
- 边框：去掉实线，用 1px `#252540` 细线分隔，或完全无边框
- Hover：行背景 `#2d2d4a`，左侧出现 3px 冰蓝指示条
- 选中行：背景 `#2d2d4a`

### 操作按钮（表格内）
- 全部去掉 colorful 背景，统一为 text button 风格：
  - 默认：`#2a2a45` 背景，`#a0aec0` 文字，圆角 4px，padding 4px 8px
  - Hover：`#333355` 背景，`#64b5f6` 文字
  - 删除：默认 `#a0aec0`，hover `#ef5350` 文字 + `#3a1e2e` 背景
- 按钮间间距：8px

### 分页（.el-pagination）
- 按钮背景：`#252540`，文字 `#a0aec0`，圆角 6px
- 激活页：`#1e3a5f` 背景，`#64b5f6` 文字
- Hover：`#2d2d4a` 背景，`#64b5f6` 文字
- 总条数/跳转文字：`#6b7280`

## 全局联动文件

以下文件需要同步替换 token：
1. `App.vue` — body 背景 `#1a1a2e`，root token
2. `element-variables.scss` — `$--color-primary: #64b5f6`
3. `style.scss` — 所有覆盖色全面替换
4. `IndexMain.vue` — 主内容区背景、卡片背景
5. `IndexHeader.vue` — 导航栏背景、边框
6. `IndexAsideStatic.vue` — 侧边栏背景、菜单激活态
7. `login.vue` / `register.vue` — 页面背景、卡片背景
8. `utils/style.js` — listStyle / addStyle 运行时颜色配置
9. `utils/style.css` — 按钮覆盖色
10. `home.vue` / `404.vue` / `pay.vue` — 背景色
11. `HomeCard.vue` / `HomeComment.vue` / `HomeChart.vue` / `HomeProgress.vue` — 背景色
12. `BreadCrumbs.vue` — 背景色、文字色
13. **所有 17 个 list.vue** — 表格样式微调（hover 指示条、行高、边框）

## 验收标准
- [ ] 页面整体为深蓝灰 `#1a1a2e`，无绿色残留
- [ ] 表格呈现高级数据面板质感（无边框/细线、hover 左侧冰蓝指示条、48px 行高）
- [ ] 按钮统一灰色调，hover 泛冰蓝，删除操作暗红文字
- [ ] 搜索区与表格区有清晰的卡片层级（`#252540` 圆角卡片）
- [ ] `cnpm run build` 通过
