<template>
  <main class="student-dashboard">
    <section class="welcome-row">
      <div>
        <h1>欢迎回来，{{ studentName }}</h1>
        <p>{{ studentMeta }}</p>
      </div>
      <span v-if="loadError" class="load-warning">{{ loadError }}</span>
    </section>

    <section class="stat-grid" aria-label="学生端核心指标">
      <article v-for="item in statCards" :key="item.label" class="stat-card">
        <span class="stat-icon" :class="`tone-${item.tone}`">
          <component :is="item.icon" :size="27" stroke-width="2.25" />
        </span>
        <div>
          <p>{{ item.label }}</p>
          <strong :class="item.valueClass">{{ item.value }}</strong>
          <span>{{ item.caption }}</span>
        </div>
      </article>
    </section>

    <section class="charts-grid">
      <article class="panel-card donut-panel">
        <h2>实习时长统计</h2>
        <div class="donut-layout">
          <div class="donut-chart" :style="donutStyle(internshipTimeDistribution)">
            <div class="donut-center">
              <span>已完成</span>
              <strong>{{ completedMonths }}/{{ totalMonths }}个月</strong>
            </div>
          </div>
          <ul class="legend-list">
            <li v-for="item in internshipTimeDistribution" :key="item.label">
              <span :style="{ background: item.color }"></span>
              <strong>{{ item.label }}</strong>
              <em>{{ item.value }}个月 ({{ item.percent }})</em>
            </li>
          </ul>
        </div>
      </article>

      <article class="panel-card donut-panel">
        <h2>公告类型分布</h2>
        <div class="donut-layout">
          <div class="donut-chart" :style="donutStyle(announcementTypeDistribution)">
            <div class="donut-center">
              <span>总数</span>
              <strong>{{ announcements.length }}</strong>
            </div>
          </div>
          <ul class="legend-list">
            <li v-for="item in announcementTypeDistribution" :key="item.label">
              <span :style="{ background: item.color }"></span>
              <strong>{{ item.label }}</strong>
              <em>{{ item.value }} ({{ item.percent }})</em>
            </li>
          </ul>
        </div>
      </article>
    </section>

    <section class="overview-grid">
      <article class="panel-card overview-card internship-card">
        <header>
          <h2>我的实习</h2>
          <RouterLink :to="{ name: 'student.internships' }">查看全部</RouterLink>
        </header>
        <div v-if="latestInternship" class="internship-summary">
          <div class="company-cover">
            <img v-if="latestInternshipImage" :src="latestInternshipImage" alt="" />
            <Building2 v-else :size="34" stroke-width="2" />
          </div>
          <div class="internship-copy">
            <div class="title-row">
              <strong>{{ latestInternship.qiyeName || '未命名企业' }}</strong>
              <span class="status-pill">{{ internshipStatus(latestInternship) }}</span>
            </div>
            <p>实习岗位：{{ latestInternship.shixiGangweiName || '-' }}</p>
            <p>实习类型：{{ internshipTypeLabel(latestInternship) }}</p>
            <p>开始日期：{{ formatDate(latestInternship.shixiKaishiTime) }}</p>
            <p>公司地址：{{ latestInternship.qiyeAddress || '-' }}</p>
          </div>
        </div>
        <div v-else class="empty-block">暂无实习记录</div>
        <RouterLink class="detail-button" :to="{ name: 'student.internships' }">查看详情</RouterLink>
      </article>

      <article class="panel-card overview-card">
        <header>
          <h2>最新公告</h2>
          <RouterLink :to="{ name: 'student.announcements' }">查看全部</RouterLink>
        </header>
        <ul v-if="latestAnnouncements.length" class="news-list">
          <li v-for="item in latestAnnouncements" :key="item.id">
            <span class="type-tag">{{ announcementTypeLabel(item) }}</span>
            <strong>{{ item.gonggaoName || '-' }}</strong>
            <time>{{ formatDate(item.insertTime || item.createTime) }}</time>
          </li>
        </ul>
        <div v-else class="empty-block">暂无公告信息</div>
      </article>

      <article class="panel-card overview-card">
        <header>
          <h2>我的评论</h2>
          <RouterLink :to="{ name: 'student.comments' }">查看全部</RouterLink>
        </header>
        <ul v-if="latestComments.length" class="comment-list">
          <li v-for="item in latestComments" :key="item.id">
            <strong>{{ item.gonggaoName || '公告评论' }}</strong>
            <p>{{ item.gonggaoCommentContent || '-' }}</p>
            <time>{{ formatDate(item.createTime || item.updateTime) }}</time>
          </li>
        </ul>
        <div v-else class="empty-block">暂无评论记录</div>
      </article>
    </section>

    <footer class="page-footer">© 2025 实习就业管理系统 版权所有</footer>
  </main>
</template>

<script setup>
import { computed, onMounted, ref } from 'vue'
import { RouterLink } from 'vue-router'
import {
  BriefcaseBusiness,
  Building2,
  CalendarDays,
  CheckCircle2,
  FileText,
  MessageSquareText
} from 'lucide-vue-next'
import { normalizeAssetUrl } from '../../api/request'
import { useDictionary } from '../../hooks/useDictionary'
import { fetchStudentDashboardSummary } from '../../services/studentDashboard'
import { formatStudentClass } from '../../utils/student'

const palette = ['#3f5fff', '#7185f6', '#58d2ae', '#b8dce9', '#e6eaf7', '#f6a15f']
const summary = ref(null)
const loadError = ref('')
const { ensure, getLabel } = useDictionary()

onMounted(async () => {
  await Promise.all([ensure('shixi_types'), ensure('shixi_jieguo_types'), ensure('gonggao_types')])
  try {
    summary.value = await fetchStudentDashboardSummary()
    loadError.value = ''
  } catch {
    summary.value = null
    loadError.value = '学生端数据加载失败，请检查后端服务'
  }
})

const student = computed(() => summary.value?.student || {})
const internships = computed(() => summary.value?.internships || [])
const employment = computed(() => summary.value?.employment || [])
const announcements = computed(() => summary.value?.announcements || [])
const comments = computed(() => summary.value?.comments || [])

const studentName = computed(() => student.value.xueshengName || storedUser.value.username || '学生用户')
const studentMeta = computed(() => {
  const department = student.value.yuanxiValue || '未设置院系'
  const major = student.value.zhuanyeValue || '未设置专业'
  const className = formatStudentClass(student.value) || '未设置班级'
  const number = student.value.xueshengXuehao || storedUser.value.studentNumber || '-'
  return `${department} · ${major} · ${className} · ${number}`
})

const storedUser = computed(() => {
  try {
    return JSON.parse(localStorage.getItem('currentUser') || '{}')
  } catch {
    return {}
  }
})

const completedInternships = computed(() => internships.value.filter(isCompletedInternship).length)
const latestInternship = computed(() => [...internships.value].sort(byBusinessDateDesc).at(0) || null)
const latestInternshipImage = computed(() => normalizeAssetUrl(latestInternship.value?.qiyePhoto))
const latestAnnouncements = computed(() => [...announcements.value].sort(byAnnouncementDateDesc).slice(0, 5))
const latestComments = computed(() => [...comments.value].sort(byCreateTimeDesc).slice(0, 3))

const currentStatus = computed(() => {
  if (!internships.value.length) return '暂无记录'
  const active = internships.value.find(isActiveInternship)
  if (active) return '进行中'
  const future = internships.value.find((item) => {
    const start = parseDate(item.shixiKaishiTime)
    return start && start > startOfToday()
  })
  return future ? '未开始' : '已完成'
})

const graduation = computed(() => {
  const year = Number(student.value.ruxueYear)
  if (!year) {
    return { value: '-', caption: '距离毕业' }
  }

  const target = new Date(year + 4, 5, 1)
  const days = Math.ceil((target - startOfToday()) / 86400000)
  if (days <= 0) {
    return { value: '已毕业', caption: '毕业状态' }
  }

  return { value: days, caption: '距离毕业' }
})

const statCards = computed(() => [
  {
    label: '实习记录',
    value: internships.value.length,
    caption: `${completedInternships.value} 条已完成`,
    icon: BriefcaseBusiness,
    tone: 'blue'
  },
  {
    label: '实习状态',
    value: currentStatus.value,
    caption: '当前状态',
    icon: CheckCircle2,
    tone: 'green',
    valueClass: currentStatus.value === '进行中' ? 'success-text' : ''
  },
  {
    label: '就业记录',
    value: employment.value.length,
    caption: employment.value.length ? '已有记录' : '暂无记录',
    icon: FileText,
    tone: 'purple'
  },
  {
    label: '评论数量',
    value: comments.value.length,
    caption: '累计评论',
    icon: MessageSquareText,
    tone: 'sky'
  },
  {
    label: '毕业倒计时',
    value: graduation.value.value,
    caption: graduation.value.caption,
    icon: CalendarDays,
    tone: 'green'
  }
])

const internshipMonths = computed(() => {
  const record = latestInternship.value
  if (!record) return { completed: 0, remaining: 0, total: 0 }

  const start = parseDate(record.shixiKaishiTime)
  const end = parseDate(record.shixiJieshuTime)
  if (!start || !end || end < start) return { completed: 0, remaining: 0, total: 0 }

  const today = startOfToday()
  const total = Math.max(1, monthSpan(start, end))
  const completed = Math.min(total, Math.max(0, monthSpan(start, today)))
  return {
    completed,
    remaining: Math.max(0, total - completed),
    total
  }
})

const completedMonths = computed(() => internshipMonths.value.completed)
const totalMonths = computed(() => internshipMonths.value.total)
const internshipTimeDistribution = computed(() => {
  const total = internshipMonths.value.total || 1
  return [
    {
      label: '已完成',
      value: internshipMonths.value.completed,
      percent: formatPercent(internshipMonths.value.completed, total),
      color: '#3f5fff'
    },
    {
      label: '剩余',
      value: internshipMonths.value.remaining,
      percent: formatPercent(internshipMonths.value.remaining, total),
      color: '#e6eaf7'
    }
  ]
})

const announcementTypeDistribution = computed(() => {
  const counts = new Map()
  announcements.value.forEach((item) => {
    const label = announcementTypeLabel(item)
    counts.set(label, (counts.get(label) || 0) + 1)
  })

  const total = announcements.value.length || 1
  return [...counts.entries()]
    .sort((left, right) => right[1] - left[1])
    .slice(0, 5)
    .map(([label, value], index) => ({
      label,
      value,
      percent: formatPercent(value, total),
      color: palette[index % palette.length]
    }))
})

function internshipTypeLabel(item) {
  return item.shixiValue || getLabel('shixi_types', item.shixiTypes, '') || '-'
}

function announcementTypeLabel(item) {
  return item.gonggaoValue || getLabel('gonggao_types', item.gonggaoTypes, '') || '其他'
}

function internshipStatus(item) {
  const start = parseDate(item.shixiKaishiTime)
  const end = parseDate(item.shixiJieshuTime)
  const today = startOfToday()
  if (start && start > today) return '未开始'
  if (end && end < today) return '已结束'
  return '进行中'
}

function isActiveInternship(item) {
  return internshipStatus(item) === '进行中'
}

function isCompletedInternship(item) {
  const end = parseDate(item.shixiJieshuTime)
  return Boolean(end && end < startOfToday())
}

function donutStyle(items) {
  let cursor = 0
  const total = items.reduce((sum, item) => sum + Number(item.value || 0), 0)
  if (total <= 0) {
    return { background: 'conic-gradient(#e6ebf3 0 100%)' }
  }

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

function byBusinessDateDesc(left, right) {
  return dateValue(right.shixiKaishiTime || right.createTime) - dateValue(left.shixiKaishiTime || left.createTime)
}

function byAnnouncementDateDesc(left, right) {
  return dateValue(right.insertTime || right.createTime) - dateValue(left.insertTime || left.createTime)
}

function byCreateTimeDesc(left, right) {
  return dateValue(right.createTime || right.updateTime) - dateValue(left.createTime || left.updateTime)
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

function monthSpan(start, end) {
  const days = Math.ceil((end - start) / 86400000)
  return Math.max(0, Math.ceil(days / 30))
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
.student-dashboard {
  min-width: 1026px;
  padding: 0 40px 40px;
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
  grid-template-columns: repeat(5, minmax(168px, 1fr));
  gap: 16px;
  margin-bottom: 25px;
}

.stat-card {
  display: flex;
  align-items: center;
  gap: 10px;
  min-height: 124px;
  padding: 20px 15px;
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
  font-size: 22px;
  font-weight: 900;
  line-height: 1;
  white-space: nowrap;
}

.stat-card strong.success-text {
  color: #16a45f;
}

.stat-card span:last-child {
  color: #728096;
  font-size: 13px;
  font-weight: 800;
}

.stat-icon {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  flex: 0 0 auto;
  width: 46px;
  height: 46px;
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
  grid-template-columns: 1fr 1.08fr;
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
  height: 282px;
  padding: 24px 22px;
}

.donut-layout {
  display: grid;
  grid-template-columns: minmax(150px, 188px) minmax(150px, 1fr);
  gap: 28px;
  align-items: center;
  margin-top: 24px;
}

.donut-chart {
  position: relative;
  width: min(178px, 100%);
  aspect-ratio: 1;
  border-radius: 50%;
}

.donut-chart::before {
  position: absolute;
  inset: 30px;
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
  text-overflow: ellipsis;
  white-space: nowrap;
}

.legend-list li em {
  color: #2f3b52;
  font-style: normal;
  font-weight: 900;
}

.overview-grid {
  display: grid;
  grid-template-columns: 1fr 1.02fr 1.04fr;
  gap: 20px;
}

.overview-card {
  min-width: 0;
  padding: 22px 20px 20px;
}

.overview-card header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 18px;
  margin-bottom: 18px;
}

.overview-card header a {
  color: #66738b;
  font-size: 13px;
  font-weight: 800;
  text-decoration: none;
}

.overview-card header a:hover {
  color: #3657ff;
}

.internship-card {
  display: grid;
  grid-template-rows: auto 1fr auto;
}

.internship-summary {
  display: grid;
  grid-template-columns: 76px minmax(0, 1fr);
  gap: 16px;
  min-height: 224px;
  padding: 18px;
  border: 1px solid #e7edf5;
  border-radius: 8px;
}

.company-cover {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 76px;
  height: 76px;
  overflow: hidden;
  border-radius: 6px;
  background: #edf3ff;
  color: #3f5fff;
}

.company-cover img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.internship-copy {
  min-width: 0;
}

.title-row {
  display: flex;
  align-items: center;
  gap: 10px;
  margin-bottom: 10px;
}

.title-row strong {
  min-width: 0;
  overflow: hidden;
  color: #17233d;
  font-size: 15px;
  font-weight: 900;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.status-pill {
  flex: 0 0 auto;
  height: 24px;
  padding: 0 9px;
  border-radius: 999px;
  background: #e8f8ed;
  color: #16944e;
  font-size: 12px;
  font-weight: 900;
  line-height: 24px;
}

.internship-copy p {
  margin: 0 0 10px;
  color: #5d6a82;
  font-size: 13px;
  font-weight: 800;
  line-height: 1.45;
}

.detail-button {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 176px;
  height: 38px;
  margin-top: 16px;
  border: 1px solid #8da0ff;
  border-radius: 6px;
  color: #3657ff;
  font-size: 14px;
  font-weight: 900;
  text-decoration: none;
}

.detail-button:hover {
  background: #eef3ff;
}

.news-list,
.comment-list {
  margin: 0;
  padding: 0;
  list-style: none;
  border: 1px solid #e7edf5;
  border-radius: 8px;
  overflow: hidden;
}

.news-list li {
  display: grid;
  grid-template-columns: 72px minmax(0, 1fr) 92px;
  align-items: center;
  gap: 12px;
  min-height: 45px;
  padding: 0 10px;
  border-bottom: 1px solid #e8edf5;
}

.news-list li:last-child,
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

.news-list strong {
  overflow: hidden;
  color: #344057;
  font-size: 13px;
  font-weight: 800;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.news-list time,
.comment-list time {
  color: #6d7890;
  font-size: 12px;
  font-weight: 800;
}

.comment-list li {
  display: grid;
  gap: 8px;
  min-height: 86px;
  padding: 14px 16px;
  border-bottom: 1px solid #e8edf5;
}

.comment-list strong {
  color: #344057;
  font-size: 14px;
  font-weight: 900;
}

.comment-list p {
  display: -webkit-box;
  margin: 0;
  overflow: hidden;
  color: #5d6a82;
  font-size: 13px;
  font-weight: 800;
  line-height: 1.55;
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

@media (max-width: 1180px) {
  .stat-grid {
    grid-template-columns: repeat(3, 1fr);
  }

  .charts-grid,
  .overview-grid {
    grid-template-columns: 1fr;
  }
}
</style>
