# 前端重设计 —— Supabase 暗色终端风格

## 目标
将现有 Vue 2 + Element UI 后台管理系统的前端样式全部替换为 DESIGN.md（Supabase 暗色终端风格）定义的设计规范。

## 范围
- **全局样式层**：`App.vue`、`assets/css/style.scss`、`assets/css/element-variables.scss`
- **框架级页面**：`login.vue`、`index.vue`、`home.vue`、`IndexHeader.vue`、`IndexAsideStatic.vue`、`IndexMain.vue`
- **业务模块页面**：所有 `views/modules/*/*.vue`（约 40+ 个 list.vue 和 add-or-update.vue）
- **静态资源**：移除/替换不再需要的亮色背景图

## 设计规范映射

### 颜色 Token
| Token | 值 | 用途 |
|-------|-----|------|
| --color-ebony-canvas | #121212 | 页面主背景 |
| --color-steel-surface | #2e2e2e | 卡片、侧边栏、弹窗背景 |
| --color-graphite-base | #242424 | 按钮次要背景、输入框背景 |
| --color-carbon-border | #393939 | 边框、分割线 |
| --color-whiteout | #fafafa | 主标题、正文、按钮文字 |
| --color-mid-gray-text | #898989 | 次要文字、禁用态 |
| --color-supabase-green | #3ecf8e | 主色、链接、激活态、成功指示 |
| --color-forest-call-to-action | #006239 | 主按钮背景 |
| --color-glow-green | #00c573 | 链接悬停 |
| --color-deep-sea-green | #1f4b37 | 主按钮边框、悬停加深 |

### 排版
- 字体：Inter（Circular 的替代）, system-ui
- 正文字号：14px / 1.5
- 标题：18px / 1.38 至 24px / 1.33
- 字间距：-0.007em

### 间距与圆角
- 基础间距：8px
- 卡片内边距：24px
- 卡片圆角：16px
- 按钮/输入框圆角：6px
- 胶囊按钮圆角：9999px

### 阴影与层级
- 不使用 box-shadow 做层级，通过背景色变化（#121212 → #2e2e2e）区分表面层级。

## 架构策略

1. **CSS 自定义属性**：在 `App.vue` 全局注入 `:root` token。
2. **Element UI 变量覆盖**：重写 `element-variables.scss`，将 `$--color-primary`、`$--color-text-primary`、`$--color-text-regular`、`$--background-color-base`、`$--border-color-base` 等映射到暗色 token。
3. **全局组件覆盖**：在 `style.scss` 中针对 `.el-table`、`.el-form`、`.el-input`、`.el-button`、`.el-dialog`、`.el-pagination`、`.el-menu`、`.el-radio` 等写覆盖规则，确保所有 Element UI 组件呈现暗色风格。
4. **页面级清理**：逐个检查所有业务 `.vue` 文件，移除硬编码的 `#fff`、`#ffffff`、`#333`、`#000`、白色背景等亮色样式，确保继承全局暗色主题。

## 组件设计

### 登录页 (login.vue)
- 全屏背景 `#121212`
- 居中/左侧登录卡片：`Steel Surface` 背景，16px 圆角，24px padding
- 标题：Whiteout，24px
- 输入框：`rgba(250,250,250,0.027)` 背景，`#393939` 边框，6px 圆角，白色文字
- 登录按钮：`Forest Call to Action` 背景，`Supabase Green` 边框，6px 圆角
- 角色单选框：白色文字，选中绿色

### 顶部导航 (IndexHeader.vue)
- 背景 `#121212`
- 标题：Whiteout，20px
- 用户信息/退出：Mid-Gray Text，悬停变 Whiteout
- 底部边框 `#393939` 分隔

### 侧边菜单 (IndexAsideStatic.vue)
- 背景 `#2e2e2e`
- 菜单项文字：Whiteout / Silver Highlight
- 激活态：`Supabase Green` 文字 + `Graphite Base` 背景
- 悬停态：`Graphite Base` 背景
- 去除原有绿色 `#19A97B` 和亮色 `#FCFCFC`

### 主内容区 (IndexMain.vue)
- 背景 `#121212`
- 面包屑：Silver Highlight 文字
- 路由视图容器：`Steel Surface` 背景，16px 圆角

### 首页 (home.vue)
- 背景 `#121212`
- 欢迎文字：Whiteout，36px 标题 + 18px 副标题

### 业务列表页 (list.vue)
- 查询表单区：`Steel Surface` 卡片背景，内部输入框/选择器使用暗色风格
- 数据表格：`Steel Surface` 表头背景，`#121212` 行背景，交替行 `#1a1a1a`，边框 `#393939`
- 分页器：暗色按钮，激活页绿色
- 操作按钮：Primary（绿色）、Secondary（石墨色）、Danger（暗红）

### 新增/编辑页 (add-or-update.vue)
- 弹窗/表单：`Steel Surface` 背景
- 输入框、选择器、日期选择器统一暗色
- 按钮组：Primary + Ghost 组合

## 业务页面清单

### list.vue (12)
- dictionaryBanji, dictionaryGonggaoLaoshi, dictionaryGonggaoQiye, dictionaryQiye,
- dictionarySex, dictionaryShixi, dictionaryShixiJieguo, dictionaryYuanxi,
- gonggaoLaoshi, gonggaoQiye, jiuye, laoshi, qiye, shixi, users, xuesheng, dictionary

### add-or-update.vue (17)
- 同上对应模块

## 验收标准
- [ ] 所有页面背景为暗色（#121212 或 #2e2e2e），无白色/亮色残留
- [ ] Element UI 所有组件（表格、表单、输入框、按钮、菜单、分页、弹窗、选择器、日期选择器）呈现暗色风格
- [ ] 主交互色统一为 `#3ecf8e`（Supabase Green）
- [ ] 文字对比度满足可读性：主文字 `#fafafa`，次要文字 `#898989`
- [ ] 登录页、框架布局、首页、所有业务页面风格一致
- [ ] `cnpm run build` 无样式相关报错
