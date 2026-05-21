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
