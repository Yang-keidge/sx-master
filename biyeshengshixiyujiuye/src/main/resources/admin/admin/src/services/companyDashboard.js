import * as announcementApi from '../api/announcement'
import * as companyApi from '../api/company'
import * as employmentApi from '../api/employment'
import * as internshipApi from '../api/internship'

export async function fetchCompanyDashboardSummary() {
  const [companyResult, internshipsResult, employmentResult, announcementsResult] = await Promise.all([
    companyApi.session(),
    internshipApi.page({ page: 1, limit: 1000, orderBy: 'id' }),
    employmentApi.page({ page: 1, limit: 1000, orderBy: 'id' }),
    announcementApi.page({ page: 1, limit: 1000, orderBy: 'id', myOnly: 'true' })
  ])

  const internships = internshipsResult.data?.list || []
  const employment = employmentResult.data?.list || []
  const announcements = announcementsResult.data?.list || []

  return {
    company: companyResult.data || null,
    internships,
    employment,
    announcements,
    totals: {
      internshipStudents: countDistinct(internships, 'xueshengId'),
      activeInternships: internships.filter(isActiveInternship).length,
      completedInternships: internships.filter(isCompletedInternship).length,
      announcements: announcements.length,
      employedStudents: countDistinct(employment, 'xueshengId')
    }
  }
}

function countDistinct(list, prop) {
  return new Set(list.map((item) => item[prop]).filter((value) => value !== null && value !== undefined && value !== '')).size
}

function isActiveInternship(item) {
  const now = startOfToday()
  const start = parseDate(item.shixiKaishiTime)
  const end = parseDate(item.shixiJieshuTime)

  if (start && start > now) return false
  if (end && end < now) return false
  return true
}

function isCompletedInternship(item) {
  const end = parseDate(item.shixiJieshuTime)
  return Boolean(end && end < startOfToday())
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
