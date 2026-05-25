import {
  BriefcaseBusiness,
  Home,
  LockKeyhole,
  Megaphone,
  MessageSquareText,
  UserRound,
  UsersRound
} from 'lucide-vue-next'

export const studentSidebarSections = [
  {
    title: '',
    items: [{ label: '首页', routeName: 'student.dashboard', icon: Home }]
  },
  {
    title: '个人中心',
    items: [
      { label: '个人信息', routeName: 'student.profile', icon: UserRound },
      { label: '修改密码', routeName: 'student.password', icon: LockKeyhole }
    ]
  },
  {
    title: '实习管理',
    items: [
      { label: '招聘信息', routeName: 'student.recruitmentJobs', icon: BriefcaseBusiness },
      { label: '我的应聘', routeName: 'student.applications', icon: UsersRound },
      { label: '我的实习', routeName: 'student.internships', icon: BriefcaseBusiness }
    ]
  },
  {
    title: '就业管理',
    items: [{ label: '我的就业', routeName: 'student.employment', icon: UsersRound }]
  },
  {
    title: '信息服务',
    items: [{ label: '公告信息', routeName: 'student.announcements', icon: Megaphone }]
  },
  {
    title: '互动交流',
    items: [
      { label: '讨论区', routeName: 'student.discussions', icon: MessageSquareText },
      { label: '问题记录', routeName: 'student.questions', icon: MessageSquareText },
      { label: '我的评论', routeName: 'student.comments', icon: MessageSquareText }
    ]
  }
]
