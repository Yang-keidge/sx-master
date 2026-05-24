<template>
  <main class="company-dashboard">
    <section class="welcome-row">
      <div>
        <h1>欢迎回来，{{ companyName }}</h1>
        <p>{{ todayText }}</p>
      </div>
      <span v-if="loadError" class="load-warning">{{ loadError }}</span>
    </section>

    <section class="stat-grid" aria-label="企业端核心指标">
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
        <h2>实习学生专业分布</h2>
        <div class="donut-layout">
          <div class="donut-chart" :style="donutStyle(majorDistribution)">
            <div class="donut-center">
              <span>总计</span>
              <strong>{{ internshipStudentCount }}</strong>
            </div>
          </div>
          <ul class="legend-list">
            <li v-for="item in majorDistribution" :key="item.label">
              <span :style="{ background: item.color }"></span>
              <strong>{{ item.label }}</strong>
              <em>{{ item.percent }}</em>
            </li>
          </ul>
        </div>
      </article>

      <article class="panel-card donut-panel">
        <h2>实习类型分布</h2>
        <div class="donut-layout">
          <div class="donut-chart" :style="donutStyle(typeDistribution)">
            <div class="donut-center">
              <span>总计</span>
              <strong>{{ internshipCount }}</strong>
            </div>
          </div>
          <ul class="legend-list">
            <li v-for="item in typeDistribution" :key="item.label">
              <span :style="{ background: item.color }"></span>
              <strong>{{ item.label }}</strong>
              <em>{{ item.percent }}</em>
            </li>
          </ul>
        </div>
      </article>
    </section>

    <section class="tables-grid">
      <article class="panel-card records-card">
        <header>
          <h2>最新实习学生</h2>
          <RouterLink :to="{ name: 'company.internships' }">查看更多</RouterLink>
        </header>
        <div class="table-wrap">
          <table>
            <colgroup>
              <col class="col-name" />
              <col class="col-number" />
              <col class="col-major" />
              <col class="col-position" />
              <col class="col-date" />
              <col class="col-status" />
            </colgroup>
            <thead>
              <tr>
                <th>学生姓名</th>
                <th>学号</th>
                <th>我的班级</th>
                <th>实习岗位</th>
                <th>开始日期</th>
                <th>状态</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="record in latestInternships" :key="record.id">
                <td><UserCell :name="record.xueshengName" :photo="record.xueshengPhoto" /></td>
                <td>{{ record.xueshengXuehao || '-' }}</td>
                <td>{{ formatStudentClass(record) || '-' }}</td>
                <td>{{ record.shixiGangweiName || '-' }}</td>
                <td>{{ formatDate(record.shixiKaishiTime) }}</td>
                <td><span class="status-pill">{{ internshipStatus(record) }}</span></td>
              </tr>
              <tr v-if="!latestInternships.length">
                <td class="empty-row" colspan="6">暂无实习学生</td>
              </tr>
            </tbody>
          </table>
        </div>
      </article>

      <article class="panel-card records-card">
        <header>
          <h2>最新招聘公告</h2>
          <RouterLink :to="{ name: 'company.announcements' }">查看更多</RouterLink>
        </header>
        <div class="table-wrap">
          <table>
            <colgroup>
              <col class="col-title" />
              <col class="col-position" />
              <col class="col-date" />
            </colgroup>
            <thead>
              <tr>
                <th>公告标题</th>
                <th>公告类型</th>
                <th>发布时间</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="record in latestAnnouncements" :key="record.id">
                <td>{{ record.gonggaoName || '-' }}</td>
                <td>{{ record.gonggaoValue || '-' }}</td>
                <td>{{ formatDate(record.insertTime || record.createTime) }}</td>
              </tr>
              <tr v-if="!latestAnnouncements.length">
                <td class="empty-row" colspan="3">暂无招聘公告</td>
              </tr>
            </tbody>
          </table>
        </div>
      </article>
    </section>

    <footer class="page-footer">© 2025 实习就业管理系统 版权所有</footer>
  </main>
</template>

<script setup>
import { computed, defineComponent, h, onMounted, ref } from 'vue'
import { RouterLink } from 'vue-router'
import { ArrowUp, BriefcaseBusiness, Megaphone, ShieldCheck, UserRound } from 'lucide-vue-next'
import { normalizeAssetUrl } from '../../api/request'
import { useDictionary } from '../../hooks/useDictionary'
import { fetchCompanyDashboardSummary } from '../../services/companyDashboard'
import { formatStudentClass } from '../../utils/student'

const palette = ['#3f5fff', '#7185f6', '#58d2ae', '#b8dce9', '#b8c1d3', '#f6a15f']
const summary = ref(null)
const loadError = ref('')
const { ensure, getLabel } = useDictionary()

onMounted(async () => {
  await Promise.all([ensure('zhuanye_types'), ensure('shixi_types'), ensure('gonggao_types')])
  try {
    summary.value = await fetchCompanyDashboardSummary()
    loadError.value = ''
  } catch {
    loadError.value = '当前暂无接口数据'
  }
})

const UserCell = defineComponent({
  props: {
    name: {
      type: String,
      default: ''
    },
    photo: {
      type: String,
      default: ''
    }
  },
  setup(props) {
    const avatarFailed = ref(false)
    const avatarSrc = computed(() => normalizeAssetUrl(props.photo))

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
        h('span', { class: 'student-name' }, props.name || '-')
      ])
  }
})

const companyName = computed(() => summary.value?.company?.qiyeName || storedUserName.value || '企业用户')
const internshipCount = computed(() => internships.value.length)
const internshipStudentCount = computed(() => summary.value?.totals?.internshipStudents || 0)

const internships = computed(() => summary.value?.internships || [])
const announcements = computed(() => summary.value?.announcements || [])

const statCards = computed(() => [
  {
    label: '实习学生总数',
    value: internshipStudentCount.value,
    change: summary.value?.totals?.internshipStudents || 0,
    icon: UserRound,
    tone: 'blue'
  },
  {
    label: '在岗实习学生',
    value: summary.value?.totals?.activeInternships || 0,
    change: summary.value?.totals?.activeInternships || 0,
    icon: BriefcaseBusiness,
    tone: 'green'
  },
  {
    label: '完成实习学生',
    value: summary.value?.totals?.completedInternships || 0,
    change: summary.value?.totals?.completedInternships || 0,
    icon: ShieldCheck,
    tone: 'purple'
  },
  {
    label: '招聘公告发布',
    value: summary.value?.totals?.announcements || 0,
    change: summary.value?.totals?.announcements || 0,
    icon: Megaphone,
    tone: 'orange'
  }
])

const todayText = computed(() => {
  const now = new Date()
  const weekMap = ['星期日', '星期一', '星期二', '星期三', '星期四', '星期五', '星期六']
  return `今天是 ${now.getFullYear()}年${now.getMonth() + 1}月${now.getDate()}日，${weekMap[now.getDay()]}`
})

const storedUserName = computed(() => {
  try {
    return JSON.parse(localStorage.getItem('currentUser') || '{}').username
  } catch {
    return ''
  }
})

const majorDistribution = computed(() =>
  buildDistribution(
    internships.value.map((item) => item.zhuanyeValue || getLabel('zhuanye_types', item.zhuanyeTypes, '') || '未设置'),
    6
  )
)

const typeDistribution = computed(() =>
  buildDistribution(
    internships.value.map((item) => item.shixiValue || getLabel('shixi_types', item.shixiTypes, '') || '未设置'),
    4
  )
)

const latestInternships = computed(() => [...internships.value].sort(byCreateTimeDesc).slice(0, 5))
const latestAnnouncements = computed(() => [...announcements.value].sort(byCreateTimeDesc).slice(0, 5))

function buildDistribution(labels, limit) {
  const counts = new Map()
  labels.forEach((label) => {
    counts.set(label, (counts.get(label) || 0) + 1)
  })

  const total = labels.length || 1
  return [...counts.entries()]
    .sort((left, right) => right[1] - left[1])
    .slice(0, limit)
    .map(([label, value], index) => ({
      label,
      value,
      percent: `${((value / total) * 100).toFixed(1)}%`,
      color: palette[index % palette.length]
    }))
}

function donutStyle(items) {
  let cursor = 0
  const total = items.reduce((sum, item) => sum + item.value, 0)
  if (total <= 0) return { background: 'conic-gradient(#e6ebf3 0 100%)' }

  const segments = items.map((item) => {
    const start = (cursor / total) * 100
    cursor += item.value
    const end = (cursor / total) * 100
    return `${item.color} ${start}% ${end}%`
  })

  return {
    background: `conic-gradient(${segments.join(', ')})`
  }
}

function byCreateTimeDesc(left, right) {
  return new Date(right.createTime || right.insertTime || 0) - new Date(left.createTime || left.insertTime || 0)
}

function internshipStatus(record) {
  const now = startOfToday()
  const start = parseDate(record.shixiKaishiTime)
  const end = parseDate(record.shixiJieshuTime)

  if (start && start > now) return '未开始'
  if (end && end < now) return '已结束'
  return '进行中'
}

function parseDate(value) {
  if (!value) return null
  const date = new Date(String(value).slice(0, 10))
  return Number.isNaN(date.getTime()) ? null : date
}

function startOfToday() {
  const now = new Date()
  return new Date(now.getFullYear(), now.getMonth(), now.getDate())
}

function formatDate(value) {
  if (!value) return '-'
  return String(value).slice(0, 10)
}
</script>

<style scoped>
.company-dashboard {
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

.stat-grid {
  display: grid;
  grid-template-columns: repeat(4, minmax(190px, 1fr));
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

.stat-icon.tone-orange {
  background: #fff1e7;
  color: #ff7a2d;
}

.stat-icon.tone-purple {
  background: #f3eaff;
  color: #8a52e9;
}

.charts-grid {
  display: grid;
  grid-template-columns: 1fr 0.92fr;
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
  overflow: hidden;
  font-weight: 800;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.legend-list li em {
  color: #2f3b52;
  font-style: normal;
  font-weight: 900;
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
  width: 14%;
}

.col-number {
  width: 17%;
}

.col-major {
  width: 21%;
}

.col-position {
  width: 22%;
}

.col-date {
  width: 16%;
}

.col-status {
  width: 10%;
}

.col-title {
  width: 44%;
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

.page-footer {
  margin-top: 34px;
  color: #8792a6;
  font-size: 14px;
  font-weight: 700;
  text-align: center;
}

@media (max-width: 1420px) {
  .charts-grid,
  .tables-grid {
    grid-template-columns: 1fr;
  }
}
</style>
