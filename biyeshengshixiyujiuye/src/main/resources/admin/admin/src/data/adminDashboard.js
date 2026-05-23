import {
  BadgeCheck,
  BriefcaseBusiness,
  Building2,
  ChartPie,
  GraduationCap,
  UserRound
} from 'lucide-vue-next'

export const statCards = [
  {
    label: '学生总数',
    value: '5,892',
    change: '+ 120',
    direction: 'up',
    icon: UserRound,
    tone: 'blue'
  },
  {
    label: '企业总数',
    value: '1,256',
    change: '+ 23',
    direction: 'up',
    icon: Building2,
    tone: 'green'
  },
  {
    label: '教师总数',
    value: '328',
    change: '+ 5',
    direction: 'up',
    icon: GraduationCap,
    tone: 'purple'
  },
  {
    label: '实习学生数',
    value: '2,458',
    change: '+ 198',
    direction: 'up',
    icon: BriefcaseBusiness,
    tone: 'sky'
  },
  {
    label: '就业学生数',
    value: '1,632',
    change: '+ 156',
    direction: 'up danger',
    icon: BadgeCheck,
    tone: 'orange'
  },
  {
    label: '就业率（已毕业）',
    value: '78.42%',
    change: '+ 3.21%',
    direction: 'up',
    icon: ChartPie,
    tone: 'blue'
  }
]

export const internshipTypeDistribution = [
  { label: '专业实习', value: '35.6%', color: '#3f5fff' },
  { label: '毕业实习', value: '28.4%', color: '#7185f6' },
  { label: '认识实习', value: '18.2%', color: '#58d2ae' },
  { label: '生产实习', value: '10.7%', color: '#b8dce9' },
  { label: '其他', value: '7.1%', color: '#b8c1d3' }
]

export const internshipResultDistribution = [
  { label: '优秀', value: '28.7%', color: '#3f5fff' },
  { label: '良好', value: '31.4%', color: '#7185f6' },
  { label: '合格', value: '25.6%', color: '#58d2ae' },
  { label: '不合格', value: '9.8%', color: '#b8dce9' },
  { label: '其他', value: '4.5%', color: '#b8c1d3' }
]

export const internshipRecords = [
  ['张三', '2021001001', '/api/upload/xuesheng1.jpg', '腾讯科技有限公司', '后端开发实习生', '2025-03-01', '进行中'],
  ['李四', '2021001002', '/api/upload/xuesheng2.jpg', '字节跳动科技有限公司', '产品实习生', '2025-02-20', '进行中'],
  ['王五', '2021001003', '/api/upload/xuesheng3.jpg', '阿里巴巴集团', '运营实习生', '2025-03-10', '进行中'],
  ['赵六', '2021001004', '/api/upload/xuesheng1.jpg', '华为技术有限公司', '测试实习生', '2025-03-05', '进行中'],
  ['孙七', '2021001005', '/api/upload/xuesheng2.jpg', '美团科技有限公司', '数据分析实习生', '2025-02-28', '进行中']
]

export const employmentRecords = [
  ['张三', '2021001001', '/api/upload/xuesheng1.jpg', '腾讯科技有限公司', '后端开发工程师', '2025-03-01'],
  ['李四', '2021001002', '/api/upload/xuesheng2.jpg', '字节跳动科技有限公司', '产品经理', '2025-02-20'],
  ['王五', '2021001003', '/api/upload/xuesheng3.jpg', '阿里巴巴集团', '运营专员', '2025-03-10'],
  ['赵六', '2021001004', '/api/upload/xuesheng1.jpg', '华为技术有限公司', '测试工程师', '2025-03-05'],
  ['孙七', '2021001005', '/api/upload/xuesheng2.jpg', '美团科技有限公司', '数据分析师', '2025-02-28']
]

export const chartMonths = ['1月', '2月', '3月', '4月', '5月', '6月', '7月', '8月', '9月', '10月', '11月', '12月']
