<template>
  <TablePage :title="config.title" :subtitle="config.subtitle">
    <template #search>
      <el-form class="search-form" :model="filters" label-position="top">
        <el-form-item v-for="field in config.searchFields" :key="field.prop" :label="field.label">
          <el-input
            v-if="field.type === 'input'"
            v-model="filters[field.prop]"
            clearable
            :disabled="isFieldDisabled(field, filters)"
            :placeholder="getFieldPlaceholder(field, filters, 'input')"
            @keyup.enter="handleSearch"
          />
          <el-select
            v-else-if="field.type === 'select'"
            v-model="filters[field.prop]"
            clearable
            filterable
            :disabled="isFieldDisabled(field, filters)"
            :placeholder="getFieldPlaceholder(field, filters)"
            @change="handleSearchFieldChange(field)"
          >
            <el-option
              v-for="option in getFieldOptions(field, filters)"
              :key="option.value"
              :label="option.label"
              :value="option.value"
            />
          </el-select>
          <el-date-picker
            v-else-if="field.type === 'year'"
            v-model="filters[field.prop]"
            type="year"
            value-format="YYYY"
            :placeholder="getFieldPlaceholder(field, filters)"
          />
          <el-date-picker
            v-else-if="field.type === 'dateRange'"
            v-model="filters[field.prop]"
            type="daterange"
            value-format="YYYY-MM-DD"
            start-placeholder="开始日期"
            end-placeholder="结束日期"
          />
        </el-form-item>
        <el-form-item class="search-actions">
          <el-button type="primary" @click="handleSearch">查询</el-button>
          <el-button @click="resetSearch">重置</el-button>
        </el-form-item>
      </el-form>
    </template>

    <template #toolbar>
      <div class="toolbar-left">
        <el-button v-if="config.canCreate !== false" type="primary" @click="openForm('create')">新增</el-button>
        <el-button
          v-if="config.canDelete !== false"
          type="danger"
          plain
          :disabled="!selection.length"
          @click="confirmDelete(selection.map((item) => item.id))"
        >
          批量删除
        </el-button>
        <el-button v-if="config.batchImport" plain @click="openImport">批量导入</el-button>
        <div class="sort-controls">
          <el-select
            v-model="sortRules[0].prop"
            clearable
            filterable
            placeholder="一级排序"
            class="sort-field"
          >
            <el-option
              v-for="option in sortableFields"
              :key="option.value"
              :disabled="isSortOptionDisabled(option.value, 0)"
              :label="option.label"
              :value="option.value"
            />
          </el-select>
          <el-select v-model="sortRules[0].order" :disabled="!sortRules[0].prop" class="sort-order">
            <el-option label="升序" value="asc" />
            <el-option label="降序" value="desc" />
          </el-select>
          <el-select
            v-model="sortRules[1].prop"
            clearable
            filterable
            placeholder="二级排序"
            class="sort-field"
          >
            <el-option
              v-for="option in sortableFields"
              :key="option.value"
              :disabled="isSortOptionDisabled(option.value, 1)"
              :label="option.label"
              :value="option.value"
            />
          </el-select>
          <el-select v-model="sortRules[1].order" :disabled="!sortRules[1].prop" class="sort-order">
            <el-option label="升序" value="asc" />
            <el-option label="降序" value="desc" />
          </el-select>
          <el-button v-if="hasActiveSort" plain @click="clearSortRules">清空排序</el-button>
        </div>
      </div>
      <div class="toolbar-right">
        <span>共 {{ pagination.total }} 条</span>
      </div>
    </template>

    <template #table>
      <el-skeleton v-if="loading && !rows.length" :rows="8" animated />
      <el-table
        v-else
        v-loading="loading"
        :data="displayRows"
        row-key="id"
        class="crud-table"
        @selection-change="selection = $event"
      >
        <template #empty>
          <el-empty description="暂无数据" />
        </template>
        <el-table-column v-if="config.canDelete !== false" type="selection" width="44" />
        <el-table-column type="index" label="序号" width="64" />
        <el-table-column
          v-for="column in config.columns"
          :key="column.prop"
          :prop="column.prop"
          :label="column.label"
          :min-width="column.minWidth || 120"
          :width="column.width"
          show-overflow-tooltip
        >
          <template #default="{ row }">
            <el-avatar
              v-if="column.type === 'image'"
              :src="assetUrl(row[column.prop])"
              :size="34"
              shape="circle"
            >
              {{ fallbackInitial(row, column) }}
            </el-avatar>
            <el-tag v-else-if="column.type === 'tag'" effect="light" :type="column.tagType || 'primary'">
              {{ formatDisplay(displayValue(row, column)) }}
            </el-tag>
            <el-link
              v-else-if="column.type === 'file' && row[column.prop]"
              :href="fileUrl(row[column.prop])"
              target="_blank"
              type="primary"
            >
              预览/下载
            </el-link>
            <span v-else-if="column.type === 'date'">{{ formatDate(row[column.prop]) }}</span>
            <span v-else-if="column.type === 'datetime'">{{ formatDateTime(row[column.prop]) }}</span>
            <span v-else-if="column.type === 'html'" class="text-clip">{{ stripHtml(row[column.prop]) || '-' }}</span>
            <span v-else-if="column.type === 'multiline'" class="multi-line">{{ formatDisplay(row[column.prop]) }}</span>
            <span v-else>{{ formatDisplay(displayValue(row, column)) }}</span>
          </template>
        </el-table-column>
        <el-table-column label="操作" fixed="right" :width="actionColumnWidth">
          <template #default="{ row }">
            <el-button link type="primary" @click="openDetail(row)">查看</el-button>
            <el-button v-if="config.canEdit !== false" link type="primary" @click="openForm('edit', row)">
              编辑
            </el-button>
            <el-button v-if="config.commentable" link type="primary" @click="openComments(row)">
              {{ config.commentListActionLabel || '查看评论' }}
            </el-button>
            <el-button v-if="config.commentable" link type="primary" @click="openCommentForm(row)">
              {{ config.commentActionLabel || '评论' }}
            </el-button>
            <el-button
              v-for="action in visibleRowActions(row)"
              :key="action.label"
              link
              :type="action.type || 'primary'"
              :disabled="isRowActionDisabled(action, row)"
              @click="runRowAction(action, row)"
            >
              {{ action.label }}
            </el-button>
            <el-button v-if="canRowDelete" link type="danger" @click="confirmDelete([row.id])">
              删除
            </el-button>
          </template>
        </el-table-column>
      </el-table>
    </template>

    <template #pagination>
      <el-pagination
        v-model:current-page="pagination.page"
        v-model:page-size="pagination.limit"
        background
        layout="total, sizes, prev, pager, next, jumper"
        :page-sizes="[10, 20, 50, 100]"
        :total="pagination.total"
        @size-change="fetchData"
        @current-change="fetchData"
      />
    </template>
  </TablePage>

  <el-dialog
    v-model="formDialog.visible"
    :title="formDialog.mode === 'create' ? `新增${config.entityName}` : `编辑${config.entityName}`"
    width="760px"
    destroy-on-close
  >
    <el-form class="crud-form" :model="form" label-position="top">
      <el-form-item
        v-for="field in config.formFields"
        :key="field.prop"
        :label="field.label"
        :class="{ 'form-wide': field.wide || ['textarea', 'richtext'].includes(field.type) }"
        :required="isFieldRequired(field)"
      >
        <el-input
          v-if="['input', 'password'].includes(field.type)"
          v-model="form[field.prop]"
          :type="field.type === 'password' ? 'password' : 'text'"
          clearable
          :disabled="isFieldDisabled(field, form)"
          :placeholder="getFieldPlaceholder(field, form, 'input')"
          :show-password="field.type === 'password'"
          @change="handleFormFieldChange(field)"
        />
        <el-input-number
          v-else-if="field.type === 'number'"
          v-model="form[field.prop]"
          :min="field.min"
          :max="field.max"
          :step="field.step || 1"
          :disabled="isFieldDisabled(field, form)"
          controls-position="right"
          class="form-number"
          @change="handleFormFieldChange(field)"
        />
        <el-input
          v-else-if="field.type === 'textarea'"
          v-model="form[field.prop]"
          type="textarea"
          :rows="field.rows || 4"
          :disabled="isFieldDisabled(field, form)"
          :placeholder="getFieldPlaceholder(field, form, 'input')"
        />
        <el-select
          v-else-if="field.type === 'select'"
          v-model="form[field.prop]"
          clearable
          filterable
          :disabled="isFieldDisabled(field, form)"
          :placeholder="getFieldPlaceholder(field, form)"
          @change="handleFormFieldChange(field)"
        >
          <el-option
            v-for="option in getFieldOptions(field, form)"
            :key="option.value"
            :label="option.label"
            :value="option.value"
          />
        </el-select>
        <el-select
          v-else-if="field.type === 'remoteSelect'"
          v-model="form[field.prop]"
          clearable
          filterable
          :disabled="isFieldDisabled(field, form)"
          :placeholder="getFieldPlaceholder(field, form)"
        >
          <el-option
            v-for="option in remoteOptions[field.source] || []"
            :key="option.value"
            :label="option.label"
            :value="option.value"
          />
        </el-select>
        <el-date-picker
          v-else-if="field.type === 'date'"
          v-model="form[field.prop]"
          type="date"
          value-format="YYYY-MM-DD"
          :disabled="isFieldDisabled(field, form)"
          :placeholder="getFieldPlaceholder(field, form)"
        />
        <el-date-picker
          v-else-if="field.type === 'year'"
          v-model="form[field.prop]"
          type="year"
          value-format="YYYY"
          :disabled="isFieldDisabled(field, form)"
          :placeholder="getFieldPlaceholder(field, form)"
        />
        <UploadControl
          v-else-if="field.type === 'image'"
          v-model="form[field.prop]"
          type="image"
          accept="image/*"
          :disabled="isFieldDisabled(field, form)"
        />
        <UploadControl
          v-else-if="field.type === 'file'"
          v-model="form[field.prop]"
          type="file"
          :accept="field.accept || '.pdf,.doc,.docx,.xls,.xlsx'"
          :disabled="isFieldDisabled(field, form)"
        />
        <RichTextEditor v-else-if="field.type === 'richtext'" v-model="form[field.prop]" />
      </el-form-item>
    </el-form>
    <template #footer>
      <el-button @click="formDialog.visible = false">取消</el-button>
      <el-button type="primary" :loading="submitting" @click="submitForm">保存</el-button>
    </template>
  </el-dialog>

  <el-dialog v-model="detailDialog.visible" :title="`${config.entityName}详情`" width="760px" destroy-on-close>
    <el-descriptions :column="2" border class="detail-descriptions">
      <el-descriptions-item v-for="field in detailFields" :key="field.prop" :label="field.label">
        <el-avatar v-if="field.type === 'image'" :src="assetUrl(detailData[field.prop])" :size="44">
          {{ fallbackInitial(detailData, field) }}
        </el-avatar>
        <el-link
          v-else-if="field.type === 'file' && detailData[field.prop]"
          :href="fileUrl(detailData[field.prop])"
          target="_blank"
          type="primary"
        >
          预览/下载
        </el-link>
        <span v-else-if="field.type === 'date'">{{ formatDate(detailData[field.prop]) }}</span>
        <span v-else-if="field.type === 'datetime'">{{ formatDateTime(detailData[field.prop]) }}</span>
        <span v-else-if="field.type === 'multiline'" class="multi-line">{{ formatDisplay(detailData[field.prop]) }}</span>
        <div v-else-if="field.type === 'html'" class="detail-html" v-html="detailData[field.prop] || '-'"></div>
        <span v-else>{{ formatDisplay(displayValue(detailData, field)) }}</span>
      </el-descriptions-item>
    </el-descriptions>
  </el-dialog>

  <el-dialog
    v-model="commentsDialog.visible"
    :title="`${commentConfig.dialogTitle}${commentsDialog.parentName ? ` - ${commentsDialog.parentName}` : ''}`"
    width="760px"
    destroy-on-close
  >
    <div class="comment-toolbar">
      <span>共 {{ commentsDialog.total }} 条{{ commentConfig.actionLabel }}</span>
      <el-button type="primary" plain @click="showCommentComposer">{{ commentConfig.actionLabel }}</el-button>
    </div>

    <el-skeleton v-if="commentsDialog.loading" :rows="4" animated />
    <el-empty v-else-if="!commentsDialog.comments.length" :description="commentConfig.emptyText" />
    <div v-else class="comment-list">
      <article v-for="comment in commentsDialog.comments" :key="comment.id" class="comment-item">
        <header class="comment-meta">
          <strong>{{ comment[commentConfig.authorNameProp] || '匿名用户' }}</strong>
          <el-tag size="small" effect="plain">{{ comment[commentConfig.authorRoleProp] || '未知身份' }}</el-tag>
          <time>{{ formatDateTime(comment.createTime) }}</time>
        </header>
        <p>{{ comment[commentConfig.contentProp] }}</p>
      </article>
    </div>

    <div v-if="commentsDialog.composing" class="comment-composer">
      <el-input
        v-model="commentForm.content"
        type="textarea"
        :rows="4"
        maxlength="500"
        show-word-limit
        :placeholder="commentConfig.placeholder"
      />
    </div>

    <template #footer>
      <el-button @click="commentsDialog.visible = false">关闭</el-button>
      <el-button
        v-if="commentsDialog.composing"
        type="primary"
        :loading="commentSubmitting"
        @click="submitComment"
      >
        提交{{ commentConfig.actionLabel }}
      </el-button>
    </template>
  </el-dialog>

  <el-dialog v-model="importDialog.visible" :title="`批量导入${config.entityName}`" width="460px">
    <p class="import-tip">请先上传 `.xls` 文件，上传成功后点击导入。</p>
    <UploadControl v-model="importDialog.fileName" type="file" accept=".xls" />
    <template #footer>
      <el-button @click="importDialog.visible = false">取消</el-button>
      <el-button type="primary" :loading="submitting" :disabled="!importDialog.fileName" @click="submitImport">
        导入
      </el-button>
    </template>
  </el-dialog>
</template>

<script setup>
import { computed, onMounted, reactive, ref } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import TablePage from '../../../components/TablePage/index.vue'
import UploadControl from '../../../components/Upload/index.vue'
import RichTextEditor from '../../../components/RichTextEditor.vue'
import * as defaultCommentApi from '../../../api/comment'
import { downloadAsset, normalizeAssetUrl } from '../../../api/request'
import { useDictionary } from '../../../hooks/useDictionary'

const props = defineProps({
  config: {
    type: Object,
    required: true
  }
})

const { ensure, getOptions, getLabel, clearDictionary } = useDictionary()

const rows = ref([])
const loading = ref(false)
const submitting = ref(false)
const commentSubmitting = ref(false)
const selection = ref([])
const filters = reactive({})
const form = reactive({})
const detailData = reactive({})
const commentForm = reactive({
  content: ''
})
const remoteOptions = reactive({})
const sortRules = reactive([
  { prop: '', order: 'asc' },
  { prop: '', order: 'asc' }
])

const pagination = reactive({
  page: 1,
  limit: 10,
  total: 0
})

const formDialog = reactive({
  visible: false,
  mode: 'create'
})

const detailDialog = reactive({
  visible: false
})

const importDialog = reactive({
  visible: false,
  fileName: ''
})

const commentsDialog = reactive({
  visible: false,
  loading: false,
  parentId: null,
  parentName: '',
  comments: [],
  total: 0,
  composing: false
})

const config = computed(() => props.config).value
const detailFields = computed(() => config.detailFields || [...config.columns, ...(config.formFields || [])])
const commentConfig = computed(() => ({
  api: config.commentsApi || defaultCommentApi,
  parentParam: config.commentParentParam || 'gonggaoId',
  payloadParentField: config.commentPayloadParentField || config.commentParentParam || 'gonggaoId',
  titleProp: config.commentTitleProp || 'gonggaoName',
  authorNameProp: config.commentAuthorNameProp || 'pinglunrenName',
  authorRoleProp: config.commentAuthorRoleProp || 'pinglunrenRole',
  contentProp: config.commentContentProp || 'gonggaoCommentContent',
  countProp: config.commentCountProp || 'commentCount',
  dialogTitle: config.commentDialogTitle || '公告评论',
  actionLabel: config.commentActionLabel || '评论',
  emptyText: config.commentEmptyText || '暂无评论',
  placeholder: config.commentPlaceholder || '请输入评论内容',
  successMessage: config.commentSuccessMessage || '评论成功'
}))
const canRowDelete = computed(() => config.canDelete !== false && !config.batchDeleteOnly)
const actionColumnWidth = computed(() => {
  let width = 78
  if (config.canEdit !== false) width += 54
  if (canRowDelete.value) width += 54
  if (config.commentable) width += 132
  if (config.rowActions?.length) width += config.rowActions.length * 58
  return Math.max(width, 150)
})
const sortableFields = computed(() =>
  (config.sortFields || config.columns || [])
    .filter((column) => column.prop && !['image', 'file', 'html'].includes(column.type))
    .map((column) => ({
      label: column.label,
      value: column.sortProp || column.prop,
      column
    }))
)
const hasActiveSort = computed(() => sortRules.some((rule) => rule.prop))
const displayRows = computed(() => {
  const activeRules = sortRules.filter((rule) => rule.prop)
  if (!activeRules.length) return rows.value

  return [...rows.value].sort((left, right) => {
    for (const rule of activeRules) {
      const field = sortableFields.value.find((item) => item.value === rule.prop)
      const result = compareSortValues(getSortValue(left, field), getSortValue(right, field))
      if (result !== 0) {
        return rule.order === 'desc' ? -result : result
      }
    }
    return 0
  })
})

onMounted(async () => {
  initializeModels()
  await preloadDictionaries()
  await loadRemoteOptions()
  await fetchData()
})

function initializeModels() {
  ;(config.searchFields || []).forEach((field) => {
    filters[field.prop] = field.default ?? ''
  })
  resetForm()
}

async function preloadDictionaries() {
  const dictionaryTypes = new Set()
  ;[...(config.searchFields || []), ...(config.columns || []), ...(config.formFields || [])].forEach((field) => {
    ;(field.extraDictionaries || []).forEach((type) => dictionaryTypes.add(type))
    if (typeof field.dictionary === 'string') dictionaryTypes.add(field.dictionary)
  })
  await Promise.all([...dictionaryTypes].map((type) => ensure(type).catch(() => [])))
}

async function loadRemoteOptions() {
  if (!config.optionLoaders) return
  await Promise.all(
    Object.entries(config.optionLoaders).map(async ([key, loader]) => {
      remoteOptions[key] = await loader().catch(() => [])
    })
  )
}

function getFieldOptions(field, model = {}) {
  let options = []
  if (typeof field.options === 'function') {
    options = field.options(model)
  } else if (field.options) {
    options = field.options
  }
  if (field.dictionary) {
    const dictionaryType = resolveDictionary(field, model)
    options = config.dictionaryOptions?.[dictionaryType] || getOptions(dictionaryType).value
  }
  if (field.optionFilter) {
    return options.filter((option) => field.optionFilter(option, model))
  }
  return options
}

async function fetchData() {
  loading.value = true
  try {
    const params = buildQueryParams()
    const result = await config.api.page(params)
    const page = result.data || {}
    rows.value = page.list || []
    pagination.total = Number(page.total || 0)
    pagination.page = Number(page.currPage || pagination.page)
    pagination.limit = Number(page.pageSize || pagination.limit)
  } catch {
    rows.value = []
    pagination.total = 0
  } finally {
    loading.value = false
  }
}

function buildQueryParams() {
  const params = {
    page: String(pagination.page),
    limit: String(pagination.limit),
    orderBy: config.orderBy || 'id'
  }

  Object.entries(filters).forEach(([key, value]) => {
    if (Array.isArray(value)) {
      const field = config.searchFields.find((item) => item.prop === key)
      if (field?.type === 'dateRange' && value.length === 2) {
        params[`${field.rangePrefix || key}Start`] = value[0]
        params[`${field.rangePrefix || key}End`] = value[1]
      }
      return
    }
    if (value !== '' && value !== null && value !== undefined) {
      params[key] = value
    }
  })

  return config.transformSearch ? config.transformSearch(params, filters) : params
}

function handleSearch() {
  pagination.page = 1
  fetchData()
}

function resetSearch() {
  Object.keys(filters).forEach((key) => {
    filters[key] = ''
  })
  handleSearch()
}

function resetForm() {
  Object.keys(form).forEach((key) => delete form[key])
  ;(config.formFields || []).forEach((field) => {
    form[field.prop] = field.default ?? ''
  })
}

async function openForm(mode, row = null) {
  resetForm()
  formDialog.mode = mode
  if (mode === 'edit' && row?.id) {
    const result = await config.api.info(row.id)
    const data = result.data || row
    form.id = data.id
    config.formFields.forEach((field) => {
      form[field.prop] = data[field.prop] ?? field.default ?? ''
    })
  } else if (config.prepareCreate) {
    await config.prepareCreate(form)
  }
  formDialog.visible = true
}

async function openDetail(row) {
  Object.keys(detailData).forEach((key) => delete detailData[key])
  const result = await config.api.info(row.id)
  Object.assign(detailData, row, result.data || {})
  detailDialog.visible = true
}

async function openComments(row, composing = false) {
  commentsDialog.parentId = row.id
  commentsDialog.parentName = row[commentConfig.value.titleProp] || ''
  commentsDialog.comments = []
  commentsDialog.total = Number(row[commentConfig.value.countProp] || 0)
  commentsDialog.composing = composing
  commentForm.content = ''
  commentsDialog.visible = true
  await loadComments()
}

function openCommentForm(row) {
  openComments(row, true)
}

function showCommentComposer() {
  commentsDialog.composing = true
}

async function loadComments() {
  if (!commentsDialog.parentId) return
  commentsDialog.loading = true
  try {
    const result = await commentConfig.value.api.page({
      page: 1,
      limit: 1000,
      orderBy: 'create_time',
      [commentConfig.value.parentParam]: commentsDialog.parentId
    })
    const page = result.data || {}
    commentsDialog.comments = page.list || []
    commentsDialog.total = Number(page.total || commentsDialog.comments.length || 0)
  } finally {
    commentsDialog.loading = false
  }
}

async function submitComment() {
  const content = String(commentForm.content || '').trim()
  if (!content) {
    ElMessage.warning('请输入评论内容')
    return
  }
  commentSubmitting.value = true
  try {
    await commentConfig.value.api.save({
      [commentConfig.value.payloadParentField]: commentsDialog.parentId,
      [commentConfig.value.contentProp]: content
    })
    ElMessage.success(commentConfig.value.successMessage)
    commentForm.content = ''
    commentsDialog.composing = false
    await loadComments()
    await fetchData()
  } finally {
    commentSubmitting.value = false
  }
}

function visibleRowActions(row) {
  return (config.rowActions || []).filter((action) => {
    if (!action.visible) return true
    return action.visible(row)
  })
}

function isRowActionDisabled(action, row) {
  return Boolean(action.disabled?.(row))
}

async function runRowAction(action, row) {
  if (isRowActionDisabled(action, row)) return
  try {
    if (action.confirm) {
      await ElMessageBox.confirm(resolveActionText(action.confirm, row), action.confirmTitle || '操作确认', {
        type: action.confirmType || 'warning',
        confirmButtonText: action.confirmButtonText || '确认',
        cancelButtonText: '取消'
      })
    }
  } catch {
    return
  }

  let actionResult
  try {
    actionResult = await action.handler?.(row, { fetchData, ElMessage, ElMessageBox })
  } catch {
    return
  }
  if (actionResult === false) {
    return
  }
  if (action.successMessage) {
    ElMessage.success(resolveActionText(action.successMessage, row))
  }
  if (action.refresh !== false) {
    await fetchData()
  }
}

function resolveActionText(value, row) {
  return typeof value === 'function' ? value(row) : value
}

function validateForm() {
  const missing = config.formFields.find(
    (field) => isFieldRequired(field) && (form[field.prop] === '' || form[field.prop] == null)
  )
  if (missing) {
    ElMessage.warning(`请填写${missing.label}`)
    return false
  }
  const invalid = config.formFields.find((field) => {
    if (field.type !== 'select' || form[field.prop] === '' || form[field.prop] == null) return false
    const options = getFieldOptions(field, form)
    return options.length > 0 && !options.some((option) => String(option.value) === String(form[field.prop]))
  })
  if (invalid) {
    ElMessage.warning(`请选择有效的${invalid.label}`)
    return false
  }
  return true
}

async function submitForm() {
  if (!validateForm()) return
  if (config.riskWarning && formDialog.mode === 'edit') {
    try {
      await ElMessageBox.confirm(config.riskWarning, '风险提示', {
        type: 'warning',
        confirmButtonText: '确认保存',
        cancelButtonText: '取消'
      })
    } catch {
      return
    }
  }

  submitting.value = true
  try {
    const payload = buildPayload()
    if (formDialog.mode === 'edit') {
      await config.api.update(payload)
    } else {
      await config.api.save(payload)
    }
    formDialog.visible = false
    ElMessage.success('保存成功')
    if (config.afterSubmitMessage) {
      ElMessage.warning(config.afterSubmitMessage)
    }
    if (config.afterSubmit) {
      await config.afterSubmit(payload, formDialog.mode, { clearDictionary, fetchData })
    }
    await fetchData()
  } finally {
    submitting.value = false
  }
}

function buildPayload() {
  const payload = {}
  if (formDialog.mode === 'edit' && form.id) payload.id = form.id
  config.formFields.forEach((field) => {
    payload[field.prop] = form[field.prop]
  })
  return config.transformPayload ? config.transformPayload(payload, formDialog.mode) : payload
}

async function confirmDelete(ids) {
  if (!ids.length) return
  try {
    await ElMessageBox.confirm(`确认删除选中的 ${ids.length} 条${config.entityName}数据？`, '删除确认', {
      type: 'warning',
      confirmButtonText: '确认删除',
      cancelButtonText: '取消'
    })
  } catch {
    return
  }
  await config.api.remove(ids)
  ElMessage.success('删除成功')
  await fetchData()
}

function openImport() {
  importDialog.fileName = ''
  importDialog.visible = true
}

async function submitImport() {
  submitting.value = true
  try {
    await config.api.batchInsert(importDialog.fileName)
    importDialog.visible = false
    ElMessage.success('导入成功')
    await fetchData()
  } finally {
    submitting.value = false
  }
}

async function handleFormFieldChange(field) {
  if (field.onChange) {
    await field.onChange({ form, config })
  }
}

async function handleSearchFieldChange(field) {
  if (field.onChange) {
    await field.onChange({ form: filters, config })
  }
}

function getFieldDictionaryLabel(row, column) {
  if (!column.dictionary) return ''
  return getLabel(resolveDictionary(column, row), row[column.prop], row[column.valueProp] ? row[column.valueProp] : '')
}

function resolveDictionary(field, model = {}) {
  return typeof field.dictionary === 'function' ? field.dictionary(model) : field.dictionary
}

function displayValue(row, column) {
  if (column.formatter) return column.formatter(row)
  if (column.dictionary) return row[column.valueProp] || getFieldDictionaryLabel(row, column)
  return row[column.prop]
}

function formatDisplay(value) {
  return value === '' || value === null || value === undefined ? '-' : value
}

function getSortValue(row, field) {
  if (!field) return ''
  return displayValue(row, field.column)
}

function compareSortValues(left, right) {
  const leftEmpty = left === '' || left === null || left === undefined
  const rightEmpty = right === '' || right === null || right === undefined
  if (leftEmpty && rightEmpty) return 0
  if (leftEmpty) return 1
  if (rightEmpty) return -1

  const leftNumber = Number(left)
  const rightNumber = Number(right)
  if (Number.isFinite(leftNumber) && Number.isFinite(rightNumber)) {
    return leftNumber - rightNumber
  }

  const leftText = String(left)
  const rightText = String(right)
  return leftText.localeCompare(rightText, 'zh-CN', { numeric: true, sensitivity: 'base' })
}

function isSortOptionDisabled(value, currentIndex) {
  return sortRules.some((rule, index) => index !== currentIndex && rule.prop === value)
}

function clearSortRules() {
  sortRules.forEach((rule) => {
    rule.prop = ''
    rule.order = 'asc'
  })
}

function isFieldRequired(field) {
  return Boolean(field.required || field.requiredWhen?.(form))
}

function isFieldDisabled(field, model = form) {
  return Boolean(field.disabled || field.disabledWhen?.(model) || (field.disabledOnEdit && formDialog.mode === 'edit'))
}

function getFieldPlaceholder(field, model = form, inputType = 'select') {
  if (field.disabledHint && field.disabledWhen?.(model)) {
    return field.disabledHint
  }
  return field.placeholder || `${inputType === 'input' ? '请输入' : '请选择'}${field.label}`
}

function assetUrl(value) {
  return normalizeAssetUrl(value)
}

function fileUrl(value) {
  return downloadAsset(value)
}

function fallbackInitial(row, column) {
  const source = row[column.fallbackProp || 'name'] || row.xueshengName || row.laoshiName || row.qiyeName || row.username || ''
  return String(source).slice(0, 1) || '图'
}

function formatDate(value) {
  if (!value) return '-'
  return String(value).slice(0, 10)
}

function formatDateTime(value) {
  if (!value) return '-'
  return String(value).replace('T', ' ').slice(0, 19)
}

function stripHtml(value) {
  return String(value || '').replace(/<[^>]*>/g, '').slice(0, 80)
}
</script>

<style scoped>
.search-form {
  display: grid;
  grid-template-columns: repeat(4, minmax(160px, 1fr));
  gap: 0 16px;
}

.search-form :deep(.el-form-item) {
  margin-bottom: 16px;
}

.search-actions {
  align-self: end;
}

.toolbar-left,
.toolbar-right {
  display: flex;
  align-items: center;
  gap: 10px;
}

.sort-controls {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  margin-left: 20px;
}

.sort-field {
  width: 132px;
}

.sort-order {
  width: 82px;
}

.toolbar-right {
  color: #66738b;
  font-size: 13px;
  font-weight: 800;
}

.crud-table {
  width: 100%;
}

.crud-table :deep(th.el-table__cell) {
  background: #fafbfd;
  color: #6d7890;
  font-size: 12px;
  font-weight: 900;
}

.crud-table :deep(td.el-table__cell) {
  color: #344057;
  font-weight: 700;
}

.multi-line {
  display: -webkit-box;
  overflow: hidden;
  white-space: normal;
  -webkit-box-orient: vertical;
  -webkit-line-clamp: 2;
}

.text-clip {
  color: #526078;
}

.crud-form {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 0 18px;
}

.crud-form :deep(.el-form-item) {
  margin-bottom: 18px;
}

.form-number {
  width: 100%;
}

.form-wide {
  grid-column: 1 / -1;
}

.detail-descriptions :deep(.el-descriptions__label) {
  width: 118px;
  color: #5f6d84;
  font-weight: 800;
}

.detail-html {
  max-height: 240px;
  overflow: auto;
  line-height: 1.7;
}

.comment-toolbar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
  margin-bottom: 14px;
  color: #66738b;
  font-size: 13px;
  font-weight: 800;
}

.comment-list {
  display: grid;
  gap: 12px;
  max-height: 340px;
  overflow: auto;
  padding-right: 4px;
}

.comment-item {
  padding: 12px 14px;
  border: 1px solid #e3e9f3;
  border-radius: 8px;
  background: #fbfcff;
}

.comment-meta {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 8px;
  color: #2f3b52;
  font-size: 13px;
}

.comment-meta time {
  margin-left: auto;
  color: #8290a6;
  font-size: 12px;
  font-weight: 700;
}

.comment-item p {
  margin: 0;
  color: #344057;
  line-height: 1.7;
  white-space: pre-wrap;
  word-break: break-word;
}

.comment-composer {
  margin-top: 16px;
}

.import-tip {
  margin: 0 0 16px;
  color: #65738b;
  font-size: 14px;
  font-weight: 700;
}

@media (max-width: 1366px) {
  .search-form {
    grid-template-columns: repeat(3, minmax(160px, 1fr));
  }
}
</style>
