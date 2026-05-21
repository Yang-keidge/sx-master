# 深灰商务高级风列表重设计 — 实施计划

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the Supabase green dark theme with a deep gray + ice blue business aesthetic across all global styles and list pages.

**Architecture:** Global token swap in CSS/SCSS/JS files, plus targeted table style enhancements in list.vue files. No logic changes.

**Tech Stack:** Vue 2, Element UI 2.x, SCSS, Webpack

**Base path:** `biyeshengshixiyujiuye/src/main/resources/admin/admin/src`

---

## Color Mapping Reference (Old → New)

| Old | New |
|-----|-----|
| `#121212` | `#1a1a2e` |
| `#2e2e2e` | `#252540` |
| `#242424` | `#2a2a45` |
| `#393939` | `#333355` |
| `#fafafa` | `#e8eaf6` |
| `#b4b4b4` | `#a0aec0` |
| `#898989` | `#6b7280` |
| `#4d4d4d` | `#4a4a6a` |
| `#3ecf8e` | `#64b5f6` |
| `#00c573` | `#90caf9` |
| `#006239` | `#1e3a5f` |
| `#1f4b37` | `#1e2a4a` |
| `#f56c6c` | `#ef5350` |
| `#5c1a1a` | `#3a1e2e` |
| `rgba(250,250,250,0.027)` | `#1e1e36` |

---

## Task 1: Global Token Swap — App.vue + element-variables.scss + style.scss

**Files:**
- Modify: `App.vue`
- Modify: `assets/css/element-variables.scss`
- Modify: `assets/css/style.scss`

- [ ] **Step 1: Read all three files**
- [ ] **Step 2: In App.vue**, replace all old color values with new ones (body bg, :root tokens)
- [ ] **Step 3: In element-variables.scss**, replace all old color values with new ones
- [ ] **Step 4: In style.scss**, replace all old color values with new ones
- [ ] **Step 5: Add table hover indicator bar style** to style.scss:
  ```scss
  .el-table tr:hover > td:first-child {
    border-left: 3px solid #64b5f6;
  }
  ```
- [ ] **Step 6: Add table header uppercase style** to style.scss:
  ```scss
  .el-table th.is-leaf {
    text-transform: uppercase;
    letter-spacing: 0.5px;
    font-weight: 500;
  }
  ```
- [ ] **Step 7: Commit**

---

## Task 2: Framework Pages Color Swap

**Files:**
- Modify: `components/index/IndexHeader.vue`
- Modify: `components/index/IndexAsideStatic.vue`
- Modify: `components/index/IndexMain.vue`
- Modify: `views/login.vue`
- Modify: `views/register.vue`
- Modify: `views/home.vue`
- Modify: `views/404.vue`
- Modify: `views/pay.vue`
- Modify: `components/common/BreadCrumbs.vue`

- [ ] **Step 1: Read each file**
- [ ] **Step 2: Replace all hardcoded old colors with new values** using Edit tool with oldString/newString
- [ ] **Step 3: Verify no old colors remain** by searching for `#121212`, `#2e2e2e`, `#3ecf8e`, `#006239` in these files
- [ ] **Step 4: Commit**

---

## Task 3: Home Components Color Swap

**Files:**
- Modify: `components/home/HomeCard.vue`
- Modify: `components/home/HomeComment.vue`
- Modify: `components/home/HomeChart.vue`
- Modify: `components/home/HomeProgress.vue`

- [ ] **Step 1: Read each file**
- [ ] **Step 2: Replace old colors** (`#ffffff` → `#252540`, `#666` → `#a0aec0`, `#888888` → `#6b7280`, etc.)
- [ ] **Step 3: Commit**

---

## Task 4: Runtime Style Files Color Swap

**Files:**
- Modify: `utils/style.css`
- Modify: `utils/style.js`

- [ ] **Step 1: In style.css**, replace remaining old colors (`#DCDFE6` → `#333355`, button colors)
- [ ] **Step 2: In style.js**, use a Python script to bulk replace all old color values in the JSON strings with new values
- [ ] **Step 3: Commit**

---

## Task 5: List.vue Table Enhancement (17 files)

**Files:**
- Modify: `views/modules/*/list.vue` (all 17)

- [ ] **Step 1: Read one representative file** (e.g., `xuesheng/list.vue`) to confirm structure
- [ ] **Step 2: Add hover row indicator bar** to each list.vue's `<style scoped>`:
  ```scss
  .tables {
    &::v-deep .el-table tr:hover > td:first-child {
      border-left: 3px solid #64b5f6;
    }
    &::v-deep .el-table tr:hover > td {
      background-color: #2d2d4a !important;
    }
    &::v-deep .el-table td {
      padding: 12px 16px;
      height: 48px;
    }
    &::v-deep .el-table th {
      padding: 12px 16px;
      height: 48px;
    }
  }
  ```
- [ ] **Step 3: Apply to all 17 list.vue files**
- [ ] **Step 4: Commit**

---

## Task 6: Build Verification

- [ ] **Step 1: Run `cnpm run build`**
- [ ] **Step 2: Check for errors**
- [ ] **Step 3: Fix any issues and re-build**
- [ ] **Step 4: Final commit**

---

## Self-Review

### Spec Coverage
- ✅ App.vue tokens → Task 1
- ✅ Element UI variables → Task 1
- ✅ Global component overrides → Task 1
- ✅ Framework pages → Task 2
- ✅ Home components → Task 3
- ✅ Runtime styles → Task 4
- ✅ Table enhancements (hover bar, row height, padding) → Task 5
- ✅ Build verification → Task 6

### Placeholder Scan
- No TBD/TODO.
- All color values are literal hex codes.
- File paths are exact.

### Type Consistency
- All new colors are consistent across tasks.
- `#64b5f6` is the only accent color everywhere.
