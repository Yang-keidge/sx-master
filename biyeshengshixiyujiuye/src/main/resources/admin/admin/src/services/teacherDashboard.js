import * as announcementApi from '../api/announcement'
import * as commentApi from '../api/comment'
import * as employmentApi from '../api/employment'
import * as internshipApi from '../api/internship'
import * as studentApi from '../api/student'
import * as teacherApi from '../api/teacher'

export async function fetchTeacherDashboardSummary() {
  const [teacherResult, studentsResult, internshipsResult, employmentResult, announcementsResult, commentsResult] =
    await Promise.all([
      teacherApi.session(),
      studentApi.page({ page: 1, limit: 1000, orderBy: 'id' }),
      internshipApi.page({ page: 1, limit: 1000, orderBy: 'id' }),
      employmentApi.page({ page: 1, limit: 1000, orderBy: 'id' }),
      announcementApi.page({ page: 1, limit: 1000, orderBy: 'insert_time', myOnly: 'true' }),
      commentApi.page({ page: 1, limit: 1000, orderBy: 'create_time', receivedOnly: 'true' })
    ])

  const students = studentsResult.data?.list || []
  const internships = internshipsResult.data?.list || []
  const employment = employmentResult.data?.list || []
  const announcements = announcementsResult.data?.list || []
  const comments = commentsResult.data?.list || []

  return {
    teacher: teacherResult.data || null,
    students,
    internships,
    employment,
    announcements,
    comments,
    totals: {
      students: students.length,
      internshipStudents: countDistinct(internships, 'xueshengId'),
      employedStudents: countDistinct(employment, 'xueshengId'),
      announcements: announcements.length
    }
  }
}

function countDistinct(list, prop) {
  return new Set(list.map((item) => item[prop]).filter((value) => value !== null && value !== undefined && value !== '')).size
}
