import {
  BarChart3,
  BookOpenText,
  BriefcaseBusiness,
  Building2,
  ChartPie,
  ChevronDown,
  FileCog,
  FileText,
  Folder,
  GraduationCap,
  Home,
  Megaphone,
  MessageSquareText,
  UserRound,
  UsersRound
} from 'lucide-vue-next'

export const sidebarSections = [
  {
    title: '',
    items: [
      { label: '首页', routeName: 'admin.dashboard', icon: Home }
    ]
  },
  {
    title: '基础资料',
    items: [
      { label: '学生管理', routeName: 'admin.students', icon: UsersRound },
      { label: '教师管理', routeName: 'admin.teachers', icon: UserRound },
      { label: '企业管理', routeName: 'admin.companies', icon: Building2 }
    ]
  },
  {
    title: '实习就业',
    items: [
      { label: '实习管理', routeName: 'admin.internships', icon: UsersRound },
      { label: '就业管理', routeName: 'admin.employment', icon: BriefcaseBusiness },
      { label: '招聘岗位', routeName: 'admin.recruitmentJobs', icon: BriefcaseBusiness },
      { label: '应聘学生', routeName: 'admin.applications', icon: UsersRound }
    ]
  },
  {
    title: '信息互动',
    items: [
      { label: '公告管理', routeName: 'admin.announcements', icon: Megaphone },
      { label: '公告评论', routeName: 'admin.announcementComments', icon: MessageSquareText },
      { label: '讨论区', routeName: 'admin.discussions', icon: MessageSquareText },
      { label: '讨论回复', routeName: 'admin.discussionReplies', icon: MessageSquareText }
    ]
  },
  {
    title: '系统设置',
    items: [
      { label: '字典管理', routeName: 'admin.dictionaries', icon: BookOpenText },
      { label: '文件管理', routeName: 'admin.files', icon: Folder, hidden: true },
      { label: '数据统计', routeName: 'admin.statistics', icon: ChartPie, trailingIcon: ChevronDown, hidden: true },
      { label: '系统日志', routeName: 'admin.logs', icon: FileText, hidden: true }
    ]
  }
]

export const quickActions = [
  { label: '学生管理', routeName: 'admin.students', icon: UsersRound, tone: 'blue' },
  { label: '实习管理', routeName: 'admin.internships', icon: BriefcaseBusiness, tone: 'indigo' },
  { label: '就业管理', routeName: 'admin.employment', icon: Building2, tone: 'green' },
  { label: '招聘岗位', routeName: 'admin.recruitmentJobs', icon: BriefcaseBusiness, tone: 'sky' },
  { label: '公告管理', routeName: 'admin.announcements', icon: Megaphone, tone: 'orange' },
  { label: '数据统计', routeName: 'admin.statistics', icon: BarChart3, tone: 'blue', hidden: true },
  { label: '文件上传', routeName: 'admin.files', icon: FileCog, tone: 'sky', hidden: true }
]
