import {
  BriefcaseBusiness,
  Home,
  LockKeyhole,
  Megaphone,
  MessageSquareText,
  UserRound,
  UsersRound
} from 'lucide-vue-next'

export const teacherSidebarSections = [
  {
    title: '',
    items: [{ label: '首页', routeName: 'teacher.dashboard', icon: Home }]
  },
  {
    title: '个人中心',
    items: [
      { label: '个人信息', routeName: 'teacher.profile', icon: UserRound },
      { label: '修改密码', routeName: 'teacher.password', icon: LockKeyhole }
    ]
  },
  {
    title: '学生管理',
    items: [{ label: '学生管理', routeName: 'teacher.students', icon: UsersRound }]
  },
  {
    title: '实习管理',
    items: [{ label: '实习情况', routeName: 'teacher.internships', icon: BriefcaseBusiness }]
  },
  {
    title: '就业管理',
    items: [{ label: '就业情况', routeName: 'teacher.employment', icon: UsersRound }]
  },
  {
    title: '公告管理',
    items: [
      { label: '我的公告', routeName: 'teacher.announcements', icon: Megaphone },
      { label: '公告评论', routeName: 'teacher.announcementComments', icon: MessageSquareText },
      { label: '其他公告', routeName: 'teacher.otherAnnouncements', icon: Megaphone },
      { label: '我的评论', routeName: 'teacher.comments', icon: MessageSquareText }
    ]
  }
]
