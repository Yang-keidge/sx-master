import * as announcementApi from '../api/announcement'
import * as commentApi from '../api/comment'
import * as internshipApi from '../api/internship'
import * as studentApi from '../api/student'

export async function fetchStudentDashboardSummary() {
  const [studentResult, internshipsResult, announcementsResult, commentsResult] = await Promise.all([
    studentApi.session(),
    internshipApi.page({ page: 1, limit: 1000, orderBy: 'id' }),
    announcementApi.page({ page: 1, limit: 1000, orderBy: 'insert_time' }),
    commentApi.page({ page: 1, limit: 1000, orderBy: 'create_time', myOnly: 'true' })
  ])

  return {
    student: studentResult.data || null,
    internships: internshipsResult.data?.list || [],
    announcements: announcementsResult.data?.list || [],
    comments: commentsResult.data?.list || []
  }
}
