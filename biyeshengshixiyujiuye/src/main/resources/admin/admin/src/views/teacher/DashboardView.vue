<template>
  <main class="teacher-dashboard">
    <section class="welcome-row">
      <div>
        <h1>欢迎回来，{{ teacherName }}</h1>
        <p>{{ teacherMeta }}</p>
        <p>{{ todayText }}</p>
      </div>
      <span v-if="loadError" class="load-warning">{{ loadError }}</span>
    </section>

    <section class="stat-grid" aria-label="教师端核心指标">
      <article v-for="item in statCards" :key="item.label" class="stat-card">
        <div>
          <p>{{ item.label }}</p>
          <strong>{{ item.value }}</strong>
          <span class="stat-change">
            较上月
            <ArrowUp :size="13" stroke-width="2.4" />
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
        <h2>学生实习状态分布</h2>
        <div class="donut-layout">
          <div class="donut-chart" :style="donutStyle(internshipStatusDistribution)">
            <div class="donut-center">
              <span>总数</span>
              <strong>{{ students.length }}</strong>
            </div>
          </div>
          <ul class="legend-list">
            <li v-for="item in internshipStatusDistribution" :key="item.label">
              <span :style="{ background: item.color }"></span>
              <strong>{{ item.label }}</strong>
              <em>{{ item.value }} ({{ item.percent }})</em>
            </li>
          </ul>
        </div>
      </article>

      <article class="panel-card donut-panel">
        <h2>学生实习类型分布</h2>
        <div class="donut-layout">
          <div class="donut-chart" :style="donutStyle(internshipTypeDistribution)">
            <div class="donut-center">
              <span>总数</span>
              <strong>{{ internships.length }}</strong>
            </div>
          </div>
          <ul class="legend-list">
            <li v-for="item in internshipTypeDistribution" :key="item.label">
              <span :style="{ background: item.color }"></span>
              <strong>{{ item.label }}</strong>
              <em>{{ item.value }} ({{ item.percent }})</em>
            </li>
          </ul>
        </div>
      </article>

      <article class="panel-card trend-panel">
        <h2>学生实习趋势（近12个月）</h2>
        <div class="trend-chart">
          <svg viewBox="0 0 640 210" role="img" aria-label="学生实习趋势折线图">
            <defs>
              <linearGradient id="teacherTrendFill" x1="0" x2="0" y1="0" y2="1">
                <stop offset="0%" stop-color="#4b67ff" stop-opacity="0.2" />
                <stop offset="100%" stop-color="#4b67ff" stop-opacity="0" />
              </linearGradient>
            </defs>
            <g class="grid-lines">
              <line v-for="tick in trendTicks" :key="tick" x1="18" x2="622" :y1="tick" :y2="tick" />
            </g>
            <polygon :points="trendAreaPoints" fill="url(#teacherTrendFill)" />
            <polyline :points="trendLinePoints" fill="none" stroke="#4b67ff" stroke-linecap="round" stroke-width="3" />
          </svg>
          <div class="trend-labels">
            <span v-for="item in trendData" :key="item.label">{{ item.label }}</span>
          </div>
        </div>
      </article>
    </section>

    <section class="bottom-grid">
      <article class="panel-card list-card">
        <header>
          <h2>我的近期公告</h2>
          <RouterLink :to="{ name: 'teacher.announcements' }">查看全部</RouterLink>
        </header>
        <ul v-if="latestAnnouncements.length" class="announcement-list">
          <li v-for="item in latestAnnouncements" :key="item.id">
            <span class="type-tag">{{ announcementTypeLabel(item) }}</span>
            <strong>{{ item.gonggaoName || '-' }}</strong>
            <time>{{ formatDate(item.insertTime || item.createTime) }}</time>
          </li>
        </ul>
        <div v-else class="empty-block">暂无公告</div>
      </article>

      <article class="panel-card list-card">
        <header>
          <h2>最新评论</h2>
        </header>
        <ul v-if="latestComments.length" class="comment-list">
          <li v-for="item in latestComments" :key="item.id">
            <span class="comment-avatar">{{ (item.pinglunrenName || '?').slice(0, 1) }}</span>
            <div>
              <p>
                <strong>{{ item.pinglunrenName || '匿名用户' }}</strong>
                在公告《{{ item.gonggaoName || '未命名公告' }}》下评论
              </p>
              <small>{{ item.gonggaoCommentContent || '-' }}</small>
            </div>
            <time>{{ formatDate(item.createTime || item.updateTime) }}</time>
          </li>
        </ul>
        <div v-else class="empty-block">暂无评论</div>
      </article>
    </section>

    <footer class="page-footer">© 2025 实习信息管理系统 版权所有</footer>
  </main>
</template>

<script setup>
import { computed, onMounted, ref } from 'vue'
import { RouterLink } from 'vue-router'
import { ArrowUp, BriefcaseBusiness, Megaphone, UserRound } from 'lucide-vue-next'
import { useDictionary } from '../../hooks/useDictionary'
import { fetchTeacherDashboardSummary } from '../../services/teacherDashboard'

const palette = ['#3f5fff', '#7185f6', '#58d2ae', '#b8dce9', '#e6eaf7', '#f6a15f']
const summary = ref(null)
const loadError = ref('')
const { ensure, getLabel } = useDictionary()

onMounted(async () => {
  await Promise.all([ensure('gonggao_types'), ensure('zhuanye_types'), ensure('yuanxi_types'), ensure('shixi_types')])
  try {
    summary.value = await fetchTeacherDashboardSummary()
    loadError.value = ''
  } catch {
    summary.value = null
    loadError.value = '教师端数据加载失败，请检查后端服务'
  }
})

const teacher = computed(() => summary.value?.teacher || {})
const students = computed(() => summary.value?.students || [])
const internships = computed(() => summary.value?.internships || [])
const announcements = computed(() => summary.value?.announcements || [])
const comments = computed(() => summary.value?.comments || [])

const teacherName = computed(() => teacher.value.laoshiName || storedUser.value.username || '教师用户')
const teacherMeta = computed(() => {
  const department = teacher.value.yuanxiValue || getLabel('yuanxi_types', teacher.value.yuanxiTypes, '') || '未设置院系'
  const major = teacher.value.zhuanyeValue || getLabel('zhuanye_types', teacher.value.zhuanyeTypes, '') || '未设置专业'
  return `${department} · ${major} · 教师`
})

const storedUser = computed(() => {
  try {
    return JSON.parse(localStorage.getItem('currentUser') || '{}')
  } catch {
    return {}
  }
})

const todayText = computed(() => {
  const now = new Date()
  const weekMap = ['星期日', '星期一', '星期二', '星期三', '星期四', '星期五', '星期六']
  return `今天是 ${now.getFullYear()}年${now.getMonth() + 1}月${now.getDate()}日，${weekMap[now.getDay()]}`
})

const statCards = computed(() => [
  {
    label: '指导学生总数',
    value: summary.value?.totals?.students || 0,
    change: summary.value?.totals?.students || 0,
    icon: UserRound,
    tone: 'blue'
  },
  {
    label: '实习学生数',
    value: summary.value?.totals?.internshipStudents || 0,
    change: summary.value?.totals?.internshipStudents || 0,
    icon: BriefcaseBusiness,
    tone: 'green'
  },
  {
    label: '发布公告数',
    value: summary.value?.totals?.announcements || 0,
    change: summary.value?.totals?.announcements || 0,
    icon: Megaphone,
    tone: 'sky'
  }
])

const internshipsByStudent = computed(() => {
  const map = new Map()
  internships.value.forEach((item) => {
    if (!map.has(item.xueshengId)) map.set(item.xueshengId, [])
    map.get(item.xueshengId).push(item)
  })
  return map
})

const internshipStatusDistribution = computed(() => {
  const counts = {
    未实习: 0,
    进行中: 0,
    已结束: 0
  }
  students.value.forEach((student) => {
    counts[studentInternshipStatus(student)] += 1
  })
  return buildFixedDistribution(counts, ['#3f5fff', '#7185f6', '#58d2ae'])
})

const internshipTypeDistribution = computed(() => {
  const counts = {}
  internships.value.forEach((item) => {
    const label = item.shixiValue || getLabel('shixi_types', item.shixiTypes, '') || '未设置'
    counts[label] = (counts[label] || 0) + 1
  })
  return buildFixedDistribution(counts, ['#3f5fff', '#7185f6', '#58d2ae', '#b8dce9', '#f6a15f'])
})

const trendData = computed(() => {
  const months = buildRecentMonths()
  const counts = months.map((month) => ({
    label: month.label,
    key: month.key,
    value: 0
  }))
  const indexMap = new Map(counts.map((item, index) => [item.key, index]))

  internships.value.forEach((item) => {
    const date = parseDate(item.shixiKaishiTime || item.createTime)
    if (!date) return
    const key = `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}`
    const index = indexMap.get(key)
    if (index !== undefined) counts[index].value += 1
  })

  return counts
})

const trendTicks = [22, 64, 106, 148, 190]
const trendLinePoints = computed(() => buildTrendPoints(trendData.value, false))
const trendAreaPoints = computed(() => buildTrendPoints(trendData.value, true))
const latestAnnouncements = computed(() => [...announcements.value].sort(byBusinessDateDesc).slice(0, 5))
const latestComments = computed(() => [...comments.value].sort(byBusinessDateDesc).slice(0, 4))

function buildFixedDistribution(counts, colors) {
  const total = Object.values(counts).reduce((sum, value) => sum + value, 0) || 1
  return Object.entries(counts).map(([label, value], index) => ({
    label,
    value,
    percent: formatPercent(value, total),
    color: colors[index] || palette[index % palette.length]
  }))
}

function studentInternshipStatus(student) {
  const records = internshipsByStudent.value.get(student.id) || []
  if (!records.length) return '未实习'
  if (records.some(isActiveInternship)) return '进行中'
  return '已结束'
}

function isActiveInternship(item) {
  const today = startOfToday()
  const start = parseDate(item.shixiKaishiTime)
  const end = parseDate(item.shixiJieshuTime)
  if (start && start > today) return false
  if (end && end < today) return false
  return true
}

function buildRecentMonths() {
  const now = new Date()
  const months = []
  for (let index = 11; index >= 0; index -= 1) {
    const date = new Date(now.getFullYear(), now.getMonth() - index, 1)
    months.push({
      key: `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}`,
      label: `${date.getMonth() + 1}月`
    })
  }
  return months
}

function buildTrendPoints(items, withArea) {
  const max = Math.max(1, ...items.map((item) => item.value))
  const points = items.map((item, index) => {
    const x = 30 + index * (580 / Math.max(1, items.length - 1))
    const y = 188 - (item.value / max) * 150
    return `${x.toFixed(1)},${y.toFixed(1)}`
  })

  if (!withArea) return points.join(' ')
  return [`30,190`, ...points, `610,190`].join(' ')
}

function donutStyle(items) {
  let cursor = 0
  const total = items.reduce((sum, item) => sum + Number(item.value || 0), 0)
  if (total <= 0) return { background: 'conic-gradient(#e6ebf3 0 100%)' }

  const segments = items.map((item) => {
    const start = (cursor / total) * 100
    cursor += Number(item.value || 0)
    const end = (cursor / total) * 100
    return `${item.color} ${start}% ${end}%`
  })

  return {
    background: `conic-gradient(${segments.join(', ')})`
  }
}

function announcementTypeLabel(item) {
  return item.gonggaoValue || getLabel('gonggao_types', item.gonggaoTypes, '') || '其他'
}

function byBusinessDateDesc(left, right) {
  return dateValue(right.createTime || right.insertTime || right.updateTime) - dateValue(left.createTime || left.insertTime || left.updateTime)
}

function parseDate(value) {
  if (!value) return null
  const date = new Date(String(value).slice(0, 10))
  return Number.isNaN(date.getTime()) ? null : date
}

function dateValue(value) {
  const date = parseDate(value)
  return date ? date.getTime() : 0
}

function startOfToday() {
  const now = new Date()
  return new Date(now.getFullYear(), now.getMonth(), now.getDate())
}

function formatDate(value) {
  if (!value) return '-'
  return String(value).slice(0, 10)
}

function formatPercent(value, total) {
  return `${((Number(value || 0) / Math.max(1, total)) * 100).toFixed(1)}%`
}
</script>

<style scoped>
.teacher-dashboard {
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
}

.welcome-row p {
  margin: 0 0 8px;
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

.stat-grid {
  display: grid;
  grid-template-columns: repeat(3, minmax(220px, 1fr));
  gap: 20px;
  margin-bottom: 25px;
}

.stat-card {
  display: flex;
  align-items: center;
  justify-content: space-between;
  min-height: 124px;
  padding: 22px 20px;
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

.stat-icon {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 58px;
  height: 58px;
  border-radius: 50%;
}

.stat-icon.tone-blue {
  background: #edf3ff;
  color: #3f5fff;
}

.stat-icon.tone-green {
  background: #eaf8ef;
  color: #36b977;
}

.stat-icon.tone-purple {
  background: #f3eaff;
  color: #8a52e9;
}

.stat-icon.tone-sky {
  background: #ebf5ff;
  color: #358cff;
}

.charts-grid {
  display: grid;
  grid-template-columns: 0.86fr 0.84fr 1.14fr;
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
  min-height: 270px;
  padding: 24px 22px;
}

.donut-layout {
  display: grid;
  grid-template-columns: minmax(138px, 170px) minmax(126px, 1fr);
  gap: 22px;
  align-items: center;
  margin-top: 24px;
}

.donut-chart {
  position: relative;
  width: min(166px, 100%);
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
  grid-template-columns: 8px minmax(58px, 1fr) auto;
  align-items: center;
  gap: 12px;
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
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.legend-list li em {
  color: #2f3b52;
  font-style: normal;
  font-weight: 900;
}

.trend-panel {
  min-height: 270px;
  padding: 24px 22px 18px;
}

.trend-chart {
  margin-top: 16px;
}

.trend-chart svg {
  display: block;
  width: 100%;
  height: 205px;
}

.grid-lines line {
  stroke: #e9eef6;
  stroke-width: 1;
}

.trend-labels {
  display: grid;
  grid-template-columns: repeat(12, 1fr);
  gap: 4px;
  color: #66738b;
  font-size: 12px;
  font-weight: 800;
  text-align: center;
}

.bottom-grid {
  display: grid;
  grid-template-columns: 1fr 1.04fr;
  gap: 20px;
}

.list-card {
  min-width: 0;
  padding: 22px 20px 20px;
}

.list-card header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 18px;
  margin-bottom: 18px;
}

.list-card header a {
  color: #66738b;
  font-size: 13px;
  font-weight: 800;
  text-decoration: none;
}

.list-card header a:hover {
  color: #3657ff;
}

.announcement-list,
.comment-list {
  margin: 0;
  padding: 0;
  list-style: none;
  border: 1px solid #e7edf5;
  border-radius: 8px;
  overflow: hidden;
}

.announcement-list li {
  display: grid;
  grid-template-columns: 72px minmax(0, 1fr) 92px;
  align-items: center;
  gap: 12px;
  min-height: 45px;
  padding: 0 10px;
  border-bottom: 1px solid #e8edf5;
}

.announcement-list li:last-child,
.comment-list li:last-child {
  border-bottom: 0;
}

.type-tag {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  height: 24px;
  border-radius: 6px;
  background: #eef3ff;
  color: #3f5fff;
  font-size: 12px;
  font-weight: 900;
}

.announcement-list strong {
  overflow: hidden;
  color: #344057;
  font-size: 13px;
  font-weight: 800;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.announcement-list time,
.comment-list time {
  color: #6d7890;
  font-size: 12px;
  font-weight: 800;
}

.comment-list li {
  display: grid;
  grid-template-columns: 34px minmax(0, 1fr) 92px;
  align-items: start;
  gap: 12px;
  min-height: 76px;
  padding: 13px 14px;
  border-bottom: 1px solid #e8edf5;
}

.comment-avatar {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 34px;
  height: 34px;
  border-radius: 50%;
  background: #edf3ff;
  color: #3657ff;
  font-size: 13px;
  font-weight: 900;
}

.comment-list p {
  margin: 0 0 8px;
  overflow: hidden;
  color: #344057;
  font-size: 13px;
  font-weight: 800;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.comment-list p strong {
  color: #17233d;
  font-weight: 900;
}

.comment-list small {
  display: -webkit-box;
  overflow: hidden;
  color: #5d6a82;
  font-size: 13px;
  font-weight: 800;
  line-height: 1.45;
  -webkit-box-orient: vertical;
  -webkit-line-clamp: 2;
}

.empty-block {
  display: grid;
  place-items: center;
  min-height: 168px;
  border: 1px solid #e7edf5;
  border-radius: 8px;
  color: #8b97aa;
  font-size: 14px;
  font-weight: 800;
}

.page-footer {
  margin-top: 34px;
  color: #8792a6;
  font-size: 14px;
  font-weight: 700;
  text-align: center;
}

@media (max-width: 1500px) {
  .charts-grid {
    grid-template-columns: 1fr 1fr;
  }

  .trend-panel {
    grid-column: 1 / -1;
  }
}

@media (max-width: 1240px) {
  .stat-grid,
  .charts-grid,
  .bottom-grid {
    grid-template-columns: 1fr;
  }

  .trend-panel {
    grid-column: auto;
  }
}
</style>
