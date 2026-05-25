import {
  BriefcaseBusiness,
  Building2,
  Home,
  Megaphone,
  MessageSquareText,
  UsersRound
} from 'lucide-vue-next'

export const companySidebarSections = [
  {
    title: '',
    items: [{ label: '首页', routeName: 'company.dashboard', icon: Home }]
  },
  {
    title: '招聘实习',
    items: [
      { label: '招聘岗位', routeName: 'company.recruitmentJobs', icon: BriefcaseBusiness },
      { label: '应聘学生', routeName: 'company.applications', icon: UsersRound },
      { label: '实习管理', routeName: 'company.internships', icon: UsersRound }
    ]
  },
  {
    title: '就业公告',
    items: [
      { label: '就业管理', routeName: 'company.employmentData', icon: BriefcaseBusiness },
      { label: '招聘公告', routeName: 'company.announcements', icon: Megaphone },
      { label: '其他公告', routeName: 'company.otherAnnouncements', icon: Megaphone }
    ]
  },
  {
    title: '互动交流',
    items: [
      { label: '讨论区', routeName: 'company.discussions', icon: MessageSquareText },
      { label: '公告评论', routeName: 'company.comments', icon: MessageSquareText }
    ]
  },
  {
    title: '企业设置',
    items: [
      { label: '企业信息', routeName: 'company.profile', icon: Building2 }
    ]
  }
]
