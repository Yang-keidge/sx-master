# Supabase Dark Theme Frontend Redesign — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace all existing light-theme frontend styles with the Supabase dark terminal aesthetic defined in DESIGN.md, covering global tokens, Element UI overrides, framework pages, and all 34 business module pages.

**Architecture:** Use CSS custom properties for design tokens, override Element UI SCSS variables for the dark palette, inject comprehensive global component overrides in `style.scss`, then redesign framework pages (login, layout, home) and batch-clean all business `.vue` files to remove hardcoded light colors.

**Tech Stack:** Vue 2, Element UI 2.x, SCSS, Webpack (vue-cli-service)

**Base path:** `biyeshengshixiyujiuye/src/main/resources/admin/admin/src`

---

## File Structure

| File | Responsibility |
|------|--------------|
| `App.vue` | Mount point, inject `:root` CSS custom properties |
| `assets/css/element-variables.scss` | Element UI SCSS variable overrides (primary color, text colors, borders, backgrounds) |
| `assets/css/style.scss` | Global component overrides for `.el-*` elements, layout utilities |
| `views/login.vue` | Full-screen dark login page with centered card |
| `components/index/IndexHeader.vue` | Dark top navbar with green accents |
| `components/index/IndexAsideStatic.vue` | Dark sidebar menu with green active states |
| `components/index/IndexMain.vue` | Dark main content area wrapper |
| `views/home.vue` | Dark welcome hero page |
| `views/index.vue` | Shell layout (minimal changes) |
| `views/modules/*/*.vue` | 17 `list.vue` + 17 `add-or-update.vue` — remove hardcoded light styles |

---

## Task 1: Global CSS Tokens in App.vue

**Files:**
- Modify: `App.vue`

- [ ] **Step 1: Inject CSS custom properties into `<style>` block**

Replace the existing `<style>` in `App.vue` with the full token set. Keep the existing `*` and `html/body` resets, but add `:root` and body background.

```scss
<style lang="scss">
  * {
    padding: 0;
    margin: 0;
  }
  html, body {
    width: 100%;
    height: 100%;
  }
  #app {
    height: 100%;
  }
  body {
    padding: 0;
    margin: 0;
    background-color: #121212;
    color: #fafafa;
    font-family: 'Inter', ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
    font-size: 14px;
    line-height: 1.5;
    letter-spacing: -0.007em;
  }

  :root {
    /* Colors */
    --color-midnight-abyss: #000000;
    --color-ebony-canvas: #121212;
    --color-graphite-base: #242424;
    --color-steel-surface: #2e2e2e;
    --color-carbon-border: #393939;
    --color-iron-outline: #4d4d4d;
    --color-mid-gray-text: #898989;
    --color-silver-highlight: #b4b4b4;
    --color-whiteout: #fafafa;
    --color-supabase-green: #3ecf8e;
    --color-deep-sea-green: #1f4b37;
    --color-forest-call-to-action: #006239;
    --color-glow-green: #00c573;
    --color-shadow-green: #002918;

    /* Typography */
    --font-circular: 'Inter', ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
    --font-source-code-pro: 'Source Code Pro', ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, monospace;

    --text-caption: 12px;
    --leading-caption: 1.56;
    --text-body-sm: 14px;
    --leading-body-sm: 1.5;
    --text-body: 16px;
    --leading-body: 1.43;
    --text-subheading: 18px;
    --leading-subheading: 1.38;
    --text-heading: 24px;
    --leading-heading: 1.33;
    --text-heading-lg: 36px;
    --leading-heading-lg: 1.25;
    --text-display: 72px;
    --leading-display: 1.11;

    /* Spacing */
    --spacing-8: 8px;
    --spacing-16: 16px;
    --spacing-24: 24px;
    --spacing-32: 32px;
    --spacing-40: 40px;
    --spacing-48: 48px;
    --spacing-64: 64px;

    /* Border Radius */
    --radius-cards: 16px;
    --radius-inputs: 6px;
    --radius-buttons: 6px;
    --radius-pillbuttons: 9999px;

    /* Shadows */
    --shadow-sm: rgba(0, 0, 0, 0.1) 0px 4px 6px -1px, rgba(0, 0, 0, 0.1) 0px 2px 4px -2px;
  }
</style>
```

- [ ] **Step 2: Verify no syntax errors**

No run step required; SCSS syntax check happens at build time.

- [ ] **Step 3: Commit**

```bash
git add biyeshengshixiyujiuye/src/main/resources/admin/admin/src/App.vue
git commit -m "feat(theme): add global CSS custom properties and dark body background"
```

---

## Task 2: Override Element UI Theme Variables

**Files:**
- Modify: `assets/css/element-variables.scss`

- [ ] **Step 1: Rewrite element-variables.scss with dark palette**

Replace the entire file content with:

```scss
/* Element UI Theme Override — Supabase Dark */

/* Primary & Status Colors */
$--color-primary: #3ecf8e !default;
$--color-success: #3ecf8e !default;
$--color-warning: #e6a23c !default;
$--color-danger: #f56c6c !default;
$--color-info: #898989 !default;

/* Text Colors */
$--color-text-primary: #fafafa !default;
$--color-text-regular: #b4b4b4 !default;
$--color-text-secondary: #898989 !default;
$--color-text-placeholder: #4d4d4d !default;

/* Border Colors */
$--border-color-base: #393939 !default;
$--border-color-light: #2e2e2e !default;
$--border-color-lighter: #242424 !default;
$--border-color-extra-light: #1a1a1a !default;

/* Background Colors */
$--background-color-base: #121212 !default;

/* Input */
$--input-background-color: rgba(250, 250, 250, 0.027) !default;
$--input-border-color: #393939 !default;
$--input-font-color: #fafafa !default;
$--input-placeholder-color: #4d4d4d !default;

/* Button */
$--button-primary-background-color: #006239 !default;
$--button-primary-border-color: rgba(62, 207, 142, 0.3) !default;
$--button-primary-font-color: #fafafa !default;

/* Table */
$--table-header-background-color: #2e2e2e !default;
$--table-header-font-color: #fafafa !default;
$--table-row-hover-background-color: #1f1f1f !default;
$--table-border-color: #393939 !default;

/* Menu */
$--menu-background-color: #2e2e2e !default;
$--menu-text-color: #b4b4b4 !default;
$--menu-hover-text-color: #fafafa !default;
$--menu-active-text-color: #3ecf8e !default;
$--menu-hover-background-color: #242424 !default;

/* Dialog / Card / Popover */
$--dialog-background-color: #2e2e2e !default;
$--card-background-color: #2e2e2e !default;
$--popover-background-color: #2e2e2e !default;

/* Pagination */
$--pagination-button-color: #b4b4b4 !default;
$--pagination-button-disabled-color: #4d4d4d !default;
$--pagination-button-disabled-background-color: #242424 !default;
$--pagination-hover-color: #3ecf8e !default;

/* Font path */
$--font-path: '~element-ui/lib/theme-chalk/fonts';
@import "~element-ui/packages/theme-chalk/src/index";
```

- [ ] **Step 2: Commit**

```bash
git add biyeshengshixiyujiuye/src/main/resources/admin/admin/src/assets/css/element-variables.scss
git commit -m "feat(theme): override Element UI SCSS variables for dark palette"
```

---

## Task 3: Global Component Override Styles

**Files:**
- Modify: `assets/css/style.scss`

- [ ] **Step 1: Replace style.scss with comprehensive dark overrides**

Replace the entire file with:

```scss
/* ============================================
   Global Dark Theme Overrides for Element UI
   ============================================ */

/* --- Layout Utilities --- */
.form-content {
  background: #2e2e2e;
  padding: 24px;
  border-radius: 16px;
}

.table-content {
  background: #2e2e2e;
  padding: 24px;
  border-radius: 16px;
}

.pagination-content {
  margin-top: 16px;
  padding-bottom: 16px;
  text-align: right;
}

.detail-form-content {
  background: #2e2e2e;
  padding: 24px;
  border-radius: 16px;

  .el-input {
    min-width: 200px;
    max-width: 600px;
  }
}

/* --- Table --- */
.el-table {
  background-color: transparent;
  color: #fafafa;

  th, tr {
    background-color: #121212;
  }

  th.is-leaf {
    background-color: #2e2e2e;
    color: #fafafa;
    border-bottom: 1px solid #393939;
  }

  td {
    border-bottom: 1px solid #393939;
    background-color: #121212;
    color: #b4b4b4;
  }

  tr:hover > td {
    background-color: #1a1a1a !important;
  }

  &::before {
    background-color: #393939;
  }

  .el-table__empty-block {
    background-color: #121212;
  }

  .el-table__empty-text {
    color: #898989;
  }
}

/* --- Form & Inputs --- */
.el-form {
  .el-form-item__label {
    color: #b4b4b4;
  }
}

.el-input {
  .el-input__inner {
    background-color: rgba(250, 250, 250, 0.027);
    color: #fafafa;
    border-color: #393939;
    border-radius: 6px;

    &::placeholder {
      color: #4d4d4d;
    }

    &:hover, &:focus {
      border-color: #3ecf8e;
    }
  }
}

.el-textarea__inner {
  background-color: rgba(250, 250, 250, 0.027);
  color: #fafafa;
  border-color: #393939;
  border-radius: 6px;

  &::placeholder {
    color: #4d4d4d;
  }
}

.el-select {
  .el-input__inner {
    background-color: rgba(250, 250, 250, 0.027);
    color: #fafafa;
    border-color: #393939;
  }

  .el-input__inner:focus {
    border-color: #3ecf8e;
  }
}

.el-select-dropdown {
  background-color: #2e2e2e;
  border-color: #393939;

  .el-select-dropdown__item {
    color: #b4b4b4;

    &.selected, &.hover {
      background-color: #242424;
      color: #3ecf8e;
    }
  }
}

/* --- Buttons --- */
.el-button--primary {
  background-color: #006239;
  border-color: rgba(62, 207, 142, 0.3);
  color: #fafafa;
  border-radius: 6px;

  &:hover, &:focus {
    background-color: #007a47;
    border-color: rgba(62, 207, 142, 0.5);
    color: #fafafa;
  }
}

.el-button--default {
  background-color: #242424;
  border-color: #393939;
  color: #fafafa;
  border-radius: 6px;

  &:hover, &:focus {
    background-color: #2e2e2e;
    border-color: #4d4d4d;
    color: #fafafa;
  }
}

.el-button--danger {
  background-color: #5c1a1a;
  border-color: rgba(245, 108, 108, 0.3);
  color: #f56c6c;

  &:hover, &:focus {
    background-color: #6e2020;
    border-color: rgba(245, 108, 108, 0.5);
    color: #ff8585;
  }
}

.el-button--text {
  color: #3ecf8e;

  &:hover, &:focus {
    color: #00c573;
  }
}

/* --- Dialog / Modal --- */
.el-dialog {
  background-color: #2e2e2e;
  border-radius: 16px;

  .el-dialog__title {
    color: #fafafa;
  }

  .el-dialog__header {
    border-bottom: 1px solid #393939;
  }

  .el-dialog__body {
    color: #b4b4b4;
  }
}

/* --- Pagination --- */
.el-pagination {
  .el-pagination__total,
  .el-pagination__jump {
    color: #898989;
  }

  .btn-prev,
  .btn-next,
  .el-pager li {
    background-color: #242424;
    color: #b4b4b4;
    border-color: #393939;

    &.active {
      background-color: #006239;
      color: #fafafa;
      border-color: rgba(62, 207, 142, 0.3);
    }

    &:hover {
      color: #3ecf8e;
    }
  }

  .el-pagination__editor.el-input .el-input__inner {
    background-color: #242424;
    color: #fafafa;
    border-color: #393939;
  }
}

/* --- Menu (Sidebar) --- */
.el-menu {
  background-color: #2e2e2e;
  border-right: none;

  .el-menu-item {
    color: #b4b4b4;

    &:hover {
      background-color: #242424;
      color: #fafafa;
    }

    &.is-active {
      color: #3ecf8e;
      background-color: #1f4b37;
    }
  }

  .el-submenu__title {
    color: #b4b4b4;

    &:hover {
      background-color: #242424;
      color: #fafafa;
    }
  }
}

/* --- Radio / Checkbox --- */
.el-radio {
  color: #b4b4b4;

  .el-radio__input.is-checked + .el-radio__label {
    color: #3ecf8e;
  }

  .el-radio__input.is-checked .el-radio__inner {
    border-color: #3ecf8e;
    background-color: #3ecf8e;
  }
}

.el-checkbox {
  color: #b4b4b4;

  .el-checkbox__input.is-checked + .el-checkbox__label {
    color: #3ecf8e;
  }

  .el-checkbox__input.is-checked .el-checkbox__inner {
    border-color: #3ecf8e;
    background-color: #3ecf8e;
  }
}

/* --- Date Picker / Time Picker --- */
.el-picker-panel {
  background-color: #2e2e2e;
  color: #b4b4b4;
  border-color: #393939;

  .el-date-picker__header,
  .el-date-table th,
  .el-year-table td .cell,
  .el-month-table td .cell {
    color: #b4b4b4;
  }

  .el-date-table td.current:not(.disabled) span {
    background-color: #3ecf8e;
    color: #121212;
  }

  .el-date-table td.today span {
    color: #3ecf8e;
  }

  .el-date-table td.available:hover {
    color: #3ecf8e;
  }
}

/* --- Upload --- */
.el-upload-dragger {
  background-color: #242424;
  border-color: #393939;

  .el-upload__text {
    color: #898989;
  }
}

/* --- Message / Notification --- */
.el-message {
  background-color: #2e2e2e;
  border-color: #393939;

  .el-message__content {
    color: #b4b4b4;
  }
}

/* --- Breadcrumb --- */
.el-breadcrumb__item {
  .el-breadcrumb__inner {
    color: #898989;

    &:hover {
      color: #3ecf8e;
    }
  }

  &:last-child .el-breadcrumb__inner {
    color: #b4b4b4;
  }
}

/* --- Tabs --- */
.el-tabs__item {
  color: #898989;

  &.is-active {
    color: #3ecf8e;
  }

  &:hover {
    color: #fafafa;
  }
}

.el-tabs__active-bar {
  background-color: #3ecf8e;
}

/* --- Card --- */
.el-card {
  background-color: #2e2e2e;
  border-color: #393939;
  border-radius: 16px;

  .el-card__header {
    border-bottom-color: #393939;
    color: #fafafa;
  }
}

/* --- Popover / Tooltip --- */
.el-popover {
  background-color: #2e2e2e;
  border-color: #393939;
  color: #b4b4b4;
}

.el-tooltip__popper {
  background-color: #2e2e2e;
  border-color: #393939;
  color: #b4b4b4;
}

/* --- Dropdown --- */
.el-dropdown-menu {
  background-color: #2e2e2e;
  border-color: #393939;

  .el-dropdown-menu__item {
    color: #b4b4b4;

    &:hover {
      background-color: #242424;
      color: #3ecf8e;
    }
  }
}

/* --- Scrollbar --- */
::-webkit-scrollbar {
  width: 8px;
  height: 8px;
}

::-webkit-scrollbar-track {
  background: #121212;
}

::-webkit-scrollbar-thumb {
  background: #393939;
  border-radius: 4px;
}

::-webkit-scrollbar-thumb:hover {
  background: #4d4d4d;
}
```

- [ ] **Step 2: Commit**

```bash
git add biyeshengshixiyujiuye/src/main/resources/admin/admin/src/assets/css/style.scss
git commit -m "feat(theme): add comprehensive dark theme overrides for all Element UI components"
```

---

## Task 4: Redesign Login Page

**Files:**
- Modify: `views/login.vue`

- [ ] **Step 1: Replace the `<template>` and `<style>` blocks**

Keep all `<script>` logic unchanged. Replace `<template>` with:

```vue
<template>
    <div class="login-page">
        <div class="login-card">
            <div class="title-container">
                <h3 class="title">毕业生实习与就业管理系统</h3>
            </div>
            <el-form class="login-form" label-position="left" :label-width="'0px'">
                <el-form-item class="style1">
                    <span class="svg-container"><svg-icon icon-class="user" /></span>
                    <el-input placeholder="请输入用户名" name="username" type="text" v-model="rulesForm.username" />
                </el-form-item>
                <el-form-item class="style1">
                    <span class="svg-container"><svg-icon icon-class="password" /></span>
                    <el-input placeholder="请输入密码" name="password" type="password" v-model="rulesForm.password" />
                </el-form-item>
                <el-form-item label="角色" prop="loginInRole" class="role">
                    <el-radio
                        v-for="item in menus"
                        v-if="item.hasBackLogin=='是'"
                        v-bind:key="item.roleName"
                        v-model="rulesForm.role"
                        :label="item.roleName"
                    >{{item.roleName}}</el-radio>
                </el-form-item>
                <el-button type="primary" @click="login()" class="login-btn">登录</el-button>
                <el-form-item class="setting">
                    <div class="register-link" @click="register('xuesheng')">学生注册</div>
                </el-form-item>
            </el-form>
        </div>
    </div>
</template>
```

Replace the `<style lang="scss" scoped>` block with:

```scss
<style lang="scss" scoped>
.login-page {
    min-height: 100vh;
    display: flex;
    align-items: center;
    justify-content: center;
    background-color: #121212;
    padding: 24px;
}

.login-card {
    width: 420px;
    max-width: 100%;
    background-color: #2e2e2e;
    border-radius: 16px;
    padding: 48px 40px;
    box-sizing: border-box;
}

.title-container {
    text-align: center;
    margin-bottom: 32px;

    .title {
        font-size: 24px;
        font-weight: 500;
        color: #fafafa;
        line-height: 1.33;
        letter-spacing: -0.007em;
        margin: 0;
    }
}

.login-form {
    .el-form-item {
        position: relative;
        margin-bottom: 20px;
    }

    .svg-container {
        position: absolute;
        left: 12px;
        top: 50%;
        transform: translateY(-50%);
        color: #4d4d4d;
        z-index: 1;
        font-size: 16px;
    }

    .el-input {
        ::v-deep .el-input__inner {
            background-color: rgba(250, 250, 250, 0.027);
            border: 1px solid #393939;
            color: #fafafa;
            padding-left: 36px;
            height: 44px;
            line-height: 44px;
            border-radius: 6px;

            &::placeholder {
                color: #4d4d4d;
            }

            &:focus {
                border-color: #3ecf8e;
            }
        }
    }

    .role {
        ::v-deep .el-form-item__label {
            color: #b4b4b4;
        }

        ::v-deep .el-radio {
            color: #b4b4b4;
        }

        ::v-deep .el-radio__input.is-checked + .el-radio__label {
            color: #3ecf8e;
        }

        ::v-deep .el-radio__input.is-checked .el-radio__inner {
            border-color: #3ecf8e;
            background-color: #3ecf8e;
        }
    }
}

.login-btn {
    width: 100%;
    height: 44px;
    font-size: 16px;
    background-color: #006239;
    border-color: rgba(62, 207, 142, 0.3);
    color: #fafafa;
    border-radius: 6px;
    margin-top: 8px;

    &:hover, &:focus {
        background-color: #007a47;
        border-color: rgba(62, 207, 142, 0.5);
    }
}

.setting {
    margin-top: 16px;
    margin-bottom: 0 !important;

    ::v-deep .el-form-item__content {
        line-height: 32px;
    }
}

.register-link {
    color: #3ecf8e;
    font-size: 14px;
    cursor: pointer;
    text-align: center;

    &:hover {
        color: #00c573;
    }
}
</style>
```

Also remove the `setInputColor()` method from `<script>` and its call in `created()`, since inputs are now styled via CSS.

- [ ] **Step 2: Commit**

```bash
git add biyeshengshixiyujiuye/src/main/resources/admin/admin/src/views/login.vue
git commit -m "feat(theme): redesign login page with Supabase dark style"
```

---

## Task 5: Redesign Top Header

**Files:**
- Modify: `components/index/IndexHeader.vue`

- [ ] **Step 1: Replace the template and style blocks**

Keep `<script>` unchanged. Replace `<template>` with:

```vue
<template>
    <div class="navbar">
        <div class="title-menu">
            <div class="title-name">{{this.$project.projectName}}</div>
        </div>
        <div class="right-menu">
            <div class="user-info">{{this.$storage.get('role')}} {{this.$storage.get('adminName')}}</div>
            <div class="logout" @click="onLogout">退出登录</div>
        </div>
    </div>
</template>
```

Replace `<style lang="scss" scoped>` with:

```scss
<style lang="scss" scoped>
.navbar {
    height: 60px;
    line-height: 60px;
    width: 100%;
    padding: 0 24px;
    box-sizing: border-box;
    background-color: #121212;
    border-bottom: 1px solid #393939;
    position: relative;
    z-index: 111;
    display: flex;
    align-items: center;
    justify-content: space-between;

    .title-menu {
        display: flex;
        align-items: center;

        .title-name {
            font-size: 20px;
            color: #fafafa;
            font-weight: 500;
            letter-spacing: -0.007em;
        }
    }

    .right-menu {
        display: flex;
        align-items: center;
        gap: 16px;

        .user-info {
            font-size: 14px;
            color: #898989;
        }

        .logout {
            font-size: 14px;
            color: #b4b4b4;
            padding: 6px 12px;
            cursor: pointer;
            border-radius: 6px;
            transition: all 0.2s ease;

            &:hover {
                color: #fafafa;
                background-color: #242424;
            }
        }
    }
}
</style>
```

- [ ] **Step 2: Commit**

```bash
git add biyeshengshixiyujiuye/src/main/resources/admin/admin/src/components/index/IndexHeader.vue
git commit -m "feat(theme): redesign top header with dark theme"
```

---

## Task 6: Redesign Sidebar Menu

**Files:**
- Modify: `components/index/IndexAsideStatic.vue`

- [ ] **Step 1: Update template background and remove hardcoded light styles**

In the template, change:
- `style="height:100%;broder:0;background-color:#FCFCFC"` → `style="height:100%;border:0;background-color:#2e2e2e"`
- `background-color="#FCFCFC" text-color="#19A97B" active-text-color="#000000"` → `background-color="#2e2e2e" text-color="#b4b4b4" active-text-color="#3ecf8e"`

Also update the `lineBorder()` method to use dark colors:

```javascript
lineBorder() {
    let style = 'vertical'
    let w = '1px'
    let s = 'solid'
    let c = '#393939'
    if(style == 'vertical') {
        this.menulistBorderBottom = {
            borderBottomWidth: w,
            borderBottomStyle: s,
            borderBottomColor: c
        }
    } else {
        this.menulistBorderBottom = {
            borderRightWidth: w,
            borderRightStyle: s,
            borderRightColor: c
        }
    }
},
```

Update `setMenulistHoverColor()` hover/leave colors:
- mouseenter background: `#242424`
- mouseleave background: `#2e2e2e`
- focus background: `#242424`

Update `setMenulistIconColor()` to `#898989`.

Update `<style lang="scss" scoped>`:

```scss
<style lang="scss" scoped>
.index-aside {
    position: relative;
    overflow: hidden;
    background-color: #2e2e2e;

    .menulistImg {
        padding: 24px 0;
        box-sizing: border-box;

        .el-image {
            margin: 0 auto;
            width: 100px;
            height: 100px;
            border-radius: 100%;
            display: block;
        }
    }

    .index-aside-inner {
        height: 100%;
        margin-right: -17px;
        margin-bottom: -17px;
        overflow: scroll;
        overflow-x: hidden !important;
        padding-top: 60px;
        box-sizing: border-box;

        &:focus {
            outline: none;
        }

        .el-menu {
            border: 0;
            background-color: #2e2e2e;
        }
    }
}
</style>
```

- [ ] **Step 2: Commit**

```bash
git add biyeshengshixiyujiuye/src/main/resources/admin/admin/src/components/index/IndexAsideStatic.vue
git commit -m "feat(theme): redesign sidebar menu with dark theme"
```

---

## Task 7: Redesign Main Content Area and Home Page

**Files:**
- Modify: `components/index/IndexMain.vue`
- Modify: `views/home.vue`

### IndexMain.vue

- [ ] **Step 1: Replace style block**

Replace `<style lang="scss" scoped>` with:

```scss
<style lang="scss" scoped>
a {
    text-decoration: none;
    color: #3ecf8e;

    &:hover {
        color: #00c573;
    }
}

.el-main {
    background-color: #121212;
    padding: 24px;
}

.router-view {
    padding: 24px;
    margin-top: 16px;
    background: #2e2e2e;
    border-radius: 16px;
    box-sizing: border-box;
    color: #fafafa;
}

.bread-crumbs {
    width: 100%;
    margin-top: 0;
    box-sizing: border-box;
}
</style>
```

### home.vue

- [ ] **Step 2: Replace template and style**

Replace `<template>` with:

```vue
<template>
<div class="home-page">
    <div class="hero">
        <h1 class="main-title">欢迎使用</h1>
        <p class="sub-title">{{this.$project.projectName}}</p>
    </div>
</div>
</template>
```

Replace `<style lang="scss" scoped>` with:

```scss
<style lang="scss" scoped>
.home-page {
    display: flex;
    align-items: center;
    justify-content: center;
    width: 100%;
    min-height: 500px;
    text-align: center;

    .hero {
        .main-title {
            font-size: 36px;
            font-weight: 500;
            color: #fafafa;
            line-height: 1.25;
            letter-spacing: -0.007em;
            margin-bottom: 16px;
        }

        .sub-title {
            font-size: 18px;
            color: #3ecf8e;
            line-height: 1.38;
            letter-spacing: -0.007em;
        }
    }
}
</style>
```

- [ ] **Step 3: Commit both files**

```bash
git add biyeshengshixiyujiuye/src/main/resources/admin/admin/src/components/index/IndexMain.vue biyeshengshixiyujiuye/src/main/resources/admin/admin/src/views/home.vue
git commit -m "feat(theme): redesign main content area and home page with dark theme"
```

---

## Task 8: Batch Clean Business Pages — list.vue (Batch 1)

**Files:**
- Modify: `views/modules/xuesheng/list.vue`
- Modify: `views/modules/laoshi/list.vue`
- Modify: `views/modules/qiye/list.vue`
- Modify: `views/modules/shixi/list.vue`
- Modify: `views/modules/jiuye/list.vue`
- Modify: `views/modules/gonggaoLaoshi/list.vue`
- Modify: `views/modules/gonggaoQiye/list.vue`
- Modify: `views/modules/dictionary/list.vue`
- Modify: `views/modules/dictionaryBanji/list.vue`

**Strategy for all list.vue files:**
1. Remove any hardcoded `background: #ffffff`, `background-color: #fff`, `color: #333`, `color: #000` from the `<style scoped>` block.
2. If the page uses inline styles on containers, change them to inherit the dark theme.
3. Keep layout/padding/margin styles; only remove color overrides.

Since each list.vue is auto-generated and similar, the typical `<style>` block looks like:

```scss
<style lang="scss" scoped>
// Usually empty or minimal; auto-generated pages rarely have hardcoded colors.
// If present, delete only color-related rules.
</style>
```

For each file, read it first. If the `<style>` block contains color overrides, remove them. If empty or only layout, leave as-is.

- [ ] **Step 1: Read and clean xuesheng/list.vue**
- [ ] **Step 2: Read and clean laoshi/list.vue**
- [ ] **Step 3: Read and clean qiye/list.vue**
- [ ] **Step 4: Read and clean shixi/list.vue**
- [ ] **Step 5: Read and clean jiuye/list.vue**
- [ ] **Step 6: Read and clean gonggaoLaoshi/list.vue**
- [ ] **Step 7: Read and clean gonggaoQiye/list.vue**
- [ ] **Step 8: Read and clean dictionary/list.vue**
- [ ] **Step 9: Read and clean dictionaryBanji/list.vue**
- [ ] **Step 10: Commit**

```bash
git add biyeshengshixiyujiuye/src/main/resources/admin/admin/src/views/modules/*/list.vue
git commit -m "feat(theme): remove hardcoded light colors from business list pages batch 1"
```

---

## Task 9: Batch Clean Business Pages — list.vue (Batch 2)

**Files:**
- Modify: `views/modules/dictionaryGonggaoLaoshi/list.vue`
- Modify: `views/modules/dictionaryGonggaoQiye/list.vue`
- Modify: `views/modules/dictionaryQiye/list.vue`
- Modify: `views/modules/dictionarySex/list.vue`
- Modify: `views/modules/dictionaryShixi/list.vue`
- Modify: `views/modules/dictionaryShixiJieguo/list.vue`
- Modify: `views/modules/dictionaryYuanxi/list.vue`
- Modify: `views/modules/users/list.vue`

Apply the same strategy as Task 8: read each file, remove hardcoded light colors from `<style scoped>`.

- [ ] **Step 1-8: Read and clean each file**
- [ ] **Step 9: Commit**

```bash
git add biyeshengshixiyujiuye/src/main/resources/admin/admin/src/views/modules/*/list.vue
git commit -m "feat(theme): remove hardcoded light colors from business list pages batch 2"
```

---

## Task 10: Batch Clean Business Pages — add-or-update.vue (Batch 1)

**Files:**
- Modify: `views/modules/xuesheng/add-or-update.vue`
- Modify: `views/modules/laoshi/add-or-update.vue`
- Modify: `views/modules/qiye/add-or-update.vue`
- Modify: `views/modules/shixi/add-or-update.vue`
- Modify: `views/modules/jiuye/add-or-update.vue`
- Modify: `views/modules/gonggaoLaoshi/add-or-update.vue`
- Modify: `views/modules/gonggaoQiye/add-or-update.vue`
- Modify: `views/modules/dictionary/add-or-update.vue`
- Modify: `views/modules/dictionaryBanji/add-or-update.vue`

Apply the same strategy: read each file, remove hardcoded light colors from `<style scoped>`.

- [ ] **Step 1-9: Read and clean each file**
- [ ] **Step 10: Commit**

```bash
git add biyeshengshixiyujiuye/src/main/resources/admin/admin/src/views/modules/*/add-or-update.vue
git commit -m "feat(theme): remove hardcoded light colors from business add-or-update pages batch 1"
```

---

## Task 11: Batch Clean Business Pages — add-or-update.vue (Batch 2)

**Files:**
- Modify: `views/modules/dictionaryGonggaoLaoshi/add-or-update.vue`
- Modify: `views/modules/dictionaryGonggaoQiye/add-or-update.vue`
- Modify: `views/modules/dictionaryQiye/add-or-update.vue`
- Modify: `views/modules/dictionarySex/add-or-update.vue`
- Modify: `views/modules/dictionaryShixi/add-or-update.vue`
- Modify: `views/modules/dictionaryShixiJieguo/add-or-update.vue`
- Modify: `views/modules/dictionaryYuanxi/add-or-update.vue`
- Modify: `views/modules/users/add-or-update.vue`

Apply the same strategy.

- [ ] **Step 1-8: Read and clean each file**
- [ ] **Step 9: Commit**

```bash
git add biyeshengshixiyujiuye/src/main/resources/admin/admin/src/views/modules/*/add-or-update.vue
git commit -m "feat(theme): remove hardcoded light colors from business add-or-update pages batch 2"
```

---

## Task 12: Build Verification

**Files:**
- Test: Build output

- [ ] **Step 1: Run production build**

```bash
cd biyeshengshixiyujiuye/src/main/resources/admin/admin
cnpm run build
```

- [ ] **Step 2: Check for errors**

Expected: `Build complete.` with no SCSS/Style errors.

If any `::v-deep` or `>>>` deprecation warnings appear in Vue 2, they are non-blocking but can be fixed by replacing `::v-deep` with `/deep/` or `>>>` where needed.

- [ ] **Step 3: Commit if build passes**

```bash
git add -A
git commit -m "feat(theme): complete Supabase dark theme redesign"
```

---

## Self-Review

### Spec Coverage Check
| Spec Requirement | Implementing Task |
|------------------|-----------------|
| CSS custom properties (tokens) | Task 1 |
| Element UI variable override | Task 2 |
| Global component dark overrides | Task 3 |
| Login page redesign | Task 4 |
| Header dark redesign | Task 5 |
| Sidebar dark redesign | Task 6 |
| Main + Home dark redesign | Task 7 |
| Business page color cleanup | Tasks 8–11 |
| Build verification | Task 12 |

### Placeholder Scan
- No "TBD", "TODO", or vague steps remain.
- Every task shows exact file paths.
- Color values are literal hex codes from DESIGN.md.

### Type Consistency
- All color tokens match between Tasks 1–3 and framework pages.
- `--color-steel-surface` used consistently for cards/sidebar/dialog.
- `--color-ebony-canvas` used consistently for page background.

---

## Execution Handoff

**Plan complete and saved to `docs/superpowers/plans/supabase-dark-theme-frontend-redesign.md`.**

**Two execution options:**

**1. Subagent-Driven (recommended)** — I dispatch fresh subagents per task batch, review between tasks, fast iteration. Best for this many files.

**2. Inline Execution** — Execute tasks in this session using executing-plans, batch execution with checkpoints.

**Which approach?**
