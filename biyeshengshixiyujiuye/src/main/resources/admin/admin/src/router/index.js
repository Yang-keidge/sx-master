import { createRouter, createWebHistory } from 'vue-router'
import LoginView from '../views/LoginView.vue'
import AdminLayout from '../layouts/AdminLayout.vue'
import DashboardView from '../views/admin/DashboardView.vue'
import PlaceholderView from '../views/admin/PlaceholderView.vue'
import CrudModuleView from '../views/admin/crud/ModuleView.vue'

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
        moduleRoute('announcements', 'admin.announcements', '公告管理', 'business', 'announcements', 'announcement'),
        moduleRoute(
          'announcement-comments',
          'admin.announcementComments',
          '公告评论',
          'business',
          'announcementComments',
          'comment'
        ),
        moduleRoute('dictionaries', 'admin.dictionaries', '字典管理', 'system', 'dictionaries', 'dictionary'),
        moduleRoute('settings', 'admin.settings', '系统配置', 'system', 'settings', 'config'),
        placeholder('files', 'admin.files', '文件管理', 'system'),
        placeholder('statistics', 'admin.statistics', '数据统计', 'system'),
        placeholder('logs', 'admin.logs', '系统日志', 'system')
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

  if (to.meta.role === 'admin' && token && currentUser?.role && currentUser.role !== '管理员') {
    return { name: 'login' }
  }

  if (to.meta.guestOnly && token && currentUser?.role === '管理员') {
    return { name: 'admin.dashboard' }
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
