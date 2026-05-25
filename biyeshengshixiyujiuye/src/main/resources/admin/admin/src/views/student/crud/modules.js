import * as announcementApi from '../../../api/announcement'
import * as applicationApi from '../../../api/application'
import * as commentApi from '../../../api/comment'
import * as employmentApi from '../../../api/employment'
import * as internshipApi from '../../../api/internship'
import * as recruitmentApi from '../../../api/recruitment'

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

async function loadAnnouncementOptions() {
  const result = await announcementApi.page({ page: 1, limit: 1000, orderBy: 'id' })
  return (result.data?.list || []).map((item) => ({
    label: `${item.gonggaoName || '未命名公告'}（${item.fabuzheRole || '未知'}）`,
    value: item.id
  }))
}

function myComments(params) {
  return {
    ...params,
    myOnly: 'true'
  }
}

function formatRecruitmentProgress(row) {
  return `${Number(row.yizhaoRenshu || 0)}/${Number(row.zhaopinRenshu || 0)}个`
}

function formatRecruitmentStatus(row) {
  return Number(row.yizhaoRenshu || 0) >= Number(row.zhaopinRenshu || 0) ? '已招满' : '招聘中'
}

function isRecruitmentFull(row) {
  return Number(row.yizhaoRenshu || 0) >= Number(row.zhaopinRenshu || 0)
}

export const studentModuleConfigs = {
  recruitmentJobs: {
    title: '招聘信息',
    subtitle: '浏览企业发布的实习招聘岗位，并提交应聘。',
    entityName: '招聘岗位',
    api: recruitmentApi,
    canCreate: false,
    canEdit: false,
    canDelete: false,
    searchFields: [
      field('qiyeName', '公司名称'),
      field('zhaopinGangweiName', '职位名称'),
      field('zhaopinLeixing', '职位类型'),
      field('gongzuoDizhi', '工作地址')
    ],
    columns: [
      field('qiyeName', '公司名称', 'input', { minWidth: 180 }),
      field('zhaopinGangweiName', '职位名称', 'input', { minWidth: 160 }),
      field('zhaopinLeixing', '职位类型', 'input', { minWidth: 130 }),
      field('xinziFanwei', '薪资范围', 'input', { minWidth: 130 }),
      field('gongzuoDizhi', '工作地址', 'input', { minWidth: 180 }),
      field('zhaopinProgress', '已招到/招聘数量', 'input', { formatter: formatRecruitmentProgress, width: 144 }),
      field('zhaomanStatus', '状态', 'tag', { formatter: formatRecruitmentStatus, width: 96 }),
      createTimeColumn
    ],
    rowActions: [
      {
        label: '应聘',
        type: 'primary',
        visible: (row) => !isRecruitmentFull(row),
        confirm: (row) => `确认应聘 ${row.qiyeName || '该企业'} 的 ${row.zhaopinGangweiName || '该岗位'}？`,
        confirmButtonText: '确认应聘',
        successMessage: '应聘成功',
        handler: (row) => applicationApi.apply(row.id)
      }
    ],
    formFields: [],
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
    title: '我的应聘',
    subtitle: '查看和管理我已提交的招聘岗位应聘数据。',
    entityName: '应聘',
    api: applicationApi,
    canCreate: false,
    canEdit: false,
    searchFields: [
      field('qiyeName', '公司名称'),
      field('zhaopinGangweiName', '职位名称'),
      field('zhaopinLeixing', '职位类型')
    ],
    columns: [
      field('qiyeName', '公司名称', 'input', { minWidth: 180 }),
      field('zhaopinGangweiName', '职位名称', 'input', { minWidth: 160 }),
      field('zhaopinLeixing', '职位类型', 'input', { minWidth: 130 }),
      field('xinziFanwei', '薪资范围', 'input', { minWidth: 130 }),
      field('gongzuoDizhi', '工作地址', 'input', { minWidth: 180 }),
      field('yingpinStatus', '状态', 'tag', { width: 92 }),
      createTimeColumn
    ],
    formFields: [],
    detailFields: [
      field('qiyeName', '公司名称'),
      field('zhaopinGangweiName', '职位名称'),
      field('zhaopinLeixing', '职位类型'),
      field('xinziFanwei', '薪资范围'),
      field('gongzuoDizhi', '工作地址'),
      field('gongzuoYaoqiu', '工作要求', 'multiline'),
      field('yingpinStatus', '应聘状态'),
      createTimeColumn
    ]
  },

  internships: {
    title: '我的实习',
    subtitle: '查看我的实习企业、岗位、实习周期和实习结果。',
    entityName: '实习',
    api: internshipApi,
    canCreate: false,
    canEdit: false,
    canDelete: false,
    searchFields: [
      field('qiyeName', '企业名称'),
      field('shixiName', '实习名称'),
      field('shixiGangweiName', '实习岗位'),
      field('shixiTypes', '实习类型', internshipTypeSelect.type, { dictionary: internshipTypeSelect.dictionary }),
      field('shixiJieguoTypes', '实习结果', internshipResultSelect.type, {
        dictionary: internshipResultSelect.dictionary
      })
    ],
    columns: [
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
    ],
    formFields: [],
    detailFields: [
      field('xueshengName', '学生姓名'),
      field('xueshengXuehao', '学号'),
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

  employment: {
    title: '我的就业',
    subtitle: '查看我的就业企业、入职岗位和入职日期。',
    entityName: '就业',
    api: employmentApi,
    canCreate: false,
    canEdit: false,
    canDelete: false,
    searchFields: [field('qiyeName', '企业名称'), field('jiuyeGangweiName', '入职岗位')],
    columns: [
      field('qiyeName', '企业名称', 'input', { minWidth: 180 }),
      field('jiuyeGangweiName', '入职岗位', 'input', { minWidth: 160 }),
      field('jiuyeKaishiTime', '入职日期', 'date', { width: 118 }),
      field('jiuyeContent', '就业备注', 'multiline', { minWidth: 220 }),
      createTimeColumn
    ],
    formFields: [],
    detailFields: [
      field('xueshengName', '学生姓名'),
      field('xueshengXuehao', '学号'),
      field('qiyeName', '企业名称'),
      field('qiyeAddress', '企业地址'),
      field('qiyePhone', '企业电话'),
      field('jiuyeGangweiName', '入职岗位'),
      field('jiuyeKaishiTime', '入职日期', 'date'),
      field('jiuyeContent', '就业备注', 'multiline'),
      createTimeColumn
    ]
  },

  announcements: {
    title: '公告信息',
    subtitle: '查看学校和企业发布的实习、就业、招聘与通知公告。',
    entityName: '公告',
    api: announcementApi,
    commentable: true,
    canCreate: false,
    canEdit: false,
    canDelete: false,
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
      field('insertTime', '发布日期', 'datetime', { minWidth: 168 })
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
    title: '我的评论',
    subtitle: '管理我对公告发表的评论内容。',
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
  }
}
