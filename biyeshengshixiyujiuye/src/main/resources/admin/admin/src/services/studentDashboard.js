import * as announcementApi from '../api/announcement'
import * as commentApi from '../api/comment'
import * as employmentApi from '../api/employment'
import * as internshipApi from '../api/internship'
import * as studentApi from '../api/student'

export async function fetchStudentDashboardSummary() {
  const [studentResult, internshipsResult, employmentResult, announcementsResult, commentsResult] = await Promise.all([
    studentApi.session(),
    internshipApi.page({ page: 1, limit: 1000, orderBy: 'id' }),
    employmentApi.page({ page: 1, limit: 1000, orderBy: 'id' }),
    announcementApi.page({ page: 1, limit: 1000, orderBy: 'insert_time' }),
    commentApi.page({ page: 1, limit: 1000, orderBy: 'create_time', myOnly: 'true' })
  ])

  return {
    student: studentResult.data || null,
    internships: internshipsResult.data?.list || [],
    employment: employmentResult.data?.list || [],
    announcements: announcementsResult.data?.list || [],
    comments: commentsResult.data?.list || []
  }
}
