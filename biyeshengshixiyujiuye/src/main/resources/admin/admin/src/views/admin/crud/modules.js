import * as announcementApi from '../../../api/announcement'
import * as commentApi from '../../../api/comment'
import * as companyApi from '../../../api/company'
import * as configApi from '../../../api/config'
import * as dictionaryApi from '../../../api/dictionary'
import * as employmentApi from '../../../api/employment'
import * as internshipApi from '../../../api/internship'
import * as studentApi from '../../../api/student'
import * as teacherApi from '../../../api/teacher'

const sexSelect = { type: 'select', dictionary: 'sex_types' }
const yuanxiSelect = { type: 'select', dictionary: 'yuanxi_types' }
const banjiSelect = { type: 'select', dictionary: 'banji_types' }
const industrySelect = { type: 'select', dictionary: 'qiye_types' }
const internshipTypeSelect = { type: 'select', dictionary: 'shixi_types' }
const internshipResultSelect = { type: 'select', dictionary: 'shixi_jieguo_types' }
const announcementTypeSelect = { type: 'select', dictionary: 'gonggao_types' }

const roleOptions = [
  { label: '管理员', value: '管理员' },
  { label: '学生', value: '学生' },
  { label: '老师', value: '老师' },
  { label: '企业', value: '企业' }
]

const graduationOptions = [
  { label: '已毕业', value: 'graduated' },
  { label: '未毕业', value: 'notGraduated' }
]

const internshipStatusOptions = [
  { label: '有实习记录', value: 'in' },
  { label: '无实习记录', value: 'notIn' }
]

const dictionaryTypeOptions = [
  { label: '性别类型', value: 'sex_types', dicName: '性别类型' },
  { label: '院系', value: 'yuanxi_types', dicName: '院系' },
  { label: '班级', value: 'banji_types', dicName: '班级' },
  { label: '公告类型', value: 'gonggao_types', dicName: '公告类型' },
  { label: '企业行业', value: 'qiye_types', dicName: '行业' },
  { label: '实习类型', value: 'shixi_types', dicName: '实习信息类型' },
  { label: '实习结果', value: 'shixi_jieguo_types', dicName: '实习结果' }
]

const departmentClassMap = {
  1: [1, 2, 7, 11],
  2: [3, 6, 8],
  3: [4, 10],
  4: [5, 9]
}

const createTimeColumn = { prop: 'createTime', label: '创建时间', type: 'datetime', minWidth: 168 }

const userPasswordField = {
  prop: 'password',
  label: '密码',
  type: 'password',
  default: '123456',
  required: true
}

function field(prop, label, type = 'input', extra = {}) {
  return { prop, label, type, ...extra }
}

function dictionaryColumn(prop, label, dictionary, valueProp, extra = {}) {
  return { prop, label, dictionary, valueProp, ...extra }
}

function filterClassByDepartment(option, model) {
  const departmentId = model.yuanxiTypes
  if (!departmentId) return false
  const parentId = option.raw?.superId
  if (parentId !== null && parentId !== undefined && parentId !== '') {
    return String(parentId) === String(departmentId)
  }
  return (departmentClassMap[departmentId] || []).some((classId) => String(classId) === String(option.value))
}

function classNeedsDepartment(model) {
  return !model.yuanxiTypes
}

function clearClassWhenDepartmentChanges({ form }) {
  if (form.banjiTypes) {
    form.banjiTypes = ''
  }
}

function findDictionaryType(dicCode) {
  return dictionaryTypeOptions.find((item) => item.value === dicCode)
}

function isClassDictionary(form) {
  return form.dicCode === 'banji_types'
}

async function handleDictionaryTypeChange({ form }) {
  const dictionaryType = findDictionaryType(form.dicCode)
  form.dicName = dictionaryType?.dicName || ''
  form.superId = isClassDictionary(form) ? form.superId || '' : null
  await fillNextCodeIndex(form)
}

function normalizeDictionaryPayload(payload) {
  const dictionaryType = findDictionaryType(payload.dicCode)
  if (dictionaryType) {
    payload.dicName = dictionaryType.dicName
  }
  if (payload.dicCode !== 'banji_types') {
    payload.superId = null
  }
  return payload
}

async function loadStudentOptions() {
  const result = await studentApi.page({ page: 1, limit: 1000, orderBy: 'id' })
  return (result.data?.list || []).map((item) => ({
    label: `${item.xueshengName || item.username || '未命名'}（${item.xueshengXuehao || '-'}）`,
    value: item.id
  }))
}

async function loadCompanyOptions() {
  const result = await companyApi.page({ page: 1, limit: 1000, orderBy: 'id' })
  return (result.data?.list || []).map((item) => ({
    label: item.qiyeName || item.qiyeBianhao || '未命名企业',
    value: item.id
  }))
}

async function fillNextCodeIndex(form) {
  if (!form.dicCode) {
    form.codeIndex = ''
    return
  }

  try {
    const result = await dictionaryApi.maxCodeIndex(form.dicCode)
    form.codeIndex = result.maxCodeIndex || 1
  } catch {
    form.codeIndex = 1
  }
}

const studentFields = [
  field('username', '账号', 'input', { required: true }),
  userPasswordField,
  field('xueshengXuehao', '学号', 'input', { required: true }),
  field('xueshengName', '姓名', 'input', { required: true }),
  field('xueshengPhone', '手机号', 'input', { required: true }),
  field('xueshengIdNumber', '身份证号', 'input', { required: true }),
  field('xueshengPhoto', '头像', 'image'),
  field('sexTypes', '性别', sexSelect.type, { dictionary: sexSelect.dictionary, required: true }),
  field('yuanxiTypes', '院系', yuanxiSelect.type, {
    dictionary: yuanxiSelect.dictionary,
    required: true,
    onChange: clearClassWhenDepartmentChanges
  }),
  field('banjiTypes', '班级', banjiSelect.type, {
    dictionary: banjiSelect.dictionary,
    optionFilter: filterClassByDepartment,
    disabledWhen: classNeedsDepartment,
    disabledHint: '请先选择院系',
    required: true
  }),
  field('ruxueYear', '入学年份', 'year', { required: true }),
  field('xueshengEmail', '邮箱', 'input')
]

const teacherFields = [
  field('username', '账号', 'input', { required: true }),
  userPasswordField,
  field('laoshiGonghao', '工号', 'input', { required: true }),
  field('laoshiName', '姓名', 'input', { required: true }),
  field('laoshiPhone', '手机号', 'input', { required: true }),
  field('laoshiIdNumber', '身份证号', 'input', { required: true }),
  field('laoshiPhoto', '头像', 'image'),
  field('sexTypes', '性别', sexSelect.type, { dictionary: sexSelect.dictionary, required: true }),
  field('yuanxiTypes', '院系', yuanxiSelect.type, { dictionary: yuanxiSelect.dictionary, required: true }),
  field('laoshiEmail', '邮箱', 'input')
]

const companyFields = [
  field('username', '账号', 'input', { required: true }),
  userPasswordField,
  field('qiyeBianhao', '企业编号', 'input', { required: true }),
  field('qiyeName', '企业名称', 'input', { required: true }),
  field('qiyeAddress', '企业地址', 'input'),
  field('qiyePhoto', '企业图片', 'image'),
  field('qiyePhone', '联系方式', 'input', { required: true }),
  field('qiyeEmail', '企业邮箱', 'input', { required: true }),
  field('qiyeTypes', '所在行业', industrySelect.type, { dictionary: industrySelect.dictionary, required: true }),
  field('qiyeContent', '企业详情', 'richtext', { wide: true })
]

export const moduleConfigs = {
  students: {
    title: '学生管理',
    subtitle: '维护学生基础信息、头像、院系班级与入学年份。',
    entityName: '学生',
    api: studentApi,
    batchImport: true,
    searchFields: [
      field('xueshengXuehao', '学号'),
      field('xueshengName', '姓名'),
      field('xueshengPhone', '手机号'),
      field('yuanxiTypes', '院系', yuanxiSelect.type, {
        dictionary: yuanxiSelect.dictionary,
        onChange: clearClassWhenDepartmentChanges
      }),
      field('banjiTypes', '班级', banjiSelect.type, {
        dictionary: banjiSelect.dictionary,
        optionFilter: filterClassByDepartment,
        disabledWhen: classNeedsDepartment,
        disabledHint: '请先选择院系'
      }),
      field('ruxueYear', '入学年份', 'year'),
      field('graduationStatus', '毕业状态', 'select', { options: graduationOptions }),
      field('internshipStatus', '实习状态', 'select', { options: internshipStatusOptions })
    ],
    columns: [
      field('xueshengPhoto', '头像', 'image', { fallbackProp: 'xueshengName', width: 72 }),
      field('xueshengXuehao', '学号', 'input', { minWidth: 128 }),
      field('xueshengName', '姓名', 'input', { minWidth: 110 }),
      dictionaryColumn('sexTypes', '性别', 'sex_types', 'sexValue', { type: 'tag', width: 92 }),
      field('xueshengPhone', '手机号', 'input', { minWidth: 140 }),
      dictionaryColumn('yuanxiTypes', '院系', 'yuanxi_types', 'yuanxiValue', { type: 'tag', minWidth: 120 }),
      dictionaryColumn('banjiTypes', '班级', 'banji_types', 'banjiValue', { minWidth: 120 }),
      field('ruxueYear', '入学年份', 'input', { width: 108 }),
      field('xueshengEmail', '邮箱', 'input', { minWidth: 180 })
    ],
    formFields: studentFields,
    detailFields: [...studentFields, createTimeColumn]
  },

  teachers: {
    title: '教师管理',
    subtitle: '维护教师账号、工号、院系、联系方式与头像信息。',
    entityName: '教师',
    api: teacherApi,
    batchImport: true,
    searchFields: [
      field('laoshiGonghao', '工号'),
      field('laoshiName', '姓名'),
      field('laoshiPhone', '手机号'),
      field('yuanxiTypes', '院系', yuanxiSelect.type, { dictionary: yuanxiSelect.dictionary })
    ],
    columns: [
      field('laoshiPhoto', '头像', 'image', { fallbackProp: 'laoshiName', width: 72 }),
      field('laoshiGonghao', '工号', 'input', { minWidth: 128 }),
      field('laoshiName', '姓名', 'input', { minWidth: 110 }),
      dictionaryColumn('sexTypes', '性别', 'sex_types', 'sexValue', { type: 'tag', width: 92 }),
      dictionaryColumn('yuanxiTypes', '院系', 'yuanxi_types', 'yuanxiValue', { type: 'tag', minWidth: 140 }),
      field('laoshiPhone', '手机号', 'input', { minWidth: 140 }),
      field('laoshiEmail', '邮箱', 'input', { minWidth: 180 }),
      createTimeColumn
    ],
    formFields: teacherFields,
    detailFields: [...teacherFields, createTimeColumn]
  },

  companies: {
    title: '企业管理',
    subtitle: '维护企业账号、行业、联系方式与企业详情。',
    entityName: '企业',
    api: companyApi,
    batchImport: true,
    searchFields: [
      field('qiyeName', '企业名称'),
      field('qiyeBianhao', '企业编号'),
      field('qiyeTypes', '行业', industrySelect.type, { dictionary: industrySelect.dictionary })
    ],
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
    formFields: companyFields,
    detailFields: [...companyFields, createTimeColumn]
  },

  internships: {
    title: '实习管理',
    subtitle: '维护学生与企业关联的实习记录、岗位、时间和结果。',
    entityName: '实习',
    api: internshipApi,
    batchImport: true,
    optionLoaders: {
      students: loadStudentOptions,
      companies: loadCompanyOptions
    },
    searchFields: [
      field('xueshengName', '学生姓名'),
      field('qiyeName', '企业名称'),
      field('shixiName', '实习名称'),
      field('shixiTypes', '实习类型', internshipTypeSelect.type, { dictionary: internshipTypeSelect.dictionary }),
      field('shixiJieguoTypes', '实习结果', internshipResultSelect.type, {
        dictionary: internshipResultSelect.dictionary
      })
    ],
    columns: [
      field('xueshengName', '学生姓名', 'input', { minWidth: 120 }),
      field('xueshengXuehao', '学号', 'input', { minWidth: 128 }),
      field('qiyeName', '企业名称', 'input', { minWidth: 180 }),
      field('shixiName', '实习名称', 'input', { minWidth: 180 }),
      dictionaryColumn('shixiTypes', '实习类型', 'shixi_types', 'shixiValue', { type: 'tag', minWidth: 116 }),
      field('shixiGangweiName', '实习岗位', 'input', { minWidth: 150 }),
      field('shixiKaishiTime', '开始日期', 'date', { width: 118 }),
      field('shixiJieshuTime', '结束日期', 'date', { width: 118 }),
      dictionaryColumn('shixiJieguoTypes', '实习结果', 'shixi_jieguo_types', 'shixiJieguoValue', {
        type: 'tag',
        minWidth: 116
      })
    ],
    formFields: [
      field('xueshengId', '学生', 'remoteSelect', { source: 'students', required: true }),
      field('qiyeId', '企业', 'remoteSelect', { source: 'companies', required: true }),
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
    ],
    detailFields: [
      field('xueshengName', '学生姓名'),
      field('xueshengXuehao', '学号'),
      field('qiyeName', '企业名称'),
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

  employment: {
    title: '就业管理',
    subtitle: '维护毕业生入职企业、岗位和入职日期。',
    entityName: '就业',
    api: employmentApi,
    batchImport: true,
    optionLoaders: {
      students: loadStudentOptions,
      companies: loadCompanyOptions
    },
    searchFields: [field('xueshengName', '学生姓名'), field('qiyeName', '企业名称'), field('jiuyeGangweiName', '岗位')],
    columns: [
      field('xueshengName', '学生姓名', 'input', { minWidth: 120 }),
      field('xueshengXuehao', '学号', 'input', { minWidth: 128 }),
      field('qiyeName', '企业名称', 'input', { minWidth: 180 }),
      field('jiuyeGangweiName', '入职岗位', 'input', { minWidth: 160 }),
      field('jiuyeKaishiTime', '入职日期', 'date', { width: 118 }),
      createTimeColumn
    ],
    formFields: [
      field('xueshengId', '学生', 'remoteSelect', { source: 'students', required: true }),
      field('qiyeId', '企业', 'remoteSelect', { source: 'companies', required: true }),
      field('jiuyeGangweiName', '入职岗位', 'input', { required: true }),
      field('jiuyeKaishiTime', '入职日期', 'date', { required: true }),
      field('jiuyeContent', '就业备注', 'textarea', { wide: true, rows: 5 })
    ],
    detailFields: [
      field('xueshengName', '学生姓名'),
      field('xueshengXuehao', '学号'),
      field('qiyeName', '企业名称'),
      field('jiuyeGangweiName', '入职岗位'),
      field('jiuyeKaishiTime', '入职日期', 'date'),
      field('jiuyeContent', '就业备注', 'multiline'),
      createTimeColumn
    ]
  },

  announcements: {
    title: '公告管理',
    subtitle: '维护后台公告标题、类型和富文本内容，发布者由后端自动识别。',
    entityName: '公告',
    api: announcementApi,
    searchFields: [
      field('gonggaoName', '公告标题'),
      field('gonggaoTypes', '公告类型', announcementTypeSelect.type, { dictionary: announcementTypeSelect.dictionary }),
      field('fabuzheRole', '发布者身份', 'select', { options: roleOptions })
    ],
    columns: [
      field('gonggaoName', '公告标题', 'input', { minWidth: 220 }),
      dictionaryColumn('gonggaoTypes', '公告类型', 'gonggao_types', 'gonggaoValue', { type: 'tag', minWidth: 116 }),
      field('fabuzheRole', '发布者身份', 'input', { minWidth: 116 }),
      field('fabuzheName', '发布者名称', 'input', { minWidth: 140 }),
      field('insertTime', '发布日期', 'datetime', { minWidth: 168 }),
      createTimeColumn
    ],
    formFields: [
      field('gonggaoName', '公告标题', 'input', { required: true }),
      field('gonggaoTypes', '公告类型', announcementTypeSelect.type, {
        dictionary: announcementTypeSelect.dictionary,
        required: true
      }),
      field('insertTime', '公告发布日期', 'date'),
      field('gonggaoContent', '公告内容', 'richtext', { wide: true, required: true })
    ],
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

  announcementComments: {
    title: '公告评论',
    subtitle: '查看公告评论内容，管理员可删除不合规评论。',
    entityName: '评论',
    api: commentApi,
    canCreate: false,
    canEdit: false,
    searchFields: [
      field('gonggaoName', '公告标题'),
      field('pinglunrenName', '评论人名称'),
      field('pinglunrenRole', '评论人身份', 'select', { options: roleOptions })
    ],
    columns: [
      field('gonggaoName', '公告标题', 'input', { minWidth: 220 }),
      field('pinglunrenName', '评论人名称', 'input', { minWidth: 140 }),
      field('pinglunrenRole', '评论人身份', 'input', { minWidth: 116 }),
      field('gonggaoCommentContent', '评论内容', 'multiline', { minWidth: 320 }),
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

  dictionaries: {
    title: '字典管理',
    subtitle: '维护系统枚举字典，新增时按字典类型自动生成下一编码。',
    entityName: '字典',
    api: dictionaryApi,
    batchImport: true,
    afterSubmitMessage: '字典更新后可能需要重启后端缓存',
    afterSubmit(payload, mode, { clearDictionary }) {
      clearDictionary(payload.dicCode)
    },
    prepareCreate(form) {
      form.superId = null
    },
    transformPayload: normalizeDictionaryPayload,
    searchFields: [field('dicCode', '字典类型', 'select', { options: dictionaryTypeOptions })],
    columns: [
      field('dicCode', '字典类型', 'input', { minWidth: 160 }),
      field('dicName', '字典名称', 'input', { minWidth: 140 }),
      field('codeIndex', 'codeIndex', 'input', { width: 112 }),
      field('indexName', 'indexName', 'input', { minWidth: 150 }),
      dictionaryColumn('superId', '所属院系', 'yuanxi_types', 'superValue', { minWidth: 140 }),
      createTimeColumn
    ],
    formFields: [
      field('dicCode', '字典类型', 'select', {
        required: true,
        options: dictionaryTypeOptions,
        onChange: handleDictionaryTypeChange
      }),
      field('dicName', '字典名称', 'input', { required: true, disabled: true }),
      field('codeIndex', 'codeIndex', 'number', { required: true, min: 1 }),
      field('indexName', 'indexName', 'input', { required: true }),
      field('superId', '所属院系', 'select', {
        dictionary: yuanxiSelect.dictionary,
        requiredWhen: isClassDictionary,
        disabledWhen: (form) => !isClassDictionary(form),
        disabledHint: '仅班级需要选择所属院系'
      }),
      field('beizhu', '备注', 'textarea', { wide: true, rows: 3 })
    ],
    detailFields: [
      field('dicCode', '字典类型'),
      field('dicName', '字典名称'),
      field('codeIndex', 'codeIndex'),
      field('indexName', 'indexName'),
      dictionaryColumn('superId', '所属院系', 'yuanxi_types', 'superValue'),
      field('beizhu', '备注', 'multiline'),
      createTimeColumn
    ]
  },

  settings: {
    title: '系统配置',
    subtitle: '维护系统运行配置，修改配置值前会进行风险确认。',
    entityName: '配置',
    api: configApi,
    riskWarning: '部分配置修改后可能影响系统运行',
    searchFields: [field('name', '配置名'), field('value', '配置值')],
    columns: [
      field('name', '配置名', 'input', { minWidth: 220 }),
      field('value', '配置值', 'multiline', { minWidth: 420 })
    ],
    formFields: [
      field('name', '配置名', 'input', { required: true }),
      field('value', '配置值', 'textarea', { wide: true, rows: 6 })
    ],
    detailFields: [field('name', '配置名'), field('value', '配置值', 'multiline')]
  }
}
