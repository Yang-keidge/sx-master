import * as announcementApi from '../../../api/announcement'
import * as applicationApi from '../../../api/application'
import * as commentApi from '../../../api/comment'
import * as companyApi from '../../../api/company'
import * as discussionApi from '../../../api/discussion'
import * as discussionReplyApi from '../../../api/discussionReply'
import * as employmentApi from '../../../api/employment'
import * as internshipApi from '../../../api/internship'
import * as recruitmentApi from '../../../api/recruitment'
import * as studentApi from '../../../api/student'
import { formatStudentClass } from '../../../utils/student'

const industrySelect = { type: 'select', dictionary: 'qiye_types' }
const internshipTypeSelect = { type: 'select', dictionary: 'shixi_types' }
const internshipResultSelect = { type: 'select', dictionary: 'shixi_jieguo_types' }
const announcementTypeSelect = { type: 'select', dictionary: 'gonggao_types' }

const createTimeColumn = { prop: 'createTime', label: '创建时间', type: 'datetime', minWidth: 168 }

function field(prop, label, type = 'input', extra = {}) {
  return { prop, label, type, ...extra }
}

function dictionaryColumn(prop, label, dictionary, valueProp, extra = {}) {
  return { prop, label, dictionary, valueProp, ...extra }
}

async function loadStudentOptions() {
  const result = await studentApi.page({ page: 1, limit: 1000, orderBy: 'id' })
  return (result.data?.list || []).map((item) => ({
    label: `${item.xueshengName || item.username || '未命名'}（${item.xueshengXuehao || '-'}）`,
    value: item.id
  }))
}

async function loadAnnouncementOptions() {
  const result = await announcementApi.page({ page: 1, limit: 1000, orderBy: 'id' })
  return (result.data?.list || []).map((item) => ({
    label: `${item.gonggaoName || '未命名公告'}（${item.fabuzheRole || '未知'}）`,
    value: item.id
  }))
}

const companyProfileFields = [
  field('username', '账号', 'input', { required: true }),
  field('password', '密码', 'password', { required: true }),
  field('qiyeBianhao', '企业编号', 'input', { required: true }),
  field('qiyeName', '企业名称', 'input', { required: true }),
  field('qiyeAddress', '企业地址', 'input'),
  field('qiyePhoto', '企业图片', 'image'),
  field('qiyePhone', '联系方式', 'input', { required: true }),
  field('qiyeEmail', '企业邮箱', 'input', { required: true }),
  field('qiyeTypes', '所在行业', industrySelect.type, { dictionary: industrySelect.dictionary, required: true }),
  field('qiyeContent', '企业详情', 'richtext', { wide: true })
]

const internshipSearchFields = [
  field('xueshengName', '学生姓名'),
  field('xueshengXuehao', '学号'),
  field('shixiName', '实习名称'),
  field('shixiGangweiName', '实习岗位'),
  field('shixiTypes', '实习类型', internshipTypeSelect.type, { dictionary: internshipTypeSelect.dictionary }),
  field('shixiJieguoTypes', '实习结果', internshipResultSelect.type, {
    dictionary: internshipResultSelect.dictionary
  })
]

const internshipColumns = [
  field('xueshengPhoto', '头像', 'image', { fallbackProp: 'xueshengName', width: 72 }),
  field('xueshengName', '学生姓名', 'input', { minWidth: 120 }),
  field('xueshengXuehao', '学号', 'input', { minWidth: 128 }),
  dictionaryColumn('zhuanyeTypes', '专业', 'zhuanye_types', 'zhuanyeValue', { minWidth: 120 }),
  field('studentClass', '班级', 'input', {
    minWidth: 150,
    formatter: formatStudentClass
  }),
  field('shixiName', '实习名称', 'input', { minWidth: 180 }),
  dictionaryColumn('shixiTypes', '实习类型', 'shixi_types', 'shixiValue', { type: 'tag', minWidth: 116 }),
  field('shixiGangweiName', '实习岗位', 'input', { minWidth: 150 }),
  field('shixiKaishiTime', '开始日期', 'date', { width: 118 }),
  field('shixiJieshuTime', '结束日期', 'date', { width: 118 }),
  dictionaryColumn('shixiJieguoTypes', '实习结果', 'shixi_jieguo_types', 'shixiJieguoValue', {
    type: 'tag',
    minWidth: 116
  })
]

const internshipFormFields = [
  field('xueshengId', '学生', 'remoteSelect', { source: 'students', required: true }),
  field('shixiName', '实习名称', 'input', { required: true }),
  field('shixiTypes', '实习类型', internshipTypeSelect.type, {
    dictionary: internshipTypeSelect.dictionary,
    required: true
  }),
  field('shixiKaishiTime', '开始日期', 'date', { required: true }),
  field('shixiJieshuTime', '结束日期', 'date', { required: true }),
  field('shixiJieguoTypes', '实习结果', internshipResultSelect.type, {
    dictionary: internshipResultSelect.dictionary,
    required: true
  }),
  field('shixiGangweiName', '实习岗位', 'input', { required: true }),
  field('shixiContent', '实习详情', 'richtext', { wide: true })
]

const internshipDetailFields = [
  field('xueshengName', '学生姓名'),
  field('xueshengXuehao', '学号'),
  field('xueshengJianliFile', '学生简历', 'file'),
  dictionaryColumn('zhuanyeTypes', '专业', 'zhuanye_types', 'zhuanyeValue'),
  field('studentClass', '班级', 'input', { formatter: formatStudentClass }),
  field('xueshengPhone', '学生手机号'),
  field('xueshengEmail', '学生邮箱'),
  field('shixiName', '实习名称'),
  dictionaryColumn('shixiTypes', '实习类型', 'shixi_types', 'shixiValue'),
  field('shixiGangweiName', '实习岗位'),
  field('shixiKaishiTime', '开始日期', 'date'),
  field('shixiJieshuTime', '结束日期', 'date'),
  dictionaryColumn('shixiJieguoTypes', '实习结果', 'shixi_jieguo_types', 'shixiJieguoValue'),
  field('shixiContent', '实习详情', 'html'),
  createTimeColumn
]

const announcementFields = [
  field('gonggaoName', '公告标题', 'input', { required: true }),
  field('gonggaoTypes', '公告类型', announcementTypeSelect.type, {
    dictionary: announcementTypeSelect.dictionary,
    required: true
  }),
  field('insertTime', '公告发布日期', 'date'),
  field('gonggaoContent', '公告内容', 'richtext', { wide: true, required: true })
]

function myAnnouncements(params) {
  return {
    ...params,
    myOnly: 'true'
  }
}

function otherAnnouncements(params) {
  return {
    ...params,
    notMine: 'true'
  }
}

function myComments(params) {
  return {
    ...params,
    myOnly: 'true'
  }
}

function withCurrentCompany(payload) {
  const userId = getCurrentCompanyId()
  if (userId) {
    payload.qiyeId = Number(userId)
  }
  return payload
}

function formatRecruitmentProgress(row) {
  return `${Number(row.yizhaoRenshu || 0)}/${Number(row.zhaopinRenshu || 0)}个`
}

function formatRecruitmentStatus(row) {
  return Number(row.yizhaoRenshu || 0) >= Number(row.zhaopinRenshu || 0) ? '已招满' : '招聘中'
}

function formatDateText(date) {
  const year = date.getFullYear()
  const month = String(date.getMonth() + 1).padStart(2, '0')
  const day = String(date.getDate()).padStart(2, '0')
  return `${year}-${month}-${day}`
}

function parseDateText(value) {
  const text = String(value || '').trim()
  if (!/^\d{4}-\d{2}-\d{2}$/.test(text)) return null
  const [year, month, day] = text.split('-').map(Number)
  const date = new Date(year, month - 1, day)
  if (date.getFullYear() !== year || date.getMonth() !== month - 1 || date.getDate() !== day) return null
  return date
}

async function promptDate(ElMessageBox, title, message, inputValue, validator) {
  const result = await ElMessageBox.prompt(message, title, {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    inputValue,
    inputPlaceholder: 'YYYY-MM-DD',
    inputValidator(value) {
      const date = parseDateText(value)
      if (!date) return '请输入有效日期（YYYY-MM-DD）'
      return validator ? validator(String(value).trim(), date) : true
    }
  })
  return String(result.value || '').trim()
}

async function promptAcceptInternshipDates(row, { ElMessageBox }) {
  const studentName = row.xueshengName || '该学生'
  const positionName = row.zhaopinGangweiName || '该岗位'
  const startText = await promptDate(
    ElMessageBox,
    '实习开始日期',
    `录用 ${studentName} 到 ${positionName} 前，请填写实习开始日期。`,
    formatDateText(new Date())
  )
  const startDate = parseDateText(startText)
  const endText = await promptDate(
    ElMessageBox,
    '预计结束日期',
    '请填写预计实习结束日期。',
    '',
    (value, endDate) => (endDate < startDate ? '结束日期不能早于开始日期' : true)
  )

  return {
    shixiKaishiTime: startText,
    shixiJieshuTime: endText
  }
}

function getCurrentCompanyId() {
  try {
    return JSON.parse(localStorage.getItem('currentUser') || '{}').userId || ''
  } catch {
    return ''
  }
}

export const companyModuleConfigs = {
  profile: {
    title: '企业信息',
    subtitle: '维护企业基础资料、联系方式、行业与企业介绍。',
    entityName: '企业',
    api: companyApi,
    canCreate: false,
    canDelete: false,
    searchFields: [field('qiyeName', '企业名称'), field('qiyeBianhao', '企业编号')],
    columns: [
      field('qiyePhoto', '企业图片', 'image', { fallbackProp: 'qiyeName', width: 82 }),
      field('qiyeBianhao', '企业编号', 'input', { minWidth: 128 }),
      field('qiyeName', '企业名称', 'input', { minWidth: 180 }),
      dictionaryColumn('qiyeTypes', '行业', 'qiye_types', 'qiyeValue', { type: 'tag', minWidth: 120 }),
      field('qiyePhone', '联系方式', 'input', { minWidth: 132 }),
      field('qiyeEmail', '邮箱', 'input', { minWidth: 180 }),
      field('qiyeAddress', '企业地址', 'input', { minWidth: 180 }),
      createTimeColumn
    ],
    formFields: companyProfileFields,
    detailFields: [...companyProfileFields, createTimeColumn]
  },

  internships: {
    title: '实习管理',
    subtitle: '维护本企业实习学生、岗位、实习周期与实习结果。',
    entityName: '实习',
    api: internshipApi,
    optionLoaders: {
      students: loadStudentOptions
    },
    searchFields: internshipSearchFields,
    columns: internshipColumns,
    formFields: internshipFormFields,
    transformPayload: withCurrentCompany,
    detailFields: internshipDetailFields
  },

  employmentData: {
    title: '就业管理',
    subtitle: '维护本企业就业学生、岗位和入职日期数据。',
    entityName: '就业',
    api: employmentApi,
    canEdit: false,
    canDelete: false,
    optionLoaders: {
      students: loadStudentOptions
    },
    searchFields: [field('xueshengName', '学生姓名'), field('xueshengXuehao', '学号'), field('jiuyeGangweiName', '岗位')],
    columns: [
      field('xueshengPhoto', '头像', 'image', { fallbackProp: 'xueshengName', width: 72 }),
      field('xueshengName', '学生姓名', 'input', { minWidth: 120 }),
      field('xueshengXuehao', '学号', 'input', { minWidth: 128 }),
      dictionaryColumn('zhuanyeTypes', '专业', 'zhuanye_types', 'zhuanyeValue', { minWidth: 120 }),
      field('studentClass', '班级', 'input', {
        minWidth: 150,
        formatter: formatStudentClass
      }),
      field('jiuyeGangweiName', '入职岗位', 'input', { minWidth: 160 }),
      field('jiuyeKaishiTime', '入职日期', 'date', { width: 118 }),
      field('jiuyeContent', '就业备注', 'multiline', { minWidth: 220 }),
      createTimeColumn
    ],
    formFields: [
      field('xueshengId', '学生', 'remoteSelect', { source: 'students', required: true }),
      field('jiuyeGangweiName', '入职岗位', 'input', { required: true }),
      field('jiuyeKaishiTime', '入职日期', 'date', { required: true }),
      field('jiuyeContent', '就业备注', 'textarea', { wide: true, rows: 5 })
    ],
    transformPayload: withCurrentCompany,
    detailFields: [
      field('xueshengName', '学生姓名'),
      field('xueshengXuehao', '学号'),
      field('xueshengJianliFile', '学生简历', 'file'),
      dictionaryColumn('zhuanyeTypes', '专业', 'zhuanye_types', 'zhuanyeValue'),
      field('studentClass', '班级', 'input', { formatter: formatStudentClass }),
      field('xueshengPhone', '学生手机号'),
      field('xueshengEmail', '学生邮箱'),
      field('jiuyeGangweiName', '入职岗位'),
      field('jiuyeKaishiTime', '入职日期', 'date'),
      field('jiuyeContent', '就业备注', 'multiline'),
      createTimeColumn
    ]
  },

  recruitmentJobs: {
    title: '招聘岗位',
    subtitle: '发布并维护本企业招聘岗位、薪资范围、工作地址和招聘数量。',
    entityName: '招聘岗位',
    api: recruitmentApi,
    searchFields: [
      field('zhaopinGangweiName', '职位名称'),
      field('zhaopinLeixing', '职位类型'),
      field('gongzuoDizhi', '工作地址')
    ],
    columns: [
      field('zhaopinGangweiName', '职位名称', 'input', { minWidth: 160 }),
      field('zhaopinLeixing', '职位类型', 'input', { minWidth: 130 }),
      field('xinziFanwei', '薪资范围', 'input', { minWidth: 130 }),
      field('gongzuoDizhi', '工作地址', 'input', { minWidth: 180 }),
      field('zhaopinProgress', '已招到/招聘数量', 'input', { formatter: formatRecruitmentProgress, width: 144 }),
      field('zhaomanStatus', '状态', 'tag', { formatter: formatRecruitmentStatus, width: 96 }),
      createTimeColumn
    ],
    formFields: [
      field('zhaopinGangweiName', '职位名称', 'input', { required: true }),
      field('zhaopinLeixing', '职位类型', 'input', { required: true }),
      field('xinziFanwei', '薪资范围', 'input', { required: true }),
      field('gongzuoDizhi', '工作地址', 'input', { required: true }),
      field('zhaopinRenshu', '招聘数量', 'number', { required: true, min: 1 }),
      field('gongzuoYaoqiu', '工作要求', 'textarea', { wide: true, rows: 5, required: true })
    ],
    transformPayload: withCurrentCompany,
    detailFields: [
      field('qiyeName', '公司名称'),
      field('zhaopinGangweiName', '职位名称'),
      field('zhaopinLeixing', '职位类型'),
      field('xinziFanwei', '薪资范围'),
      field('gongzuoDizhi', '工作地址'),
      field('zhaopinProgress', '已招到/招聘数量', 'input', { formatter: formatRecruitmentProgress }),
      field('zhaomanStatus', '状态', 'input', { formatter: formatRecruitmentStatus }),
      field('gongzuoYaoqiu', '工作要求', 'multiline'),
      createTimeColumn
    ]
  },

  applications: {
    title: '应聘学生',
    subtitle: '查看应聘本企业岗位的学生信息、简历，并选择录用。',
    entityName: '应聘',
    api: applicationApi,
    canCreate: false,
    canEdit: false,
    canDelete: false,
    searchFields: [
      field('xueshengName', '学生姓名'),
      field('xueshengXuehao', '学号'),
      field('zhaopinGangweiName', '职位名称'),
      field('zhaopinLeixing', '职位类型')
    ],
    columns: [
      field('xueshengPhoto', '头像', 'image', { fallbackProp: 'xueshengName', width: 72 }),
      field('xueshengName', '学生姓名', 'input', { minWidth: 120 }),
      field('xueshengXuehao', '学号', 'input', { minWidth: 128 }),
      dictionaryColumn('zhuanyeTypes', '专业', 'zhuanye_types', 'zhuanyeValue', { minWidth: 120 }),
      field('studentClass', '班级', 'input', { minWidth: 150, formatter: formatStudentClass }),
      field('xueshengJianliFile', '学生简历', 'file', { width: 118 }),
      field('zhaopinGangweiName', '职位名称', 'input', { minWidth: 160 }),
      field('zhaopinLeixing', '职位类型', 'input', { minWidth: 120 }),
      field('yingpinStatus', '状态', 'tag', { width: 92 }),
      createTimeColumn
    ],
    rowActions: [
      {
        label: '录用',
        type: 'success',
        confirm: (row) => `确认录用 ${row.xueshengName || '该学生'} 到 ${row.zhaopinGangweiName || '该岗位'}？`,
        confirmButtonText: '确认录用',
        successMessage: '录用成功，已生成实习记录',
        handler: async (row, tools) => {
          const internshipDates = await promptAcceptInternshipDates(row, tools)
          await applicationApi.accept(row.id, internshipDates)
        }
      }
    ],
    formFields: [],
    detailFields: [
      field('xueshengName', '学生姓名'),
      field('xueshengXuehao', '学号'),
      dictionaryColumn('yuanxiTypes', '院系', 'yuanxi_types', 'yuanxiValue'),
      dictionaryColumn('zhuanyeTypes', '专业', 'zhuanye_types', 'zhuanyeValue'),
      field('studentClass', '班级', 'input', { formatter: formatStudentClass }),
      field('xueshengPhone', '学生手机号'),
      field('xueshengEmail', '学生邮箱'),
      field('xueshengJianliFile', '学生简历', 'file'),
      field('zhaopinGangweiName', '职位名称'),
      field('zhaopinLeixing', '职位类型'),
      field('xinziFanwei', '薪资范围'),
      field('gongzuoDizhi', '工作地址'),
      field('gongzuoYaoqiu', '工作要求', 'multiline'),
      field('yingpinStatus', '应聘状态'),
      createTimeColumn
    ]
  },

  announcements: {
    title: '招聘公告',
    subtitle: '发布和维护本企业招聘、实习推荐类公告。',
    entityName: '公告',
    api: announcementApi,
    commentable: true,
    batchDeleteOnly: true,
    transformSearch: myAnnouncements,
    searchFields: [
      field('gonggaoName', '公告标题'),
      field('gonggaoTypes', '公告类型', announcementTypeSelect.type, { dictionary: announcementTypeSelect.dictionary })
    ],
    columns: [
      field('gonggaoName', '公告标题', 'input', { minWidth: 240 }),
      dictionaryColumn('gonggaoTypes', '公告类型', 'gonggao_types', 'gonggaoValue', { type: 'tag', minWidth: 116 }),
      field('commentCount', '评论数', 'input', { width: 96 }),
      field('insertTime', '发布日期', 'datetime', { minWidth: 168 }),
      createTimeColumn
    ],
    formFields: announcementFields,
    detailFields: [
      field('gonggaoName', '公告标题'),
      dictionaryColumn('gonggaoTypes', '公告类型', 'gonggao_types', 'gonggaoValue'),
      field('fabuzheName', '发布企业'),
      field('insertTime', '发布日期', 'datetime'),
      field('commentCount', '评论数量'),
      field('gonggaoContent', '公告内容', 'html'),
      createTimeColumn
    ]
  },

  otherAnnouncements: {
    title: '其他公告',
    subtitle: '查看其他老师、企业和管理员发布的公告信息，仅支持查看与评论。',
    entityName: '公告',
    api: announcementApi,
    commentable: true,
    canCreate: false,
    canEdit: false,
    canDelete: false,
    transformSearch: otherAnnouncements,
    searchFields: [
      field('gonggaoName', '公告标题'),
      field('gonggaoTypes', '公告类型', announcementTypeSelect.type, { dictionary: announcementTypeSelect.dictionary }),
      field('fabuzheName', '发布者名称')
    ],
    columns: [
      field('gonggaoName', '公告标题', 'input', { minWidth: 240 }),
      dictionaryColumn('gonggaoTypes', '公告类型', 'gonggao_types', 'gonggaoValue', { type: 'tag', minWidth: 116 }),
      field('fabuzheRole', '发布者身份', 'input', { minWidth: 116 }),
      field('fabuzheName', '发布者名称', 'input', { minWidth: 140 }),
      field('commentCount', '评论数', 'input', { width: 96 }),
      field('insertTime', '发布日期', 'datetime', { minWidth: 168 }),
      createTimeColumn
    ],
    formFields: [],
    detailFields: [
      field('gonggaoName', '公告标题'),
      dictionaryColumn('gonggaoTypes', '公告类型', 'gonggao_types', 'gonggaoValue'),
      field('fabuzheRole', '发布者身份'),
      field('fabuzheName', '发布者名称'),
      field('insertTime', '发布日期', 'datetime'),
      field('commentCount', '评论数量'),
      field('gonggaoContent', '公告内容', 'html'),
      createTimeColumn
    ]
  },

  comments: {
    title: '公告评论',
    subtitle: '查看和维护当前企业账号发表的公告评论。',
    entityName: '评论',
    api: commentApi,
    optionLoaders: {
      announcements: loadAnnouncementOptions
    },
    transformSearch: myComments,
    searchFields: [field('gonggaoName', '公告标题'), field('gonggaoCommentContent', '评论内容')],
    columns: [
      field('gonggaoName', '公告标题', 'input', { minWidth: 220 }),
      field('pinglunrenName', '评论人名称', 'input', { minWidth: 150 }),
      field('gonggaoCommentContent', '评论内容', 'multiline', { minWidth: 360 }),
      createTimeColumn
    ],
    formFields: [
      field('gonggaoId', '公告', 'remoteSelect', { source: 'announcements', required: true, disabledOnEdit: true }),
      field('gonggaoCommentContent', '评论内容', 'textarea', { wide: true, rows: 5, required: true })
    ],
    detailFields: [
      field('gonggaoName', '公告标题'),
      field('pinglunrenName', '评论人名称'),
      field('pinglunrenRole', '评论人身份'),
      field('gonggaoCommentContent', '评论内容', 'multiline'),
      createTimeColumn
    ]
  },

  discussions: {
    title: '讨论区',
    subtitle: '发布实习岗位、招聘和企业指导相关交流帖，并回复学生问题。',
    entityName: '帖子',
    api: discussionApi,
    commentable: true,
    commentsApi: discussionReplyApi,
    commentParentParam: 'taolunId',
    commentPayloadParentField: 'taolunId',
    commentTitleProp: 'taolunTitle',
    commentAuthorNameProp: 'huifurenName',
    commentAuthorRoleProp: 'huifurenRole',
    commentContentProp: 'huifuContent',
    commentCountProp: 'replyCount',
    commentDialogTitle: '讨论回复',
    commentListActionLabel: '查看回复',
    commentActionLabel: '回复',
    commentEmptyText: '暂无回复',
    commentPlaceholder: '请输入回复内容',
    commentSuccessMessage: '回复成功',
    orderBy: 'create_time',
    canEdit: false,
    canDelete: false,
    searchFields: [field('taolunTitle', '帖子标题'), field('fabuzheName', '发布者名称')],
    columns: [
      field('taolunTitle', '帖子标题', 'input', { minWidth: 260 }),
      field('fabuzheName', '发布者名称', 'input', { minWidth: 140 }),
      field('fabuzheRole', '发布者身份', 'input', { minWidth: 116 }),
      field('replyCount', '回复数', 'input', { width: 96 }),
      createTimeColumn
    ],
    formFields: [
      field('taolunTitle', '帖子标题', 'input', { required: true }),
      field('taolunContent', '帖子内容', 'richtext', { wide: true, required: true })
    ],
    detailFields: [
      field('taolunTitle', '帖子标题'),
      field('fabuzheName', '发布者名称'),
      field('fabuzheRole', '发布者身份'),
      field('replyCount', '回复数量'),
      field('taolunContent', '帖子内容', 'html'),
      createTimeColumn
    ]
  }
}
