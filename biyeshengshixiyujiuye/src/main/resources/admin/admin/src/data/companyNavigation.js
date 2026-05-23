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
    title: '企业管理',
    items: [
      { label: '企业信息', routeName: 'company.profile', icon: Building2 },
      { label: '实习管理', routeName: 'company.internships', icon: UsersRound },
      { label: '就业管理', routeName: 'company.employmentData', icon: BriefcaseBusiness },
      { label: '招聘公告', routeName: 'company.announcements', icon: Megaphone }
    ]
  },
  {
    title: '互动交流',
    items: [{ label: '公告评论', routeName: 'company.comments', icon: MessageSquareText }]
  }
]
