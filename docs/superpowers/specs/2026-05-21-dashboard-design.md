# 管理员首页 Dashboard 数据统计分析模块 — 设计文档

> **版本:** v1.0  
> **日期:** 2026-05-21  
> **方案:** B（推荐完整版）

---

## 一、项目背景与目标

在现有「毕业生实习与就业管理系统」中，管理员首页 (`home.vue`) 目前仅显示一段静态欢迎文字。本模块目标为：在管理员登录后的首页，替换为一个完整的数据可视化分析 Dashboard，实时展示系统核心业务数据，提升系统专业性与答辩展示效果。

---

## 二、架构概述

### 2.1 技术栈

| 层级 | 技术 |
|------|------|
| 前端 | Vue 2.6 + Element UI 2.13 + ECharts 4.6 + Axios |
| 后端 | Spring Boot 2.2.2 + MyBatis-Plus 2.x + Java 8 |
| 数据库 | MySQL 5.7 |

### 2.2 模块边界

- **新增后端文件：** `DashboardController.java`, `DashboardService.java`, `DashboardServiceImpl.java`, `DashboardDao.java`, `DashboardDao.xml`
- **修改前端文件：** `home.vue`（完全重写为 Dashboard 页面）
- **修改数据文件：** `db.sql`（更新字典表 `shixi_types` 与 `shixi_jieguo_types` 的中文名称）
- **不修改任何现有 Controller/Service/Mapper/Entity**

### 2.3 数据流

```
前端 home.vue ──HTTP GET──► DashboardController
                                      │
                                      ▼
                            DashboardServiceImpl
                                      │
                                      ▼
                              DashboardDao (SQL)
                                      │
                                      ▼
                                   MySQL
```

---

## 三、后端接口设计

所有接口统一返回 `R` 对象（`code: 0, msg, data`）。

### 3.1 数据总览 — GET /dashboard/base

返回系统核心统计数据。

**返回格式：**
```json
{
  "code": 0,
  "msg": "success",
  "data": {
    "studentCount": 1520,
    "shixiCount": 1300,
    "jiuyeCount": 1180,
    "qiyeCount": 260,
    "laoshiCount": 80,
    "employmentRate": 77.6,
    "shixiRate": 85.5,
    "monthShixiCount": 96
  }
}
```

**统计逻辑：**
| 字段 | SQL 逻辑 |
|------|---------|
| studentCount | `SELECT COUNT(*) FROM xuesheng` |
| shixiCount | `SELECT COUNT(*) FROM shixi` |
| jiuyeCount | `SELECT COUNT(*) FROM jiuye` |
| qiyeCount | `SELECT COUNT(*) FROM qiye` |
| laoshiCount | `SELECT COUNT(*) FROM laoshi` |
| employmentRate | `jiuyeCount / studentCount * 100`，保留1位小数 |
| shixiRate | `COUNT(shixi_jieguo_types IN (1,2)) / shixiCount * 100`，保留1位小数 |
| monthShixiCount | `SELECT COUNT(*) FROM shixi WHERE MONTH(create_time)=MONTH(NOW()) AND YEAR(create_time)=YEAR(NOW())` |

---

### 3.2 实习类型统计 — GET /dashboard/shixiType

**返回格式：**
```json
{
  "code": 0,
  "msg": "success",
  "data": [
    {"name": "校内实习", "value": 180},
    {"name": "校外实习", "value": 420},
    {"name": "自主实习", "value": 260},
    {"name": "集中实习", "value": 0}
  ]
}
```

**SQL：**
```sql
SELECT d.index_name AS name, COUNT(s.id) AS value
FROM dictionary d
LEFT JOIN shixi s ON s.shixi_types = d.code_index
WHERE d.dic_code = 'shixi_types'
GROUP BY d.code_index, d.index_name
ORDER BY d.code_index
```

---

### 3.3 就业率统计 — GET /dashboard/employmentRate

**返回格式：**
```json
{
  "code": 0,
  "msg": "success",
  "data": 86.5
}
```

**计算：** `employmentRate = (jiuyeCount / studentCount) * 100`，保留1位小数。

---

### 3.4 实习结果统计 — GET /dashboard/shixiResult

**返回格式：**
```json
{
  "code": 0,
  "msg": "success",
  "data": [
    {"name": "优秀", "value": 120},
    {"name": "良好", "value": 300},
    {"name": "一般", "value": 90},
    {"name": "较差", "value": 10}
  ]
}
```

**SQL：**
```sql
SELECT d.index_name AS name, COUNT(s.id) AS value
FROM dictionary d
LEFT JOIN shixi s ON s.shixi_jieguo_types = d.code_index
WHERE d.dic_code = 'shixi_jieguo_types'
GROUP BY d.code_index, d.index_name
ORDER BY d.code_index
```

---

### 3.5 月度趋势分析 — GET /dashboard/monthTrend

**返回格式：**
```json
{
  "code": 0,
  "msg": "success",
  "data": {
    "xData": ["1月","2月","3月","4月","5月","6月","7月","8月","9月","10月","11月","12月"],
    "yData": [0,0,20,35,60,95,120,0,0,0,0,0]
  }
}
```

**SQL：**
```sql
SELECT DATE_FORMAT(create_time, '%c') AS monthNum, COUNT(*) AS total
FROM shixi
WHERE create_time IS NOT NULL
GROUP BY monthNum
ORDER BY monthNum
```

**注意：** 后端返回1-12月的完整数据，无数据的月份补0。

---

### 3.6 企业招聘 TOP10 — GET /dashboard/companyTop

**返回格式：**
```json
{
  "code": 0,
  "msg": "success",
  "data": [
    {"name": "企业名称2", "value": 30},
    {"name": "企业名称1", "value": 25}
  ]
}
```

**SQL：**
```sql
SELECT q.qiye_name AS name, COUNT(j.id) AS value
FROM jiuye j
LEFT JOIN qiye q ON j.qiye_id = q.id
WHERE q.qiye_name IS NOT NULL
GROUP BY q.qiye_name
ORDER BY value DESC
LIMIT 10
```

---

## 四、前端页面设计

### 4.1 页面文件

- **文件路径：** `biyeshengshixiyujiuye/src/main/resources/admin/admin/src/views/home.vue`
- **修改方式：** 完全重写（原页面为纯欢迎文字）

### 4.2 布局结构

```text
┌────────────────────────────────────────────────────────┐
│  [当前时间显示]                                    [刷新按钮]  │
├────────────────────────────────────────────────────────┤
│  ┌────────┐ ┌────────┐ ┌────────┐ ┌────────┐ ┌────────┐ │
│  │学生总数 │ │实习人数 │ │就业人数 │ │企业数量 │ │就业率  │ │
│  │ 1,520  │ │ 1,300  │ │ 1,180  │ │  260   │ │ 77.6%  │ │
│  └────────┘ └────────┘ └────────┘ └────────┘ └────────┘ │
├─────────────────────────┬──────────────────────────────┤
│    实习类型统计 (饼图)    │      就业率统计 (仪表盘)       │
├─────────────────────────┴──────────────────────────────┤
│    实习结果统计 (柱状图)  │      月度趋势分析 (折线图)    │
├────────────────────────────────────────────────────────┤
│              企业招聘 TOP10 (横向柱状图)                  │
└────────────────────────────────────────────────────────┘
```

### 4.3 组件划分

| 组件 | Element UI 组件 | ECharts 类型 |
|------|----------------|-------------|
| 顶部时间 & 刷新按钮 | `el-row` + `el-button` | — |
| 统计卡片区域 | `el-card` × 5 | — |
| 实习类型统计 | `el-card` | `pie` |
| 就业率统计 | `el-card` | `gauge` |
| 实习结果统计 | `el-card` | `bar` |
| 月度趋势分析 | `el-card` | `line` |
| 企业 TOP10 | `el-card` | `bar` (横向) |

### 4.4 交互设计

1. **页面加载时：** 并行请求 6 个接口，显示 `v-loading` 遮罩
2. **自动刷新：** `setInterval` 每 30000ms 重新拉取所有数据
3. **手动刷新：** 右上角刷新按钮，点击立即重新拉取
4. **当前时间：** `setInterval` 每秒更新 `YYYY-MM-DD HH:mm:ss` 格式
5. **图表动画：** ECharts 开启 `animation: true`，`animationDuration: 1000`

### 4.5 样式规范

| 元素 | 规范 |
|------|------|
| 页面背景 | `#f0f2f5`（浅灰，Element UI 后台常用） |
| 卡片背景 | `#ffffff` |
| 卡片圆角 | `border-radius: 8px` |
| 卡片阴影 | `box-shadow: 0 2px 12px 0 rgba(0,0,0,0.1)` |
| 主色调 | `#409EFF`（Element UI 默认蓝色） |
| 成功色 | `#67C23A` |
| 警告色 | `#E6A23C` |
| 危险色 | `#F56C6C` |
| 文字主色 | `#303133` |
| 文字次色 | `#606266` |

---

## 五、数据库变更

### 5.1 更新字典表 — 实习类型 (`shixi_types`)

```sql
UPDATE dictionary SET index_name = '校内实习' WHERE dic_code = 'shixi_types' AND code_index = 1;
UPDATE dictionary SET index_name = '校外实习' WHERE dic_code = 'shixi_types' AND code_index = 2;
INSERT INTO dictionary (dic_code, dic_name, code_index, index_name, super_id, beizhu, create_time)
VALUES ('shixi_types', '实习信息类型', 3, '自主实习', NULL, NULL, NOW()),
       ('shixi_types', '实习信息类型', 4, '集中实习', NULL, NULL, NOW());
```

### 5.2 更新字典表 — 实习结果 (`shixi_jieguo_types`)

```sql
UPDATE dictionary SET index_name = '优秀' WHERE dic_code = 'shixi_jieguo_types' AND code_index = 1;
UPDATE dictionary SET index_name = '良好' WHERE dic_code = 'shixi_jieguo_types' AND code_index = 2;
UPDATE dictionary SET index_name = '较差' WHERE dic_code = 'shixi_jieguo_types' AND code_index = 3;
```

> **说明：** 现有 seed 数据中的 `shixi` 表记录使用的 `shixi_types` 值为 1 和 2，`shixi_jieguo_types` 值为 1、2、3。更新后名称与 spec 一致。新增 3、4 两种实习类型在现有数据中无记录，图表会显示为 0，不影响功能。

---

## 六、文件清单

### 6.1 新增文件

| 文件 | 说明 |
|------|------|
| `biyeshengshixiyujiuye/src/main/java/com/controller/DashboardController.java` | 6 个 Dashboard 接口 |
| `biyeshengshixiyujiuye/src/main/java/com/service/DashboardService.java` | Service 接口 |
| `biyeshengshixiyujiuye/src/main/java/com/service/impl/DashboardServiceImpl.java` | Service 实现 |
| `biyeshengshixiyujiuye/src/main/java/com/dao/DashboardDao.java` | Mapper 接口 |
| `biyeshengshixiyujiuye/src/main/resources/mapper/DashboardDao.xml` | Mapper XML |

### 6.2 修改文件

| 文件 | 修改说明 |
|------|---------|
| `biyeshengshixiyujiuye/src/main/resources/admin/admin/src/views/home.vue` | 完全重写为 Dashboard 页面 |
| `db.sql` | 更新字典表 `shixi_types` 和 `shixi_jieguo_types` 数据 |

---

## 七、技术约束与注意事项

1. **MyBatis-Plus 版本：** 本项目使用 2.x API（`EntityWrapper` / `Wrapper`），**不得**使用 3.x 的 `LambdaQueryWrapper`。本模块的 Mapper XML 中使用原生 SQL，不依赖 MyBatis-Plus 条件构造器，因此无版本冲突。
2. **上下文路径：** 所有后端接口路径为 `/dashboard/xxx`，前端通过 Axios baseURL `/biyeshengshixiyujiuye` 自动拼接为 `/biyeshengshixiyujiuye/dashboard/xxx`。
3. **权限：** Dashboard 接口挂载在 `/dashboard` 下，由现有 `AuthorizationInterceptor` 统一拦截，无需额外配置。管理员登录后会自动携带 `Token` 请求头。
4. **ECharts 引入：** 前端使用 `npm install` 已包含 `echarts@4.6.0`，页面内通过 `import echarts from 'echarts'` 引入。
5. **响应式：** 使用 `el-col :xs :sm :md :lg` 实现响应式，大屏下 5 卡片并排，中屏 3+2，小屏 2+2+1。

---

## 八、验收标准

1. 管理员登录后，首页显示 Dashboard 而非静态欢迎文字
2. 页面加载后 3 秒内，所有卡片和图表渲染完成
3. 每 30 秒数据自动刷新，图表平滑过渡
4. 当前时间每秒更新
5. 就业率仪表盘数值与 `jiuyeCount/studentCount` 计算一致
6. 饼图显示的实习类型名称与字典表更新后的名称一致
7. 柱状图显示的实习结果名称与字典表更新后的名称一致
8. 折线图显示 1-12 月完整数据，无数据月份为 0
9. TOP10 按招聘人数降序排列，最多显示 10 条
10. 无浏览器控制台报错
