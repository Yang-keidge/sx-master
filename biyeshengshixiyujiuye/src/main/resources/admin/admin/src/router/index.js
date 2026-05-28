import { createRouter, createWebHistory } from 'vue-router'
import LoginView from '../views/LoginView.vue'
import AdminLayout from '../layouts/AdminLayout.vue'
import CompanyLayout from '../layouts/CompanyLayout.vue'
import StudentLayout from '../layouts/StudentLayout.vue'
import TeacherLayout from '../layouts/TeacherLayout.vue'
import DashboardView from '../views/admin/DashboardView.vue'
import CompanyDashboardView from '../views/company/DashboardView.vue'
import CompanyProfileView from '../views/company/ProfileView.vue'
import StudentDashboardView from '../views/student/DashboardView.vue'
import StudentProfileView from '../views/student/ProfileView.vue'
import StudentPasswordView from '../views/student/PasswordView.vue'
import TeacherDashboardView from '../views/teacher/DashboardView.vue'
import TeacherProfileView from '../views/teacher/ProfileView.vue'
import TeacherPasswordView from '../views/teacher/PasswordView.vue'
import PlaceholderView from '../views/admin/PlaceholderView.vue'
import CrudModuleView from '../views/admin/crud/ModuleView.vue'
import CompanyCrudModuleView from '../views/company/crud/ModuleView.vue'
import StudentCrudModuleView from '../views/student/crud/ModuleView.vue'
import TeacherCrudModuleView from '../views/teacher/crud/ModuleView.vue'

const placeholder = (path, name, title, group) => ({
  path,
  name,
  component: PlaceholderView,
  meta: {
    title,
    group,
    requiresAuth: true,
    role: 'admin'
  }
})

const moduleRoute = (path, name, title, group, moduleName, alias) => ({
  path,
  alias: alias ? [alias] : [],
  name,
  component: CrudModuleView,
  props: {
    moduleName
  },
  meta: {
    title,
    group,
    requiresAuth: true,
    role: 'admin'
  }
})

const companyModuleRoute = (path, name, title, group, moduleName) => ({
  path,
  name,
  component: CompanyCrudModuleView,
  props: {
    moduleName
  },
  meta: {
    title,
    group,
    requiresAuth: true,
    role: 'company'
  }
})

const studentModuleRoute = (path, name, title, group, moduleName) => ({
  path,
  name,
  component: StudentCrudModuleView,
  props: {
    moduleName
  },
  meta: {
    title,
    group,
    requiresAuth: true,
    role: 'student'
  }
})

const teacherModuleRoute = (path, name, title, group, moduleName) => ({
  path,
  name,
  component: TeacherCrudModuleView,
  props: {
    moduleName
  },
  meta: {
    title,
    group,
    requiresAuth: true,
    role: 'teacher'
  }
})

const router = createRouter({
  history: createWebHistory(),
  routes: [
    {
      path: '/',
      redirect: '/login'
    },
    {
      path: '/login',
      name: 'login',
      component: LoginView,
      meta: {
        guestOnly: true
      }
    },
    {
      path: '/admin',
      component: AdminLayout,
      redirect: '/admin/dashboard',
      meta: {
        requiresAuth: true,
        role: 'admin'
      },
      children: [
        {
          path: 'dashboard',
          name: 'admin.dashboard',
          component: DashboardView,
          meta: {
            title: '首页',
            group: 'workbench',
            requiresAuth: true,
            role: 'admin'
          }
        },
        placeholder('analytics', 'admin.analytics', '数据看板', 'workbench'),
        moduleRoute('students', 'admin.students', '学生管理', 'basic', 'students', 'student'),
        moduleRoute('teachers', 'admin.teachers', '教师管理', 'basic', 'teachers', 'teacher'),
        moduleRoute('companies', 'admin.companies', '企业管理', 'basic', 'companies', 'company'),
        moduleRoute('internships', 'admin.internships', '实习管理', 'business', 'internships', 'internship'),
        moduleRoute('employment', 'admin.employment', '就业管理', 'business', 'employment'),
        moduleRoute('recruitment-jobs', 'admin.recruitmentJobs', '招聘岗位', 'business', 'recruitmentJobs'),
        moduleRoute('applications', 'admin.applications', '应聘学生', 'business', 'applications'),
        moduleRoute('announcements', 'admin.announcements', '公告管理', 'business', 'announcements', 'announcement'),
        moduleRoute(
          'announcement-comments',
          'admin.announcementComments',
          '公告评论',
          'business',
          'announcementComments',
          'comment'
        ),
        moduleRoute('discussions', 'admin.discussions', '讨论区', 'business', 'discussions'),
        moduleRoute('discussion-replies', 'admin.discussionReplies', '讨论回复', 'business', 'discussionReplies'),
        moduleRoute('dictionaries', 'admin.dictionaries', '字典管理', 'system', 'dictionaries', 'dictionary'),
        moduleRoute('settings', 'admin.settings', '系统配置', 'system', 'settings', 'config'),
        placeholder('files', 'admin.files', '文件管理', 'system'),
        placeholder('statistics', 'admin.statistics', '数据统计', 'system'),
        placeholder('logs', 'admin.logs', '系统日志', 'system')
      ]
    },
    {
      path: '/company',
      component: CompanyLayout,
      redirect: '/company/dashboard',
      meta: {
        requiresAuth: true,
        role: 'company'
      },
      children: [
        {
          path: 'dashboard',
          name: 'company.dashboard',
          component: CompanyDashboardView,
          meta: {
            title: '首页',
            group: 'workbench',
            requiresAuth: true,
            role: 'company'
          }
        },
        {
          path: 'profile',
          name: 'company.profile',
          component: CompanyProfileView,
          meta: {
            title: '企业信息',
            group: 'business',
            requiresAuth: true,
            role: 'company'
          }
        },
        companyModuleRoute('internships', 'company.internships', '实习管理', 'business', 'internships'),
        companyModuleRoute('employment-data', 'company.employmentData', '就业管理', 'business', 'employmentData'),
        companyModuleRoute('recruitment-jobs', 'company.recruitmentJobs', '招聘岗位', 'business', 'recruitmentJobs'),
        companyModuleRoute('applications', 'company.applications', '应聘学生', 'business', 'applications'),
        companyModuleRoute('announcements', 'company.announcements', '招聘公告', 'announcement', 'announcements'),
        companyModuleRoute('other-announcements', 'company.otherAnnouncements', '其他公告', 'announcement', 'otherAnnouncements'),
        companyModuleRoute('discussions', 'company.discussions', '讨论区', 'interaction', 'discussions'),
        companyModuleRoute('comments', 'company.comments', '公告评论', 'announcement', 'comments')
      ]
    },
    {
      path: '/student',
      component: StudentLayout,
      redirect: '/student/dashboard',
      meta: {
        requiresAuth: true,
        role: 'student'
      },
      children: [
        {
          path: 'dashboard',
          name: 'student.dashboard',
          component: StudentDashboardView,
          meta: {
            title: '首页',
            group: 'workbench',
            requiresAuth: true,
            role: 'student'
          }
        },
        {
          path: 'profile',
          name: 'student.profile',
          component: StudentProfileView,
          meta: {
            title: '个人信息',
            group: 'profile',
            requiresAuth: true,
            role: 'student'
          }
        },
        {
          path: 'password',
          name: 'student.password',
          component: StudentPasswordView,
          meta: {
            title: '修改密码',
            group: 'profile',
            requiresAuth: true,
            role: 'student'
          }
        },
        studentModuleRoute('recruitment-jobs', 'student.recruitmentJobs', '招聘信息', 'business', 'recruitmentJobs'),
        studentModuleRoute('applications', 'student.applications', '我的应聘', 'business', 'applications'),
        studentModuleRoute('internships', 'student.internships', '我的实习', 'business', 'internships'),
        studentModuleRoute('employment', 'student.employment', '我的就业', 'business', 'employment'),
        studentModuleRoute('announcements', 'student.announcements', '公告信息', 'service', 'announcements'),
        studentModuleRoute('discussions', 'student.discussions', '讨论区', 'interaction', 'discussions'),
        studentModuleRoute('questions', 'student.questions', '问题记录', 'interaction', 'questions'),
        studentModuleRoute('comments', 'student.comments', '我的评论', 'interaction', 'comments')
      ]
    },
    {
      path: '/teacher',
      component: TeacherLayout,
      redirect: '/teacher/dashboard',
      meta: {
        requiresAuth: true,
        role: 'teacher'
      },
      children: [
        {
          path: 'dashboard',
          name: 'teacher.dashboard',
          component: TeacherDashboardView,
          meta: {
            title: '首页',
            group: 'workbench',
            requiresAuth: true,
            role: 'teacher'
          }
        },
        {
          path: 'profile',
          name: 'teacher.profile',
          component: TeacherProfileView,
          meta: {
            title: '个人信息',
            group: 'profile',
            requiresAuth: true,
            role: 'teacher'
          }
        },
        {
          path: 'password',
          name: 'teacher.password',
          component: TeacherPasswordView,
          meta: {
            title: '修改密码',
            group: 'profile',
            requiresAuth: true,
            role: 'teacher'
          }
        },
        teacherModuleRoute('students', 'teacher.students', '学生管理', 'students', 'students'),
        teacherModuleRoute('internships', 'teacher.internships', '实习情况', 'internship', 'internships'),
        teacherModuleRoute('employment', 'teacher.employment', '就业情况', 'employment', 'employment'),
        teacherModuleRoute('announcements', 'teacher.announcements', '我的公告', 'announcement', 'announcements'),
        teacherModuleRoute(
          'announcement-comments',
          'teacher.announcementComments',
          '公告评论',
          'announcement',
          'announcementComments'
        ),
        teacherModuleRoute('comments', 'teacher.comments', '我的评论', 'announcement', 'comments'),
        teacherModuleRoute('other-announcements', 'teacher.otherAnnouncements', '其他公告', 'announcement', 'otherAnnouncements'),
        teacherModuleRoute('discussions', 'teacher.discussions', '讨论区', 'interaction', 'discussions'),
        teacherModuleRoute('questions', 'teacher.questions', '问题解答', 'interaction', 'questions')
      ]
    }
  ],
  scrollBehavior() {
    return { top: 0 }
  }
})

router.beforeEach((to) => {
  const token = localStorage.getItem('Token')
  const currentUser = getCurrentUser()

  if (to.meta.requiresAuth && !token) {
    return { name: 'login' }
  }

  if (to.meta.role && token && currentUser?.role) {
    const requiredRole = {
      admin: '管理员',
      company: '企业',
      student: '学生',
      teacher: '老师'
    }[to.meta.role]

    if (requiredRole && currentUser.role !== requiredRole) {
      const fallbackRoute = {
        管理员: 'admin.dashboard',
        企业: 'company.dashboard',
        学生: 'student.dashboard',
        老师: 'teacher.dashboard'
      }[currentUser.role]

      return fallbackRoute ? { name: fallbackRoute } : { name: 'login' }
    }
  }

  return true
})

function getCurrentUser() {
  const raw = localStorage.getItem('currentUser')
  if (!raw) return null

  try {
    return JSON.parse(raw)
  } catch {
    return null
  }
}

export default router
