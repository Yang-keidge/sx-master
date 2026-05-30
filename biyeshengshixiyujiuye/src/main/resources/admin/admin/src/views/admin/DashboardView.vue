<template>
  <main class="dashboard-page">
    <section class="welcome-row">
      <div>
        <h1>欢迎回来，管理员</h1>
        <p>{{ todayText }}</p>
      </div>
      <span v-if="loadError" class="load-warning">{{ loadError }}</span>
    </section>

    <section class="quick-actions" aria-label="快捷入口">
      <RouterLink
        v-for="action in quickActions"
        :key="action.routeName"
        class="quick-action"
        :class="[`tone-${action.tone}`, { 'is-hidden': action.hidden }]"
        :to="{ name: action.routeName }"
        :aria-hidden="action.hidden ? 'true' : null"
        :tabindex="action.hidden ? -1 : undefined"
      >
        <span class="quick-icon">
          <component :is="action.icon" :size="22" stroke-width="2.2" />
        </span>
        <strong>{{ action.label }}</strong>
      </RouterLink>
    </section>

    <section class="stat-grid" aria-label="核心指标">
      <article v-for="item in dashboardStatCards" :key="item.label" class="stat-card">
        <div>
          <p>{{ item.label }}</p>
          <strong>{{ item.value }}</strong>
          <span class="stat-change" :class="item.direction">
            较上月
            <component :is="item.changeIcon" :size="13" stroke-width="2.4" />
            {{ item.change }}
          </span>
        </div>
        <span class="stat-icon" :class="`tone-${item.tone}`">
          <component :is="item.icon" :size="30" stroke-width="2.25" />
        </span>
      </article>
    </section>

    <section class="charts-grid">
      <article class="panel-card donut-panel">
        <h2>实习类型分布</h2>
        <div class="donut-layout">
          <div class="donut-chart" :style="donutStyle(typeDistribution)">
            <div class="donut-center">
              <span>总计</span>
              <strong>{{ typeTotal }}</strong>
            </div>
          </div>
          <ul class="legend-list">
            <li v-for="item in typeDistribution" :key="item.label">
              <span :style="{ background: item.color }"></span>
              <strong>{{ item.label }}</strong>
              <em>{{ item.value }}</em>
            </li>
          </ul>
        </div>
      </article>

      <article class="panel-card donut-panel">
        <h2>实习结果分布</h2>
        <div class="donut-layout">
          <div class="donut-chart" :style="donutStyle(resultDistribution)">
            <div class="donut-center">
              <span>总计</span>
              <strong>{{ resultTotal }}</strong>
            </div>
          </div>
          <ul class="legend-list">
            <li v-for="item in resultDistribution" :key="item.label">
              <span :style="{ background: item.color }"></span>
              <strong>{{ item.label }}</strong>
              <em>{{ item.value }}</em>
            </li>
          </ul>
        </div>
      </article>

      <article class="panel-card trend-panel">
        <h2>实习趋势（{{ trendYear }}年）</h2>
        <div class="trend-chart">
          <div class="y-axis">
            <span v-for="label in trendAxisLabels" :key="label">{{ label }}</span>
          </div>
          <div class="trend-plot">
            <svg
              viewBox="0 0 520 220"
              preserveAspectRatio="none"
              role="img"
              aria-label="年度实习趋势折线图"
            >
              <defs>
                <linearGradient id="trendFill" x1="0" x2="0" y1="0" y2="1">
                  <stop offset="0%" stop-color="#3f5fff" stop-opacity="0.22" />
                  <stop offset="100%" stop-color="#3f5fff" stop-opacity="0" />
                </linearGradient>
              </defs>
              <path
                class="trend-area"
                :d="trendAreaPath"
              />
              <path
                class="trend-line"
                :d="trendLinePath"
              />
            </svg>
          </div>
          <div class="x-axis">
            <span v-for="month in trendMonths" :key="month">{{ month }}</span>
          </div>
        </div>
      </article>
    </section>

    <section class="tables-grid">
      <article class="panel-card records-card">
        <header>
          <h2>最新实习记录</h2>
          <RouterLink :to="{ name: 'admin.internships' }">查看更多</RouterLink>
        </header>
        <div class="table-wrap">
          <table>
            <colgroup>
              <col class="col-name" />
              <col class="col-number" />
              <col class="col-company" />
              <col class="col-position" />
              <col class="col-date" />
              <col class="col-status" />
            </colgroup>
            <thead>
              <tr>
                <th>学生姓名</th>
                <th>学号</th>
                <th>企业名称</th>
                <th>实习岗位</th>
                <th>开始日期</th>
                <th>状态</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="record in dashboardInternshipRecords" :key="record.number + record.startDate">
                <td><UserCell :name="record.name" :photo="record.photo" /></td>
                <td>{{ record.number }}</td>
                <td>{{ record.company }}</td>
                <td>{{ record.position }}</td>
                <td>{{ record.startDate }}</td>
                <td><span class="status-pill">{{ record.status }}</span></td>
              </tr>
              <tr v-if="!dashboardInternshipRecords.length">
                <td class="empty-row" colspan="6">暂无实习记录</td>
              </tr>
            </tbody>
          </table>
        </div>
      </article>

      <article class="panel-card records-card">
        <header>
          <h2>最新招聘岗位</h2>
          <RouterLink :to="{ name: 'admin.recruitmentJobs' }">查看更多</RouterLink>
        </header>
        <div class="table-wrap">
          <table>
            <colgroup>
              <col class="col-company-wide" />
              <col class="col-position" />
              <col class="col-type" />
              <col class="col-salary" />
              <col class="col-date" />
            </colgroup>
            <thead>
              <tr>
                <th>企业名称</th>
                <th>岗位名称</th>
                <th>岗位类型</th>
                <th>薪资范围</th>
                <th>发布日期</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="record in latestRecruitmentJobs" :key="record.company + record.position + record.publishDate">
                <td>{{ record.company }}</td>
                <td>{{ record.position }}</td>
                <td>{{ record.type }}</td>
                <td>{{ record.salary }}</td>
                <td>{{ record.publishDate }}</td>
              </tr>
              <tr v-if="!latestRecruitmentJobs.length">
                <td class="empty-row" colspan="5">暂无招聘岗位</td>
              </tr>
            </tbody>
          </table>
        </div>
      </article>
    </section>
  </main>
</template>

<script setup>
import { computed, defineComponent, h, onMounted, ref } from 'vue'
import { RouterLink } from 'vue-router'
import {
  ArrowDown,
  ArrowUp,
  BriefcaseBusiness,
  Building2,
  GraduationCap,
  UserRound
} from 'lucide-vue-next'
import { quickActions } from '../../data/adminNavigation'
import { fetchDashboardSummary } from '../../services/dashboard'

const summary = ref(null)
const loadError = ref('')
const defaultChartMonths = ['1月', '2月', '3月', '4月', '5月', '6月', '7月', '8月', '9月', '10月', '11月', '12月']
const distributionColors = ['#3f5fff', '#7185f6', '#58d2ae', '#b8dce9', '#b8c1d3']
const metricCards = [
  { label: '学生总数', icon: UserRound, tone: 'blue' },
  { label: '企业总数', icon: Building2, tone: 'green' },
  { label: '教师总数', icon: GraduationCap, tone: 'purple' },
  { label: '实习学生数', icon: BriefcaseBusiness, tone: 'sky' },
  { label: '招聘岗位数', icon: BriefcaseBusiness, tone: 'orange' },
  { label: '应聘学生数', icon: UserRound, tone: 'blue' }
]

onMounted(async () => {
  try {
    summary.value = await fetchDashboardSummary()
    loadError.value = ''
  } catch {
    summary.value = null
    loadError.value = '首页数据加载失败，请检查后端服务'
  }
})

const UserCell = defineComponent({
  props: {
    name: {
      type: String,
      required: true
    },
    photo: {
      type: String,
      default: ''
    }
  },
  setup(props) {
    const avatarFailed = ref(false)
    const avatarSrc = computed(() => normalizePhotoUrl(props.photo))

    return () =>
      h('span', { class: 'user-cell' }, [
        avatarSrc.value && !avatarFailed.value
          ? h('img', {
              class: 'mini-avatar',
              src: avatarSrc.value,
              alt: `${props.name || '学生'}头像`,
              loading: 'lazy',
              onError: () => {
                avatarFailed.value = true
              }
            })
          : h('span', { class: 'mini-avatar mini-avatar-fallback' }, props.name.slice(0, 1) || '?'),
        h('span', { class: 'student-name' }, props.name)
      ])
  }
})

const todayText = computed(() => {
  const now = new Date()
  const weekMap = ['星期日', '星期一', '星期二', '星期三', '星期四', '星期五', '星期六']
  return `今天是 ${now.getFullYear()}年${now.getMonth() + 1}月${now.getDate()}日，${weekMap[now.getDay()]}`
})

const dashboardStatCards = computed(() => {
  const base = summary.value?.base || {}

  return [
    makeStatCard(0, base.studentCount, base.studentMonthChange),
    makeStatCard(1, base.qiyeCount, base.qiyeMonthChange),
    makeStatCard(2, base.laoshiCount, base.laoshiMonthChange),
    makeStatCard(3, base.shixiCount, base.shixiMonthChange),
    makeStatCard(4, base.zhaopinCount, base.zhaopinMonthChange),
    makeStatCard(5, base.yingpinCount, base.yingpinMonthChange)
  ]
})

const typeDistribution = computed(() =>
  formatDistribution(summary.value?.shixiType)
)

const resultDistribution = computed(() =>
  formatDistribution(summary.value?.shixiResult)
)

const trendMonths = computed(() => summary.value?.monthTrend?.xData || defaultChartMonths)
const trendYear = computed(() => summary.value?.monthTrend?.year || new Date().getFullYear())
const typeTotal = computed(() => formatNumber(distributionTotal(summary.value?.shixiType)))
const resultTotal = computed(() => formatNumber(distributionTotal(summary.value?.shixiResult)))

const trendValues = computed(() => {
  const values = summary.value?.monthTrend?.yData
  if (Array.isArray(values) && values.length) {
    return values.map((value) => Number(value) || 0)
  }

  return defaultChartMonths.map(() => 0)
})

const trendMax = computed(() => {
  const max = Math.max(...trendValues.value, 1)
  return Math.max(10, Math.ceil(max / 10) * 10)
})

const trendAxisLabels = computed(() => {
  const max = trendMax.value
  return [max, Math.round(max * 0.75), Math.round(max * 0.5), Math.round(max * 0.25), 0]
})

const trendLinePath = computed(() => buildTrendPath(trendValues.value, trendMax.value).line)
const trendAreaPath = computed(() => buildTrendPath(trendValues.value, trendMax.value).area)

const dashboardInternshipRecords = computed(() => {
  if (!summary.value) {
    return []
  }

  return (summary.value.latestShixi || []).map((item) => ({
    name: item.studentName || '-',
    number: item.studentNumber || '-',
    photo: item.studentPhoto || '',
    company: item.companyName || '-',
    position: item.positionName || '-',
    startDate: item.startDate || '-',
    status: item.status || '-'
  }))
})

const latestRecruitmentJobs = computed(() => {
  if (!summary.value) {
    return []
  }

  return (summary.value.latestRecruitmentJobs || []).map((item) => ({
    company: item.companyName || '-',
    position: item.positionName || '-',
    type: item.positionType || '-',
    salary: item.salaryRange || '-',
    publishDate: item.publishDate || '-'
  }))
})

function normalizePhotoUrl(photo) {
  const value = String(photo || '').trim()
  if (!value) return ''
  if (/^(data:|blob:)/i.test(value)) return value
  if (value.startsWith('/api/')) return value

  const uploadIndex = value.indexOf('/upload/')
  if (uploadIndex >= 0) {
    return `/api/upload/${value.slice(uploadIndex + '/upload/'.length)}`
  }

  if (value.startsWith('/upload/')) {
    return `/api${value}`
  }

  if (/^https?:\/\//i.test(value)) {
    return value
  }

  if (value.startsWith('/')) {
    return value
  }

  return `/api/upload/${value}`
}

function makeStatCard(index, value, change, suffix = '') {
  const source = metricCards[index]
  const numericChange = Number(change) || 0

  return {
    ...source,
    value: suffix ? `${formatDecimal(value)}${suffix}` : formatNumber(value),
    change: formatSigned(numericChange, suffix),
    direction: numericChange < 0 ? 'down danger' : 'up',
    changeIcon: numericChange < 0 ? ArrowDown : ArrowUp
  }
}

function formatDistribution(list) {
  if (!Array.isArray(list) || !list.length) return []

  const total = list.reduce((sum, item) => sum + (Number(item.value) || 0), 0)
  return list.map((item, index) => ({
    label: item.name || '未分类',
    value: total > 0 ? `${(((Number(item.value) || 0) / total) * 100).toFixed(1)}%` : '0.0%',
    color: distributionColors[index % distributionColors.length]
  }))
}

function distributionTotal(list) {
  if (!Array.isArray(list)) {
    return 0
  }

  return list.reduce((sum, item) => sum + (Number(item.value) || 0), 0)
}

function donutStyle(items) {
  let cursor = 0
  const total = items.reduce((sum, item) => sum + Number.parseFloat(item.value), 0)
  if (total <= 0) {
    return {
      background: 'conic-gradient(#e6ebf3 0 100%)'
    }
  }

  const segments = items.map((item) => {
    const size = Number.parseFloat(item.value)
    const start = cursor
    cursor += size
    return `${item.color} ${start}% ${cursor}%`
  })

  return {
    background: `conic-gradient(${segments.join(', ')})`
  }
}

function buildTrendPath(values, max) {
  const width = 520
  const height = 220
  const top = 15
  const bottom = 30
  const left = 12
  const right = 12
  const plotHeight = height - top - bottom
  const safeValues = values.length ? values : [0]
  const step = safeValues.length > 1 ? (width - left - right) / (safeValues.length - 1) : 0
  const points = safeValues.map((value, index) => {
    const x = left + step * index
    const y = top + ((max - value) / max) * plotHeight
    return [Number(x.toFixed(2)), Number(y.toFixed(2))]
  })

  const line = points.map(([x, y], index) => `${index === 0 ? 'M' : 'L'}${x} ${y}`).join(' ')
  const first = points[0]
  const last = points[points.length - 1]
  const area = `${line} L${last[0]} ${height} L${first[0]} ${height} Z`

  return { line, area }
}

function formatNumber(value) {
  return Number(value || 0).toLocaleString('zh-CN')
}

function formatDecimal(value) {
  return Number(value || 0).toFixed(1)
}

function formatSigned(value, suffix = '') {
  const sign = value >= 0 ? '+' : ''
  const formatted = suffix ? Number(value).toFixed(1) : Number(value).toLocaleString('zh-CN')
  return `${sign}${formatted}${suffix}`
}
</script>

<style scoped>
.dashboard-page {
  min-width: 1026px;
  padding: 0 40px 54px;
}

.welcome-row {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  margin-bottom: 26px;
}

.welcome-row h1 {
  margin: 0 0 12px;
  color: #17233d;
  font-size: 27px;
  font-weight: 900;
  line-height: 1.2;
  letter-spacing: 0;
}

.welcome-row p {
  margin: 0;
  color: #66738b;
  font-size: 15px;
  font-weight: 800;
}

.load-warning {
  align-self: center;
  padding: 7px 12px;
  border-radius: 999px;
  background: #fff7e8;
  color: #b66a00;
  font-size: 13px;
  font-weight: 800;
}

.quick-actions {
  display: grid;
  grid-template-columns: repeat(6, minmax(126px, 1fr));
  gap: 20px;
  margin-bottom: 25px;
}

.quick-action {
  display: flex;
  align-items: center;
  gap: 14px;
  min-height: 50px;
  padding: 0 18px;
  border: 1px solid #dbe3ef;
  border-radius: 8px;
  background: #fff;
  color: #1d2940;
  text-decoration: none;
  box-shadow: 0 8px 20px rgba(46, 58, 92, 0.04);
  transition:
    border-color 0.16s ease,
    box-shadow 0.16s ease,
    transform 0.16s ease;
}

.quick-action:hover {
  transform: translateY(-1px);
  border-color: #c9d6ff;
  box-shadow: 0 12px 24px rgba(46, 58, 92, 0.08);
}

.quick-action.is-hidden {
  visibility: hidden;
  pointer-events: none;
}

.quick-action strong {
  font-size: 15px;
  font-weight: 900;
  white-space: nowrap;
}

.quick-icon,
.stat-icon {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  flex: 0 0 auto;
}

.quick-icon {
  width: 32px;
  height: 32px;
  border-radius: 8px;
}

.tone-blue .quick-icon,
.stat-icon.tone-blue {
  background: #edf3ff;
  color: #3f5fff;
}

.tone-indigo .quick-icon,
.stat-icon.tone-indigo {
  background: #eef2ff;
  color: #5270f2;
}

.tone-green .quick-icon,
.stat-icon.tone-green {
  background: #eaf8ef;
  color: #36b977;
}

.tone-orange .quick-icon,
.stat-icon.tone-orange {
  background: #fff1e7;
  color: #ff7a2d;
}

.tone-sky .quick-icon,
.stat-icon.tone-sky {
  background: #ebf5ff;
  color: #358cff;
}

.stat-icon.tone-purple {
  background: #f3eaff;
  color: #8a52e9;
}

.stat-grid {
  display: grid;
  grid-template-columns: repeat(6, minmax(150px, 1fr));
  gap: 20px;
  margin-bottom: 25px;
}

.stat-card {
  display: flex;
  align-items: center;
  justify-content: space-between;
  min-height: 134px;
  padding: 24px 22px;
  border: 1px solid #e0e7f1;
  border-radius: 8px;
  background: #fff;
  box-shadow: 0 12px 26px rgba(46, 58, 92, 0.06);
}

.stat-card p {
  margin: 0 0 12px;
  color: #66738b;
  font-size: 14px;
  font-weight: 800;
}

.stat-card strong {
  display: block;
  margin-bottom: 13px;
  color: #17233d;
  font-size: 25px;
  font-weight: 900;
  line-height: 1;
}

.stat-change {
  display: inline-flex;
  align-items: center;
  gap: 7px;
  color: #12a052;
  font-size: 13px;
  font-weight: 800;
  white-space: nowrap;
}

.stat-change.danger {
  color: #ff4f32;
}

.stat-icon {
  width: 58px;
  height: 58px;
  border-radius: 50%;
}

.charts-grid {
  display: grid;
  grid-template-columns: 1fr 1fr 1.24fr;
  align-items: start;
  gap: 20px;
  margin-bottom: 25px;
}

.panel-card {
  border: 1px solid #e0e7f1;
  border-radius: 8px;
  background: #fff;
  box-shadow: 0 12px 26px rgba(46, 58, 92, 0.06);
}

.panel-card h2 {
  margin: 0;
  color: #17233d;
  font-size: 16px;
  font-weight: 900;
}

.donut-panel {
  height: 252px;
  padding: 24px 22px;
}

.donut-layout {
  display: grid;
  grid-template-columns: minmax(140px, 180px) minmax(130px, 1fr);
  gap: 24px;
  align-items: center;
  margin-top: 21px;
}

.donut-chart {
  position: relative;
  width: min(172px, 100%);
  aspect-ratio: 1;
  border-radius: 50%;
}

.donut-chart::before {
  position: absolute;
  inset: 29px;
  border-radius: 50%;
  background: #fff;
  content: "";
}

.donut-center {
  position: absolute;
  inset: 0;
  display: grid;
  place-content: center;
  text-align: center;
}

.donut-center span {
  color: #69758c;
  font-size: 13px;
  font-weight: 800;
}

.donut-center strong {
  margin-top: 8px;
  color: #17233d;
  font-size: 20px;
  font-weight: 900;
}

.legend-list {
  display: grid;
  gap: 14px;
  margin: 0;
  padding: 0;
  list-style: none;
}

.legend-list li {
  display: grid;
  grid-template-columns: 8px minmax(64px, 1fr) auto;
  align-items: center;
  gap: 13px;
  color: #526078;
  font-size: 13px;
  font-weight: 800;
}

.legend-list li span {
  width: 7px;
  height: 7px;
  border-radius: 50%;
}

.legend-list li strong {
  font-weight: 800;
}

.legend-list li em {
  color: #2f3b52;
  font-style: normal;
  font-weight: 900;
}

.trend-panel {
  height: 252px;
  padding: 24px 22px 18px;
}

.trend-chart {
  display: grid;
  grid-template-columns: 36px 1fr;
  grid-template-rows: 174px auto;
  column-gap: 8px;
  margin-top: 14px;
}

.trend-plot {
  position: relative;
  grid-row: 1;
  grid-column: 2;
  width: 100%;
  height: 174px;
  background: repeating-linear-gradient(
    to bottom,
    transparent 0,
    transparent 42px,
    #e6ebf3 43px,
    transparent 44px
  );
  overflow: hidden;
}

.trend-plot svg {
  position: absolute;
  inset: 0;
  width: 100%;
  height: 100%;
}

.trend-area {
  fill: url("#trendFill");
}

.trend-line {
  fill: none;
  stroke: #3f5fff;
  stroke-linecap: round;
  stroke-linejoin: round;
  stroke-width: 3;
}

.y-axis {
  display: grid;
  grid-row: 1;
  grid-column: 1;
  height: 174px;
  color: #56637b;
  font-size: 12px;
  font-weight: 800;
}

.x-axis {
  display: grid;
  grid-column: 2;
  grid-template-columns: repeat(12, 1fr);
  gap: 4px;
  margin-top: 4px;
  color: #59667d;
  font-size: 12px;
  font-weight: 800;
  text-align: center;
}

.tables-grid {
  display: grid;
  grid-template-columns: 1fr 1.03fr;
  gap: 20px;
}

.records-card {
  min-width: 0;
  padding: 22px 18px 18px;
}

.records-card header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 18px;
  margin-bottom: 17px;
}

.records-card header a {
  color: #66738b;
  font-size: 13px;
  font-weight: 800;
  text-decoration: none;
}

.records-card header a:hover {
  color: #3657ff;
}

.table-wrap {
  overflow-x: auto;
}

table {
  width: 100%;
  min-width: 0;
  border-collapse: collapse;
  border: 1px solid #e4e9f1;
  border-radius: 8px;
  overflow: hidden;
  table-layout: fixed;
  font-size: 13px;
}

.col-name {
  width: 13%;
}

.col-number {
  width: 17%;
}

.col-company {
  width: 24%;
}

.col-company-wide {
  width: 30%;
}

.col-position {
  width: 22%;
}

.col-type {
  width: 16%;
}

.col-salary {
  width: 16%;
}

.col-date {
  width: 16%;
}

.col-status {
  width: 10%;
}

th,
td {
  height: 41px;
  padding: 0 12px;
  border-bottom: 1px solid #e8edf5;
  color: #3e4a61;
  font-weight: 800;
  overflow: hidden;
  text-align: left;
  text-overflow: ellipsis;
  white-space: nowrap;
}

th {
  background: #fafbfd;
  color: #6d7890;
  font-size: 12px;
}

tbody tr:last-child td {
  border-bottom: 0;
}

:deep(.user-cell) {
  display: inline-flex;
  align-items: center;
  gap: 9px;
  min-width: 0;
  max-width: 100%;
}

:deep(.mini-avatar) {
  flex: 0 0 auto;
  width: 30px;
  height: 30px;
  border: 1px solid #dfe7f3;
  border-radius: 50%;
  background: #edf3ff;
  object-fit: cover;
}

:deep(.mini-avatar-fallback) {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  color: #3657ff;
  font-size: 12px;
  font-weight: 900;
}

:deep(.student-name) {
  min-width: 0;
  overflow: hidden;
  text-overflow: ellipsis;
}

.status-pill {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  min-width: 48px;
  height: 24px;
  padding: 0 8px;
  border-radius: 999px;
  background: #e8f8ed;
  color: #16944e;
  font-size: 12px;
  font-weight: 900;
}

.empty-row {
  height: 94px;
  color: #8b97aa;
  text-align: center;
}

@media (max-width: 1420px) {
  .stat-grid {
    grid-template-columns: repeat(3, 1fr);
  }

  .charts-grid,
  .tables-grid {
    grid-template-columns: 1fr;
  }
}

@media (max-width: 1180px) {
  .quick-actions {
    grid-template-columns: repeat(3, 1fr);
  }
}

</style>
