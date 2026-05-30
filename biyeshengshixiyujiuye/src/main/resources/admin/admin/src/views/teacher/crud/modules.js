import * as announcementApi from '../../../api/announcement'
import * as commentApi from '../../../api/comment'
import * as discussionApi from '../../../api/discussion'
import * as discussionReplyApi from '../../../api/discussionReply'
import * as internshipApi from '../../../api/internship'
import * as questionApi from '../../../api/question'
import * as studentApi from '../../../api/student'
import * as teacherApi from '../../../api/teacher'
import { formatStudentClass } from '../../../utils/student'

const sexSelect = { type: 'select', dictionary: 'sex_types' }
const yuanxiSelect = { type: 'select', dictionary: 'yuanxi_types' }
const zhuanyeSelect = { type: 'select', dictionary: 'zhuanye_types' }
const banjiSelect = { type: 'select', dictionary: 'banji_types' }
const internshipTypeSelect = { type: 'select', dictionary: 'shixi_types' }
const internshipResultSelect = { type: 'select', dictionary: 'shixi_jieguo_types' }
const announcementTypeSelect = { type: 'select', dictionary: 'gonggao_types' }
const createTimeColumn = { prop: 'createTime', label: '创建时间', type: 'datetime', minWidth: 168 }
const questionStatusOptions = [
  { label: '未回复', value: '未回复' },
  { label: '已回复', value: '已回复' }
]

const graduationOptions = [
  { label: '已毕业', value: 'graduated' },
  { label: '未毕业', value: 'notGraduated' }
]

const majorClassMap = {
  1: [1, 7],
  2: [2, 11],
  3: [3, 8],
  4: [4],
  5: [5],
  6: [6],
  7: [9],
  8: [10]
}

const userPasswordField = {
  prop: 'password',
  label: '密码',
  type: 'password',
  default: '123456',
  required: true
}

let teacherProfile = null

function field(prop, label, type = 'input', extra = {}) {
  return { prop, label, type, ...extra }
}

function dictionaryColumn(prop, label, dictionary, valueProp, extra = {}) {
  return { prop, label, dictionary, valueProp, ...extra }
}

function filterClassByMajor(option, model) {
  const majorId = model.zhuanyeTypes
  if (!majorId) return false
  const parentId = option.raw?.superId
  if (parentId !== null && parentId !== undefined && parentId !== '') {
    return String(parentId) === String(majorId)
  }
  return (majorClassMap[majorId] || []).some((classId) => String(classId) === String(option.value))
}

function classNeedsMajor(model) {
  return !model.zhuanyeTypes
}

async function ensureTeacherProfile() {
  if (teacherProfile) return teacherProfile
  const result = await teacherApi.session()
  teacherProfile = result.data || {}
  return teacherProfile
}

async function loadAnnouncementOptions() {
  const result = await announcementApi.page({ page: 1, limit: 1000, orderBy: 'id' })
  return (result.data?.list || []).map((item) => ({
    label: `${item.gonggaoName || '未命名公告'}（${item.fabuzheRole || '未知'}）`,
    value: item.id
  }))
}

async function prepareStudentCreate(form) {
  const profile = await ensureTeacherProfile()
  form.yuanxiTypes = profile.yuanxiTypes || ''
  form.zhuanyeTypes = profile.zhuanyeTypes || ''
}

function withTeacherMajor(payload) {
  if (teacherProfile?.yuanxiTypes) {
    payload.yuanxiTypes = teacherProfile.yuanxiTypes
  }
  if (teacherProfile?.zhuanyeTypes) {
    payload.zhuanyeTypes = teacherProfile.zhuanyeTypes
  }
  return payload
}

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

function receivedComments(params) {
  return {
    ...params,
    receivedOnly: 'true'
  }
}

function myComments(params) {
  return {
    ...params,
    myOnly: 'true'
  }
}

const teacherStudentFields = [
  field('username', '账号', 'input', { required: true }),
  userPasswordField,
  field('xueshengXuehao', '学号', 'input', { required: true }),
  field('xueshengName', '姓名', 'input', { required: true }),
  field('xueshengPhone', '手机号', 'input', { required: true }),
  field('xueshengIdNumber', '身份证号', 'input', { required: true }),
  field('xueshengPhoto', '头像', 'image'),
  field('xueshengJianliFile', '学生简历', 'file'),
  field('sexTypes', '性别', sexSelect.type, { dictionary: sexSelect.dictionary, required: true }),
  field('yuanxiTypes', '院系', yuanxiSelect.type, {
    dictionary: yuanxiSelect.dictionary,
    required: true,
    disabled: true
  }),
  field('zhuanyeTypes', '专业', zhuanyeSelect.type, {
    dictionary: zhuanyeSelect.dictionary,
    required: true,
    disabled: true
  }),
  field('banjiTypes', '班级', banjiSelect.type, {
    dictionary: banjiSelect.dictionary,
    optionFilter: filterClassByMajor,
    disabledWhen: classNeedsMajor,
    disabledHint: '请先确认专业',
    required: true
  }),
  field('ruxueYear', '入学年份', 'year', { required: true }),
  field('xueshengEmail', '邮箱', 'input')
]

const studentColumns = [
  field('xueshengPhoto', '头像', 'image', { fallbackProp: 'xueshengName', width: 72 }),
  field('xueshengXuehao', '学号', 'input', { minWidth: 128 }),
  field('xueshengName', '姓名', 'input', { minWidth: 110 }),
  dictionaryColumn('sexTypes', '性别', 'sex_types', 'sexValue', { type: 'tag', width: 92 }),
  field('xueshengPhone', '手机号', 'input', { minWidth: 140 }),
  dictionaryColumn('yuanxiTypes', '院系', 'yuanxi_types', 'yuanxiValue', { type: 'tag', minWidth: 120 }),
  dictionaryColumn('zhuanyeTypes', '专业', 'zhuanye_types', 'zhuanyeValue', { minWidth: 120 }),
  field('studentClass', '班级', 'input', { minWidth: 150, formatter: formatStudentClass }),
  field('ruxueYear', '入学年份', 'input', { width: 108 }),
  field('xueshengEmail', '邮箱', 'input', { minWidth: 180 })
]

const internshipColumns = [
  field('xueshengPhoto', '头像', 'image', { fallbackProp: 'xueshengName', width: 72 }),
  field('xueshengName', '学生姓名', 'input', { minWidth: 120 }),
  field('xueshengXuehao', '学号', 'input', { minWidth: 128 }),
  field('studentClass', '班级', 'input', { minWidth: 150, formatter: formatStudentClass }),
  field('qiyeName', '企业名称', 'input', { minWidth: 180 }),
  field('shixiName', '实习名称', 'input', { minWidth: 180 }),
  dictionaryColumn('shixiTypes', '实习类型', 'shixi_types', 'shixiValue', { type: 'tag', minWidth: 116 }),
  field('shixiGangweiName', '实习岗位', 'input', { minWidth: 150 }),
  field('shixiKaishiTime', '开始日期', 'date', { width: 118 }),
  field('shixiJieshuTime', '结束日期', 'date', { width: 118 }),
  dictionaryColumn('shixiJieguoTypes', '实习结果', 'shixi_jieguo_types', 'shixiJieguoValue', {
    type: 'tag',
    minWidth: 116
  }),
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

const announcementColumns = [
  field('gonggaoName', '公告标题', 'input', { minWidth: 240 }),
  dictionaryColumn('gonggaoTypes', '公告类型', 'gonggao_types', 'gonggaoValue', { type: 'tag', minWidth: 116 }),
  field('fabuzheRole', '发布者身份', 'input', { minWidth: 116 }),
  field('fabuzheName', '发布者名称', 'input', { minWidth: 140 }),
  field('commentCount', '评论数', 'input', { width: 96 }),
  field('insertTime', '发布日期', 'datetime', { minWidth: 168 })
]

export const teacherModuleConfigs = {
  students: {
    title: '学生管理',
    subtitle: '查看并维护当前教师所属专业的学生信息，新增学生默认归属当前专业。',
    entityName: '学生',
    api: studentApi,
    canDelete: false,
    searchFields: [
      field('xueshengXuehao', '学号'),
      field('xueshengName', '姓名'),
      field('xueshengPhone', '手机号'),
      field('banjiTypes', '班级', banjiSelect.type, { dictionary: banjiSelect.dictionary }),
      field('ruxueYear', '入学年份', 'year'),
      field('graduationStatus', '毕业状态', 'select', { options: graduationOptions })
    ],
    columns: studentColumns,
    formFields: teacherStudentFields,
    prepareCreate: prepareStudentCreate,
    transformPayload: withTeacherMajor,
    detailFields: [...teacherStudentFields, createTimeColumn]
  },

  internships: {
    title: '实习情况',
    subtitle: '只读查看当前教师所属专业学生的实习企业、岗位、周期和实习结果。',
    entityName: '实习',
    api: internshipApi,
    canCreate: false,
    canEdit: false,
    canDelete: false,
    searchFields: [
      field('xueshengName', '学生姓名'),
      field('xueshengXuehao', '学号'),
      field('qiyeName', '企业名称'),
      field('shixiName', '实习名称'),
      field('shixiTypes', '实习类型', internshipTypeSelect.type, { dictionary: internshipTypeSelect.dictionary }),
      field('shixiJieguoTypes', '实习结果', internshipResultSelect.type, {
        dictionary: internshipResultSelect.dictionary
      })
    ],
    columns: internshipColumns,
    formFields: [],
    detailFields: [
      field('xueshengName', '学生姓名'),
      field('xueshengXuehao', '学号'),
      field('xueshengJianliFile', '学生简历', 'file'),
      dictionaryColumn('yuanxiTypes', '院系', 'yuanxi_types', 'yuanxiValue'),
      dictionaryColumn('zhuanyeTypes', '专业', 'zhuanye_types', 'zhuanyeValue'),
      field('studentClass', '班级', 'input', { formatter: formatStudentClass }),
      field('qiyeName', '企业名称'),
      field('qiyeAddress', '企业地址'),
      field('qiyePhone', '企业电话'),
      field('shixiName', '实习名称'),
      dictionaryColumn('shixiTypes', '实习类型', 'shixi_types', 'shixiValue'),
      field('shixiGangweiName', '实习岗位'),
      field('shixiKaishiTime', '开始日期', 'date'),
      field('shixiJieshuTime', '结束日期', 'date'),
      dictionaryColumn('shixiJieguoTypes', '实习结果', 'shixi_jieguo_types', 'shixiJieguoValue'),
      field('shixiContent', '实习详情', 'html'),
      createTimeColumn
    ]
  },

  announcements: {
    title: '我的公告',
    subtitle: '发布并维护当前教师账号的实习和教学通知公告。',
    entityName: '公告',
    api: announcementApi,
    commentable: true,
    batchDeleteOnly: true,
    transformSearch: myAnnouncements,
    searchFields: [
      field('gonggaoName', '公告标题'),
      field('gonggaoTypes', '公告类型', announcementTypeSelect.type, { dictionary: announcementTypeSelect.dictionary })
    ],
    columns: announcementColumns,
    formFields: announcementFields,
    detailFields: [
      field('gonggaoName', '公告标题'),
      dictionaryColumn('gonggaoTypes', '公告类型', 'gonggao_types', 'gonggaoValue'),
      field('fabuzheName', '发布教师'),
      field('insertTime', '发布日期', 'datetime'),
      field('commentCount', '评论数量'),
      field('gonggaoContent', '公告内容', 'html'),
      createTimeColumn
    ]
  },

  announcementComments: {
    title: '公告评论',
    subtitle: '只读查看别人对我发布公告的评论。',
    entityName: '评论',
    api: commentApi,
    canCreate: false,
    canEdit: false,
    canDelete: false,
    transformSearch: receivedComments,
    searchFields: [field('gonggaoName', '公告标题'), field('pinglunrenName', '评论人'), field('gonggaoCommentContent', '评论内容')],
    columns: [
      field('gonggaoName', '公告标题', 'input', { minWidth: 220 }),
      field('pinglunrenName', '评论人名称', 'input', { minWidth: 140 }),
      field('pinglunrenRole', '评论人身份', 'input', { minWidth: 116 }),
      field('gonggaoCommentContent', '评论内容', 'multiline', { minWidth: 360 }),
      createTimeColumn
    ],
    formFields: [],
    detailFields: [
      field('gonggaoName', '公告标题'),
      field('pinglunrenName', '评论人名称'),
      field('pinglunrenRole', '评论人身份'),
      field('gonggaoCommentContent', '评论内容', 'multiline'),
      createTimeColumn
    ]
  },

  comments: {
    title: '我的评论',
    subtitle: '对公告发布评论，并维护当前教师账号发表过的评论内容。',
    entityName: '评论',
    api: commentApi,
    optionLoaders: {
      announcements: loadAnnouncementOptions
    },
    transformSearch: myComments,
    searchFields: [field('gonggaoName', '公告标题'), field('gonggaoCommentContent', '评论内容')],
    columns: [
      field('gonggaoName', '公告标题', 'input', { minWidth: 240 }),
      field('pinglunrenName', '评论人名称', 'input', { minWidth: 140 }),
      field('gonggaoCommentContent', '评论内容', 'multiline', { minWidth: 380 }),
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

  otherAnnouncements: {
    title: '其他公告',
    subtitle: '查看其他老师、企业和管理员发布的公告信息。',
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
    columns: announcementColumns,
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

  discussions: {
    title: '讨论区',
    subtitle: '发布实习指导交流帖，并参与学生、企业和老师之间的讨论回复。',
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
  },

  questions: {
    title: '问题解答',
    subtitle: '查看本专业学生提交给我的答疑问题，并在线回复。',
    entityName: '问题',
    api: questionApi,
    canCreate: false,
    canDelete: false,
    orderBy: 'create_time',
    searchFields: [
      field('xueshengName', '学生姓名'),
      field('xueshengXuehao', '学号'),
      field('wentiTitle', '问题标题'),
      field('wentiStatus', '回复状态', 'select', { options: questionStatusOptions })
    ],
    columns: [
      field('xueshengName', '学生姓名', 'input', { minWidth: 120 }),
      field('xueshengXuehao', '学号', 'input', { minWidth: 128 }),
      field('studentClass', '班级', 'input', { minWidth: 150, formatter: formatStudentClass }),
      field('wentiTitle', '问题标题', 'input', { minWidth: 240 }),
      field('wentiStatus', '回复状态', 'tag', { width: 96 }),
      field('huifuTime', '回复时间', 'datetime', { minWidth: 168 }),
      createTimeColumn
    ],
    formFields: [
      field('huifuContent', '回复内容', 'textarea', { wide: true, rows: 5, required: true })
    ],
    detailFields: [
      field('xueshengName', '学生姓名'),
      field('xueshengXuehao', '学号'),
      dictionaryColumn('yuanxiTypes', '院系', 'yuanxi_types', 'yuanxiValue'),
      dictionaryColumn('zhuanyeTypes', '专业', 'zhuanye_types', 'zhuanyeValue'),
      field('studentClass', '班级', 'input', { formatter: formatStudentClass }),
      field('laoshiName', '答疑老师'),
      field('wentiTitle', '问题标题'),
      field('wentiStatus', '回复状态'),
      field('wentiContent', '问题内容', 'multiline'),
      field('huifuLaoshiName', '回复老师'),
      field('huifuTime', '回复时间', 'datetime'),
      field('huifuContent', '回复内容', 'multiline'),
      createTimeColumn
    ]
  }
}
