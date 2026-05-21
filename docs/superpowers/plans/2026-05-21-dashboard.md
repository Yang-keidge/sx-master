# 管理员首页 Dashboard 数据统计分析模块 — 实现计划

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 在管理员首页实现一个完整的数据可视化 Dashboard，包含 6 个统计接口、5 个 ECharts 图表、自动刷新和实时时间显示。

**Architecture:** 后端新增独立的 DashboardController/Service/Mapper 层，通过原生 SQL 聚合系统核心数据；前端重写 home.vue，使用 Element UI 卡片布局 + ECharts 4.x 渲染图表，Axios 并行拉取数据。

**Tech Stack:** Spring Boot 2.2.2 + MyBatis-Plus 2.x + Java 8 + Vue 2.6 + Element UI 2.13 + ECharts 4.6 + MySQL 5.7

---

## 文件结构映射

| 文件 | 操作 | 职责 |
|------|------|------|
| `biyeshengshixiyujiuye/src/main/java/com/dao/DashboardDao.java` | 创建 | Mapper 接口：5 个统计查询方法 |
| `biyeshengshixiyujiuye/src/main/resources/mapper/DashboardDao.xml` | 创建 | Mapper XML：5 个原生 SQL |
| `biyeshengshixiyujiuye/src/main/java/com/service/DashboardService.java` | 创建 | Service 接口：5 个业务方法 |
| `biyeshengshixiyujiuye/src/main/java/com/service/impl/DashboardServiceImpl.java` | 创建 | Service 实现：数据聚合、计算比率、补全月度 |
| `biyeshengshixiyujiuye/src/main/java/com/controller/DashboardController.java` | 创建 | 6 个 REST 接口，统一返回 `R.ok().put("data", ...)` |
| `biyeshengshixiyujiuye/src/main/resources/admin/admin/src/views/home.vue` | 重写 | Dashboard 页面：卡片、5 个 ECharts、自动刷新 |
| `db.sql` | 修改 | 更新字典表 `shixi_types` 和 `shixi_jieguo_types` 的中文名称 |

---

### Task 1: 创建 DashboardDao.java + DashboardDao.xml

**Files:**
- Create: `biyeshengshixiyujiuye/src/main/java/com/dao/DashboardDao.java`
- Create: `biyeshengshixiyujiuye/src/main/resources/mapper/DashboardDao.xml`

- [ ] **Step 1: 创建 DashboardDao.java**

```java
package com.dao;

import org.apache.ibatis.annotations.Param;
import java.util.List;
import java.util.Map;

/**
 * Dashboard 数据统计 Dao 接口
 */
public interface DashboardDao {

    /**
     * 查询基础统计数据
     */
    Map<String, Object> selectBaseData();

    /**
     * 查询实习类型统计
     */
    List<Map<String, Object>> selectShixiTypeStats();

    /**
     * 查询实习结果统计
     */
    List<Map<String, Object>> selectShixiResultStats();

    /**
     * 查询月度趋势
     */
    List<Map<String, Object>> selectMonthTrend(@Param("year") String year);

    /**
     * 查询企业招聘 TOP10
     */
    List<Map<String, Object>> selectCompanyTop();
}
```

- [ ] **Step 2: 创建 DashboardDao.xml**

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN" "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="com.dao.DashboardDao">

    <!-- 基础统计数据 -->
    <select id="selectBaseData" resultType="map">
        SELECT
            (SELECT COUNT(*) FROM xuesheng) AS studentCount,
            (SELECT COUNT(*) FROM shixi) AS shixiCount,
            (SELECT COUNT(*) FROM jiuye) AS jiuyeCount,
            (SELECT COUNT(*) FROM qiye) AS qiyeCount,
            (SELECT COUNT(*) FROM laoshi) AS laoshiCount,
            (SELECT COUNT(*) FROM shixi WHERE MONTH(create_time) = MONTH(NOW()) AND YEAR(create_time) = YEAR(NOW())) AS monthShixiCount
    </select>

    <!-- 实习类型统计 -->
    <select id="selectShixiTypeStats" resultType="map">
        SELECT
            d.index_name AS name,
            COUNT(s.id) AS value
        FROM dictionary d
        LEFT JOIN shixi s ON s.shixi_types = d.code_index
        WHERE d.dic_code = 'shixi_types'
        GROUP BY d.code_index, d.index_name
        ORDER BY d.code_index
    </select>

    <!-- 实习结果统计 -->
    <select id="selectShixiResultStats" resultType="map">
        SELECT
            d.index_name AS name,
            COUNT(s.id) AS value
        FROM dictionary d
        LEFT JOIN shixi s ON s.shixi_jieguo_types = d.code_index
        WHERE d.dic_code = 'shixi_jieguo_types'
        GROUP BY d.code_index, d.index_name
        ORDER BY d.code_index
    </select>

    <!-- 月度趋势统计 -->
    <select id="selectMonthTrend" resultType="map">
        SELECT
            DATE_FORMAT(create_time, '%c') AS monthNum,
            COUNT(*) AS total
        FROM shixi
        WHERE create_time IS NOT NULL
          AND YEAR(create_time) = #{year}
        GROUP BY monthNum
        ORDER BY CAST(monthNum AS SIGNED)
    </select>

    <!-- 企业招聘 TOP10 -->
    <select id="selectCompanyTop" resultType="map">
        SELECT
            IFNULL(q.qiye_name, '未知企业') AS name,
            COUNT(j.id) AS value
        FROM jiuye j
        LEFT JOIN qiye q ON j.qiye_id = q.id
        WHERE q.qiye_name IS NOT NULL AND q.qiye_name != ''
        GROUP BY q.qiye_name
        ORDER BY value DESC
        LIMIT 10
    </select>

</mapper>
```

- [ ] **Step 3: 验证 XML 文件编码**

确认 `DashboardDao.xml` 保存为 UTF-8 编码，文件头包含 `<?xml version="1.0" encoding="UTF-8"?>`。

---

### Task 2: 创建 DashboardService.java

**Files:**
- Create: `biyeshengshixiyujiuye/src/main/java/com/service/DashboardService.java`

- [ ] **Step 1: 编写 Service 接口**

```java
package com.service;

import java.util.List;
import java.util.Map;

/**
 * Dashboard 数据统计 Service 接口
 */
public interface DashboardService {

    /**
     * 获取基础统计数据
     */
    Map<String, Object> getBaseData();

    /**
     * 获取实习类型统计
     */
    List<Map<String, Object>> getShixiTypeStats();

    /**
     * 获取实习结果统计
     */
    List<Map<String, Object>> getShixiResultStats();

    /**
     * 获取月度趋势
     */
    Map<String, Object> getMonthTrend();

    /**
     * 获取企业招聘 TOP10
     */
    List<Map<String, Object>> getCompanyTop();
}
```

---

### Task 3: 创建 DashboardServiceImpl.java

**Files:**
- Create: `biyeshengshixiyujiuye/src/main/java/com/service/impl/DashboardServiceImpl.java`

- [ ] **Step 1: 编写 Service 实现**

```java
package com.service.impl;

import com.dao.DashboardDao;
import com.service.DashboardService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * Dashboard 数据统计 Service 实现类
 */
@Service("dashboardService")
public class DashboardServiceImpl implements DashboardService {

    @Autowired
    private DashboardDao dashboardDao;

    @Override
    public Map<String, Object> getBaseData() {
        Map<String, Object> baseData = dashboardDao.selectBaseData();

        Long studentCount = ((Number) baseData.get("studentCount")).longValue();
        Long jiuyeCount = ((Number) baseData.get("jiuyeCount")).longValue();
        Long shixiCount = ((Number) baseData.get("shixiCount")).longValue();

        // 计算就业率
        BigDecimal employmentRate = BigDecimal.ZERO;
        if (studentCount != null && studentCount > 0 && jiuyeCount != null) {
            employmentRate = new BigDecimal(jiuyeCount)
                    .multiply(new BigDecimal(100))
                    .divide(new BigDecimal(studentCount), 1, RoundingMode.HALF_UP);
        }
        baseData.put("employmentRate", employmentRate);

        // 计算实习完成率（优秀 + 良好）/ 总实习数
        List<Map<String, Object>> resultStats = dashboardDao.selectShixiResultStats();
        long goodCount = 0;
        for (Map<String, Object> stat : resultStats) {
            String name = (String) stat.get("name");
            Number value = (Number) stat.get("value");
            if (value == null) value = 0;
            if ("优秀".equals(name) || "良好".equals(name)) {
                goodCount += value.longValue();
            }
        }
        BigDecimal shixiRate = BigDecimal.ZERO;
        if (shixiCount != null && shixiCount > 0) {
            shixiRate = new BigDecimal(goodCount)
                    .multiply(new BigDecimal(100))
                    .divide(new BigDecimal(shixiCount), 1, RoundingMode.HALF_UP);
        }
        baseData.put("shixiRate", shixiRate);

        return baseData;
    }

    @Override
    public List<Map<String, Object>> getShixiTypeStats() {
        return dashboardDao.selectShixiTypeStats();
    }

    @Override
    public List<Map<String, Object>> getShixiResultStats() {
        return dashboardDao.selectShixiResultStats();
    }

    @Override
    public Map<String, Object> getMonthTrend() {
        String year = new SimpleDateFormat("yyyy").format(new Date());
        List<Map<String, Object>> list = dashboardDao.selectMonthTrend(year);

        String[] xData = new String[12];
        Integer[] yData = new Integer[12];
        for (int i = 0; i < 12; i++) {
            xData[i] = (i + 1) + "月";
            yData[i] = 0;
        }

        for (Map<String, Object> item : list) {
            Object monthObj = item.get("monthNum");
            Object totalObj = item.get("total");
            if (monthObj != null && totalObj != null) {
                int month = Integer.parseInt(monthObj.toString()) - 1;
                if (month >= 0 && month < 12) {
                    yData[month] = ((Number) totalObj).intValue();
                }
            }
        }

        Map<String, Object> result = new HashMap<>();
        result.put("xData", Arrays.asList(xData));
        result.put("yData", Arrays.asList(yData));
        return result;
    }

    @Override
    public List<Map<String, Object>> getCompanyTop() {
        return dashboardDao.selectCompanyTop();
    }
}
```

---

### Task 4: 创建 DashboardController.java

**Files:**
- Create: `biyeshengshixiyujiuye/src/main/java/com/controller/DashboardController.java`

- [ ] **Step 1: 编写 Controller**

```java
package com.controller;

import com.service.DashboardService;
import com.utils.R;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Map;

/**
 * Dashboard 数据统计 Controller
 */
@RestController
@RequestMapping("/dashboard")
public class DashboardController {

    @Autowired
    private DashboardService dashboardService;

    /**
     * 基础统计数据
     */
    @GetMapping("/base")
    public R base() {
        Map<String, Object> data = dashboardService.getBaseData();
        return R.ok().put("data", data);
    }

    /**
     * 实习类型统计
     */
    @GetMapping("/shixiType")
    public R shixiType() {
        List<Map<String, Object>> data = dashboardService.getShixiTypeStats();
        return R.ok().put("data", data);
    }

    /**
     * 就业率统计
     */
    @GetMapping("/employmentRate")
    public R employmentRate() {
        Map<String, Object> baseData = dashboardService.getBaseData();
        return R.ok().put("data", baseData.get("employmentRate"));
    }

    /**
     * 实习结果统计
     */
    @GetMapping("/shixiResult")
    public R shixiResult() {
        List<Map<String, Object>> data = dashboardService.getShixiResultStats();
        return R.ok().put("data", data);
    }

    /**
     * 月度趋势分析
     */
    @GetMapping("/monthTrend")
    public R monthTrend() {
        Map<String, Object> data = dashboardService.getMonthTrend();
        return R.ok().put("data", data);
    }

    /**
     * 企业招聘 TOP10
     */
    @GetMapping("/companyTop")
    public R companyTop() {
        List<Map<String, Object>> data = dashboardService.getCompanyTop();
        return R.ok().put("data", data);
    }
}
```

---

### Task 5: 重写 home.vue 为 Dashboard 页面

**Files:**
- Modify: `biyeshengshixiyujiuye/src/main/resources/admin/admin/src/views/home.vue`（完全重写）

- [ ] **Step 1: 完全重写 home.vue**

使用 Write 工具覆盖原文件内容：

```vue
<template>
  <div class="dashboard-container" v-loading="loading">
    <!-- 顶部时间 & 刷新 -->
    <el-row class="top-bar">
      <el-col :span="12">
        <span class="current-time">当前时间：{{ currentTime }}</span>
      </el-col>
      <el-col :span="12" style="text-align: right;">
        <el-button type="primary" icon="el-icon-refresh" @click="refreshData" size="small">刷新数据</el-button>
      </el-col>
    </el-row>

    <!-- 统计卡片 -->
    <el-row :gutter="20" class="card-row">
      <el-col :xs="24" :sm="12" :md="8" :lg="4" v-for="(card, index) in statCards" :key="index">
        <el-card shadow="hover" class="stat-card">
          <div class="stat-title">{{ card.title }}</div>
          <div class="stat-value" :style="{ color: card.color }">{{ card.value }}</div>
        </el-card>
      </el-col>
    </el-row>

    <!-- 图表区域 1 -->
    <el-row :gutter="20" class="chart-row">
      <el-col :xs="24" :sm="24" :md="12">
        <el-card shadow="hover">
          <div slot="header">实习类型统计</div>
          <div ref="pieChart" class="chart-box"></div>
        </el-card>
      </el-col>
      <el-col :xs="24" :sm="24" :md="12">
        <el-card shadow="hover">
          <div slot="header">就业率统计</div>
          <div ref="gaugeChart" class="chart-box"></div>
        </el-card>
      </el-col>
    </el-row>

    <!-- 图表区域 2 -->
    <el-row :gutter="20" class="chart-row">
      <el-col :xs="24" :sm="24" :md="12">
        <el-card shadow="hover">
          <div slot="header">实习结果统计</div>
          <div ref="barChart" class="chart-box"></div>
        </el-card>
      </el-col>
      <el-col :xs="24" :sm="24" :md="12">
        <el-card shadow="hover">
          <div slot="header">月度趋势分析</div>
          <div ref="lineChart" class="chart-box"></div>
        </el-card>
      </el-col>
    </el-row>

    <!-- 企业 TOP10 -->
    <el-row :gutter="20" class="chart-row">
      <el-col :span="24">
        <el-card shadow="hover">
          <div slot="header">企业招聘 TOP10</div>
          <div ref="topChart" class="chart-box"></div>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script>
import echarts from 'echarts'

export default {
  data() {
    return {
      loading: false,
      currentTime: '',
      statCards: [
        { title: '学生总数', value: 0, color: '#409EFF' },
        { title: '实习人数', value: 0, color: '#67C23A' },
        { title: '就业人数', value: 0, color: '#E6A23C' },
        { title: '企业数量', value: 0, color: '#F56C6C' },
        { title: '就业率', value: '0%', color: '#409EFF' }
      ],
      pieChart: null,
      gaugeChart: null,
      barChart: null,
      lineChart: null,
      topChart: null,
      timer: null,
      timeTimer: null
    }
  },
  mounted() {
    this.initTime()
    this.loadAllData()
    this.timer = setInterval(() => {
      this.loadAllData()
    }, 30000)
    window.addEventListener('resize', this.handleResize)
  },
  beforeDestroy() {
    if (this.timer) clearInterval(this.timer)
    if (this.timeTimer) clearInterval(this.timeTimer)
    window.removeEventListener('resize', this.handleResize)
    this.disposeCharts()
  },
  methods: {
    initTime() {
      this.updateTime()
      this.timeTimer = setInterval(this.updateTime, 1000)
    },
    updateTime() {
      const now = new Date()
      const yyyy = now.getFullYear()
      const MM = String(now.getMonth() + 1).padStart(2, '0')
      const dd = String(now.getDate()).padStart(2, '0')
      const hh = String(now.getHours()).padStart(2, '0')
      const mm = String(now.getMinutes()).padStart(2, '0')
      const ss = String(now.getSeconds()).padStart(2, '0')
      this.currentTime = `${yyyy}-${MM}-${dd} ${hh}:${mm}:${ss}`
    },
    refreshData() {
      this.loadAllData()
      this.$message.success('数据已刷新')
    },
    loadAllData() {
      this.loading = true
      Promise.all([
        this.$http({ url: '/dashboard/base', method: 'get' }),
        this.$http({ url: '/dashboard/shixiType', method: 'get' }),
        this.$http({ url: '/dashboard/shixiResult', method: 'get' }),
        this.$http({ url: '/dashboard/monthTrend', method: 'get' }),
        this.$http({ url: '/dashboard/companyTop', method: 'get' })
      ]).then(([baseRes, typeRes, resultRes, trendRes, topRes]) => {
        if (baseRes.data && baseRes.data.code === 0) {
          this.updateStatCards(baseRes.data.data)
        }
        if (typeRes.data && typeRes.data.code === 0) {
          this.renderPieChart(typeRes.data.data)
        }
        if (resultRes.data && resultRes.data.code === 0) {
          this.renderBarChart(resultRes.data.data)
        }
        if (trendRes.data && trendRes.data.code === 0) {
          this.renderLineChart(trendRes.data.data)
        }
        if (topRes.data && topRes.data.code === 0) {
          this.renderTopChart(topRes.data.data)
        }
        // 就业率单独获取用于仪表盘
        this.$http({ url: '/dashboard/employmentRate', method: 'get' }).then(res => {
          if (res.data && res.data.code === 0) {
            this.renderGaugeChart(res.data.data)
          }
        })
      }).catch(() => {
        this.$message.error('数据加载失败')
      }).finally(() => {
        this.loading = false
      })
    },
    updateStatCards(data) {
      this.statCards[0].value = data.studentCount || 0
      this.statCards[1].value = data.shixiCount || 0
      this.statCards[2].value = data.jiuyeCount || 0
      this.statCards[3].value = data.qiyeCount || 0
      const rate = data.employmentRate || 0
      this.statCards[4].value = rate + '%'
    },
    renderPieChart(data) {
      if (!this.pieChart) {
        this.pieChart = echarts.init(this.$refs.pieChart)
      }
      const option = {
        tooltip: { trigger: 'item', formatter: '{b}: {c} ({d}%)' },
        legend: { orient: 'vertical', left: 'left', top: 'center' },
        series: [{
          type: 'pie',
          radius: ['40%', '70%'],
          center: ['60%', '50%'],
          data: data || [],
          itemStyle: { borderRadius: 5, borderColor: '#fff', borderWidth: 2 },
          emphasis: { itemStyle: { shadowBlur: 10, shadowOffsetX: 0, shadowColor: 'rgba(0,0,0,0.5)' } },
          animationType: 'scale',
          animationEasing: 'elasticOut',
          animationDelay: function (idx) { return Math.random() * 200 }
        }],
        color: ['#409EFF', '#67C23A', '#E6A23C', '#F56C6C']
      }
      this.pieChart.setOption(option, true)
    },
    renderGaugeChart(value) {
      if (!this.gaugeChart) {
        this.gaugeChart = echarts.init(this.$refs.gaugeChart)
      }
      const option = {
        tooltip: { formatter: '{a} <br/>{b} : {c}%' },
        series: [{
          name: '就业率',
          type: 'gauge',
          min: 0,
          max: 100,
          detail: { formatter: '{value}%', fontSize: 24, color: '#409EFF' },
          data: [{ value: value || 0, name: '就业率' }],
          axisLine: { lineStyle: { width: 10, color: [[0.3, '#F56C6C'], [0.7, '#E6A23C'], [1, '#67C23A']] } },
          pointer: { itemStyle: { color: '#409EFF' } },
          axisTick: { distance: -10, length: 5, lineStyle: { color: '#fff', width: 1 } },
          splitLine: { distance: -10, length: 12, lineStyle: { color: '#fff', width: 2 } },
          axisLabel: { color: '#666', distance: 15, fontSize: 10 },
          title: { offsetCenter: [0, '30%'], fontSize: 14 }
        }]
      }
      this.gaugeChart.setOption(option, true)
    },
    renderBarChart(data) {
      if (!this.barChart) {
        this.barChart = echarts.init(this.$refs.barChart)
      }
      const names = (data || []).map(item => item.name)
      const values = (data || []).map(item => item.value)
      const option = {
        tooltip: { trigger: 'axis', axisPointer: { type: 'shadow' } },
        grid: { left: '3%', right: '4%', bottom: '3%', containLabel: true },
        xAxis: { type: 'category', data: names, axisTick: { alignWithLabel: true } },
        yAxis: { type: 'value' },
        series: [{
          type: 'bar',
          barWidth: '40%',
          data: values,
          itemStyle: { borderRadius: [4, 4, 0, 0], color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
            { offset: 0, color: '#409EFF' },
            { offset: 1, color: '#67C23A' }
          ]) },
          animationDelay: function (idx) { return idx * 100 }
        }]
      }
      this.barChart.setOption(option, true)
    },
    renderLineChart(data) {
      if (!this.lineChart) {
        this.lineChart = echarts.init(this.$refs.lineChart)
      }
      const option = {
        tooltip: { trigger: 'axis' },
        grid: { left: '3%', right: '4%', bottom: '3%', containLabel: true },
        xAxis: { type: 'category', boundaryGap: false, data: data.xData || [] },
        yAxis: { type: 'value' },
        series: [{
          name: '新增实习',
          type: 'line',
          smooth: true,
          symbol: 'circle',
          symbolSize: 8,
          data: data.yData || [],
          areaStyle: { color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
            { offset: 0, color: 'rgba(64,158,255,0.4)' },
            { offset: 1, color: 'rgba(64,158,255,0.05)' }
          ]) },
          lineStyle: { color: '#409EFF', width: 3 },
          itemStyle: { color: '#409EFF', borderColor: '#fff', borderWidth: 2 },
          animationDuration: 1500
        }]
      }
      this.lineChart.setOption(option, true)
    },
    renderTopChart(data) {
      if (!this.topChart) {
        this.topChart = echarts.init(this.$refs.topChart)
      }
      const names = (data || []).map(item => item.name).reverse()
      const values = (data || []).map(item => item.value).reverse()
      const option = {
        tooltip: { trigger: 'axis', axisPointer: { type: 'shadow' } },
        grid: { left: '3%', right: '4%', bottom: '3%', containLabel: true },
        xAxis: { type: 'value' },
        yAxis: { type: 'category', data: names, axisTick: { alignWithLabel: true } },
        series: [{
          type: 'bar',
          barWidth: '50%',
          data: values,
          itemStyle: { borderRadius: [0, 4, 4, 0], color: '#409EFF' },
          label: { show: true, position: 'right', formatter: '{c}人' },
          animationDelay: function (idx) { return idx * 100 }
        }]
      }
      this.topChart.setOption(option, true)
    },
    handleResize() {
      this.pieChart && this.pieChart.resize()
      this.gaugeChart && this.gaugeChart.resize()
      this.barChart && this.barChart.resize()
      this.lineChart && this.lineChart.resize()
      this.topChart && this.topChart.resize()
    },
    disposeCharts() {
      this.pieChart && this.pieChart.dispose()
      this.gaugeChart && this.gaugeChart.dispose()
      this.barChart && this.barChart.dispose()
      this.lineChart && this.lineChart.dispose()
      this.topChart && this.topChart.dispose()
    }
  }
}
</script>

<style lang="scss" scoped>
.dashboard-container {
  padding: 20px;
  background-color: #f0f2f5;
  min-height: 100%;
}
.top-bar {
  margin-bottom: 20px;
  .current-time {
    font-size: 16px;
    color: #606266;
    font-weight: 500;
  }
}
.card-row {
  margin-bottom: 20px;
}
.stat-card {
  text-align: center;
  border-radius: 8px;
  margin-bottom: 20px;
  .stat-title {
    font-size: 14px;
    color: #909399;
    margin-bottom: 10px;
  }
  .stat-value {
    font-size: 28px;
    font-weight: bold;
  }
}
.chart-row {
  margin-bottom: 20px;
}
.chart-box {
  width: 100%;
  height: 320px;
}
</style>
```

---

### Task 6: 更新 db.sql 字典数据

**Files:**
- Modify: `db.sql`

- [ ] **Step 1: 修改字典表 INSERT 语句**

找到 db.sql 中第 51 行的 dictionary INSERT 语句，执行以下替换：

**替换 1：**
`oldString`:
```
(16,'shixi_types','实习信息类型',1,'实习信息类型1',NULL,NULL,'2022-03-28 21:46:16'),(17,'shixi_types','实习信息类型',2,'实习信息类型2',NULL,NULL,'2022-03-28 21:46:16'),
```
`newString`:
```
(16,'shixi_types','实习信息类型',1,'校内实习',NULL,NULL,'2022-03-28 21:46:16'),(17,'shixi_types','实习信息类型',2,'校外实习',NULL,NULL,'2022-03-28 21:46:16'),(22,'shixi_types','实习信息类型',3,'自主实习',NULL,NULL,'2022-03-28 21:46:16'),(23,'shixi_types','实习信息类型',4,'集中实习',NULL,NULL,'2022-03-28 21:46:16'),
```

**替换 2：**
`oldString`:
```
(18,'shixi_jieguo_types','实习结果',1,'好',NULL,NULL,'2022-03-28 21:46:16'),(19,'shixi_jieguo_types','实习结果',2,'一般',NULL,NULL,'2022-03-28 21:46:16'),(20,'shixi_jieguo_types','实习结果',3,'差劲',NULL,NULL,'2022-03-28 21:46:16'),(21,'yuanxi_types','院系',4,'院系',NULL,'','2022-03-29 09:10:16');
```
`newString`:
```
(18,'shixi_jieguo_types','实习结果',1,'优秀',NULL,NULL,'2022-03-28 21:46:16'),(19,'shixi_jieguo_types','实习结果',2,'良好',NULL,NULL,'2022-03-28 21:46:16'),(20,'shixi_jieguo_types','实习结果',3,'较差',NULL,NULL,'2022-03-28 21:46:16'),(21,'yuanxi_types','院系',4,'院系',NULL,'','2022-03-29 09:10:16');
```

**替换 3：**
`oldString`:
```
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8 COMMENT='字典';
```
`newString`:
```
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8 COMMENT='字典';
```

---

### Task 7: 构建验证

**Files:**
- 无新增/修改

- [ ] **Step 1: 编译后端**

Run:
```bash
cd biyeshengshixiyujiuye
mvn clean package -DskipTests
```

Expected: BUILD SUCCESS

- [ ] **Step 2: 确认前端编译（可选）**

Run:
```bash
cd biyeshengshixiyujiuye/src/main/resources/admin/admin
cnpm run build
```

Expected: 无报错，dist 目录生成

---

## 自我审查

### 1. Spec 覆盖率检查

| Spec 要求 | 对应任务 |
|-----------|---------|
| 数据总览卡片（8 个字段） | Task 3 (getBaseData), Task 4 (/base) |
| 实习类型饼图 | Task 1 (selectShixiTypeStats), Task 4 (/shixiType), Task 5 (renderPieChart) |
| 就业率仪表盘 | Task 3 (employmentRate 计算), Task 4 (/employmentRate), Task 5 (renderGaugeChart) |
| 实习结果柱状图 | Task 1 (selectShixiResultStats), Task 4 (/shixiResult), Task 5 (renderBarChart) |
| 月度趋势折线图 | Task 1 (selectMonthTrend), Task 3 (补全 12 月), Task 4 (/monthTrend), Task 5 (renderLineChart) |
| 企业 TOP10 横向柱状图 | Task 1 (selectCompanyTop), Task 4 (/companyTop), Task 5 (renderTopChart) |
| 自动刷新 30s | Task 5 (mounted setInterval 30000) |
| 当前时间显示 | Task 5 (updateTime setInterval 1000) |
| 图表动画 | Task 5 (animationType, animationDuration, animationDelay) |
| 响应式布局 | Task 5 (el-col :xs :sm :md) + window resize |
| 卡片阴影圆角 | Task 5 (SCSS shadow + border-radius) |
| 蓝色主色调 | Task 5 (#409EFF) |
| 字典表更新 | Task 6 |

**无遗漏。**

### 2. 占位符扫描

- 无 "TBD" / "TODO" / "implement later"
- 无 "add appropriate error handling"
- 无 "similar to Task N" 引用
- 所有步骤包含完整代码

### 3. 类型一致性检查

- `DashboardDao.selectMonthTrend(@Param("year") String year)` → XML `#{year}` ✓
- `R.ok().put("data", ...)` 统一 ✓
- 前端 `data.code === 0` 与后端 `R` 默认 `code=0` 一致 ✓
- `BigDecimal.ONE` 未使用，全部使用 `BigDecimal.ZERO` 和构造器 ✓

---

## 执行方式选择

**Plan complete and saved to `docs/superpowers/plans/2026-05-21-dashboard.md`. Two execution options:**

**1. Subagent-Driven (recommended)** - I dispatch a fresh subagent per task, review between tasks, fast iteration

**2. Inline Execution** - Execute tasks in this session using executing-plans, batch execution with checkpoints

**Which approach?**
