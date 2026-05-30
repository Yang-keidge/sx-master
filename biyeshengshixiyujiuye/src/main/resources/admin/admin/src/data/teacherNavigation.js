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
    title: '学生业务',
    items: [
      { label: '学生管理', routeName: 'teacher.students', icon: UsersRound },
      { label: '实习情况', routeName: 'teacher.internships', icon: BriefcaseBusiness }
    ]
  },
  {
    title: '内容互动',
    items: [
      { label: '我的公告', routeName: 'teacher.announcements', icon: Megaphone },
      { label: '其他公告', routeName: 'teacher.otherAnnouncements', icon: Megaphone },
      { label: '我的评论', routeName: 'teacher.comments', icon: MessageSquareText },
      { label: '讨论区', routeName: 'teacher.discussions', icon: MessageSquareText },
      { label: '问题解答', routeName: 'teacher.questions', icon: MessageSquareText }
    ]
  },
  {
    title: '个人设置',
    items: [
      { label: '个人信息', routeName: 'teacher.profile', icon: UserRound },
      { label: '修改密码', routeName: 'teacher.password', icon: LockKeyhole }
    ]
  }
]
