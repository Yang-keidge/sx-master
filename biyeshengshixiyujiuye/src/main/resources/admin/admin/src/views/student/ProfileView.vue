<template>
  <main class="profile-page">
    <section class="page-heading">
      <div>
        <h1>个人信息</h1>
        <p>维护账号、学号、联系方式、院系、专业、班级、头像与简历信息。</p>
      </div>
    </section>

    <section class="panel-card profile-panel">
      <aside class="profile-summary">
        <span class="avatar-preview">
          <img v-if="avatarUrl" :src="avatarUrl" alt="" />
          <span v-else>{{ studentInitial }}</span>
        </span>
        <strong>{{ form.xueshengName || '学生用户' }}</strong>
        <p>{{ form.xueshengXuehao || '-' }}</p>
        <small>{{ account.yuanxiValue || '未设置院系' }} · {{ account.zhuanyeValue || '未设置专业' }} · {{ account.banjiValue || '未设置班级' }}</small>
      </aside>

      <el-form class="profile-form" :model="form" label-position="top">
        <el-form-item label="账号" required>
          <el-input v-model="form.username" clearable placeholder="请输入账号" />
        </el-form-item>
        <el-form-item label="学号" required>
          <el-input v-model="form.xueshengXuehao" clearable placeholder="请输入学号" />
        </el-form-item>
        <el-form-item label="姓名" required>
          <el-input v-model="form.xueshengName" clearable placeholder="请输入姓名" />
        </el-form-item>
        <el-form-item label="手机号" required>
          <el-input v-model="form.xueshengPhone" clearable placeholder="请输入手机号" />
        </el-form-item>
        <el-form-item label="身份证号" required>
          <el-input v-model="form.xueshengIdNumber" clearable placeholder="请输入身份证号" />
        </el-form-item>
        <el-form-item label="邮箱">
          <el-input v-model="form.xueshengEmail" clearable placeholder="请输入邮箱" />
        </el-form-item>
        <el-form-item label="性别" required>
          <el-select v-model="form.sexTypes" clearable filterable placeholder="请选择性别">
            <el-option v-for="item in sexOptions" :key="item.value" :label="item.label" :value="item.value" />
          </el-select>
        </el-form-item>
        <el-form-item label="院系" required>
          <el-select v-model="form.yuanxiTypes" clearable filterable placeholder="请选择院系" @change="handleDepartmentChange">
            <el-option v-for="item in yuanxiOptions" :key="item.value" :label="item.label" :value="item.value" />
          </el-select>
        </el-form-item>
        <el-form-item label="专业" required>
          <el-select v-model="form.zhuanyeTypes" clearable filterable :disabled="!form.yuanxiTypes" placeholder="请选择专业" @change="handleMajorChange">
            <el-option v-for="item in majorOptions" :key="item.value" :label="item.label" :value="item.value" />
          </el-select>
        </el-form-item>
        <el-form-item label="班级" required>
          <el-select v-model="form.banjiTypes" clearable filterable :disabled="!form.zhuanyeTypes" placeholder="请选择班级">
            <el-option v-for="item in classOptions" :key="item.value" :label="item.label" :value="item.value" />
          </el-select>
        </el-form-item>
        <el-form-item label="入学年份" required>
          <el-date-picker v-model="form.ruxueYear" type="year" value-format="YYYY" placeholder="请选择入学年份" />
        </el-form-item>
        <el-form-item class="form-wide" label="头像">
          <UploadControl v-model="form.xueshengPhoto" type="image" accept="image/*" />
        </el-form-item>
        <el-form-item class="form-wide" label="简历">
          <UploadControl v-model="form.xueshengJianliFile" type="file" accept=".pdf,.doc,.docx" />
        </el-form-item>
        <el-form-item class="form-actions">
          <el-button type="primary" :loading="submitting" @click="submitProfile">保存信息</el-button>
          <el-button @click="loadProfile">重新加载</el-button>
        </el-form-item>
      </el-form>
    </section>
  </main>
</template>

<script setup>
import { computed, onMounted, reactive, ref } from 'vue'
import { ElMessage } from 'element-plus'
import UploadControl from '../../components/Upload/index.vue'
import { normalizeAssetUrl } from '../../api/request'
import { session, update } from '../../api/student'
import { useDictionary } from '../../hooks/useDictionary'

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

const { ensure, getOptions } = useDictionary()
const account = ref({})
const submitting = ref(false)
const form = reactive({
  username: '',
  xueshengXuehao: '',
  xueshengName: '',
  xueshengPhone: '',
  xueshengIdNumber: '',
  xueshengPhoto: '',
  xueshengJianliFile: '',
  sexTypes: '',
  yuanxiTypes: '',
  zhuanyeTypes: '',
  banjiTypes: '',
  ruxueYear: '',
  xueshengEmail: ''
})

const sexOptions = getOptions('sex_types')
const yuanxiOptions = getOptions('yuanxi_types')
const allMajorOptions = getOptions('zhuanye_types')
const allClassOptions = getOptions('banji_types')
const majorOptions = computed(() => allMajorOptions.value.filter((option) => filterMajorByDepartment(option, form.yuanxiTypes)))
const classOptions = computed(() => allClassOptions.value.filter((option) => filterClassByMajor(option, form.zhuanyeTypes)))
const avatarUrl = computed(() => normalizeAssetUrl(form.xueshengPhoto))
const studentInitial = computed(() => (form.xueshengName || '学').slice(0, 1))

onMounted(async () => {
  await Promise.all([ensure('sex_types'), ensure('yuanxi_types'), ensure('zhuanye_types'), ensure('banji_types')])
  await loadProfile()
})

async function loadProfile() {
  try {
    const result = await session()
    account.value = result.data || {}
    fillForm(account.value)
    updateStoredUser(account.value)
  } catch {
    ElMessage.error('个人信息加载失败')
  }
}

function fillForm(data) {
  Object.keys(form).forEach((key) => {
    form[key] = data[key] ?? ''
  })
}

function handleDepartmentChange() {
  form.zhuanyeTypes = ''
  form.banjiTypes = ''
}

function handleMajorChange() {
  form.banjiTypes = ''
}

function filterMajorByDepartment(option, departmentId) {
  if (!departmentId) return false
  const parentId = option.raw?.superId
  if (parentId !== null && parentId !== undefined && parentId !== '') {
    return String(parentId) === String(departmentId)
  }
  return true
}

function filterClassByMajor(option, majorId) {
  if (!majorId) return false
  const parentId = option.raw?.superId
  if (parentId !== null && parentId !== undefined && parentId !== '') {
    return String(parentId) === String(majorId)
  }
  return (majorClassMap[majorId] || []).some((classId) => String(classId) === String(option.value))
}

async function submitProfile() {
  const missing = requiredFields.find((field) => form[field.prop] === '' || form[field.prop] == null)
  if (missing) {
    ElMessage.warning(`请填写${missing.label}`)
    return
  }

  submitting.value = true
  try {
    await update(buildProfilePayload())
    ElMessage.success('个人信息保存成功')
    await loadProfile()
  } finally {
    submitting.value = false
  }
}

function buildProfilePayload() {
  const payload = {
    id: account.value.id,
    username: form.username,
    xueshengXuehao: form.xueshengXuehao,
    xueshengName: form.xueshengName,
    xueshengPhone: form.xueshengPhone,
    xueshengIdNumber: form.xueshengIdNumber,
    xueshengPhoto: form.xueshengPhoto,
    xueshengJianliFile: form.xueshengJianliFile,
    sexTypes: form.sexTypes,
    yuanxiTypes: form.yuanxiTypes,
    zhuanyeTypes: form.zhuanyeTypes,
    banjiTypes: form.banjiTypes,
    ruxueYear: form.ruxueYear,
    xueshengEmail: form.xueshengEmail
  }

  if (account.value.password) {
    payload.password = account.value.password
  }

  return payload
}

function updateStoredUser(data) {
  if (!data) return
  const stored = readStoredUser()
  localStorage.setItem(
    'currentUser',
    JSON.stringify({
      ...stored,
      userId: data.id || stored.userId,
      username: data.xueshengName || stored.username,
      studentNumber: data.xueshengXuehao || stored.studentNumber,
      role: '学生',
      tableName: 'xuesheng'
    })
  )
}

function readStoredUser() {
  try {
    return JSON.parse(localStorage.getItem('currentUser') || '{}')
  } catch {
    return {}
  }
}

const requiredFields = [
  { prop: 'username', label: '账号' },
  { prop: 'xueshengXuehao', label: '学号' },
  { prop: 'xueshengName', label: '姓名' },
  { prop: 'xueshengPhone', label: '手机号' },
  { prop: 'xueshengIdNumber', label: '身份证号' },
  { prop: 'sexTypes', label: '性别' },
  { prop: 'yuanxiTypes', label: '院系' },
  { prop: 'zhuanyeTypes', label: '专业' },
  { prop: 'banjiTypes', label: '班级' },
  { prop: 'ruxueYear', label: '入学年份' }
]
</script>

<style scoped>
.profile-page {
  min-width: 1026px;
  padding: 0 40px 54px;
}

.page-heading {
  margin-bottom: 22px;
}

.page-heading h1 {
  margin: 0 0 10px;
  color: #17233d;
  font-size: 25px;
  font-weight: 900;
  line-height: 1.2;
}

.page-heading p {
  margin: 0;
  color: #66738b;
  font-size: 14px;
  font-weight: 700;
}

.panel-card {
  border: 1px solid #e0e7f1;
  border-radius: 8px;
  background: #fff;
  box-shadow: 0 12px 26px rgba(46, 58, 92, 0.06);
}

.profile-panel {
  display: grid;
  grid-template-columns: 260px minmax(0, 1fr);
  gap: 30px;
  padding: 28px;
}

.profile-summary {
  display: grid;
  align-content: start;
  justify-items: center;
  padding: 26px 20px;
  border: 1px solid #e6edf6;
  border-radius: 8px;
  background: #fbfcff;
  text-align: center;
}

.avatar-preview {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 96px;
  height: 96px;
  overflow: hidden;
  border: 3px solid #dfe7f3;
  border-radius: 50%;
  background: #edf3ff;
  color: #3657ff;
  font-size: 30px;
  font-weight: 900;
}

.avatar-preview img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.profile-summary strong {
  margin-top: 18px;
  color: #17233d;
  font-size: 20px;
  font-weight: 900;
}

.profile-summary p {
  margin: 8px 0 0;
  color: #536078;
  font-size: 14px;
  font-weight: 800;
}

.profile-summary small {
  margin-top: 14px;
  color: #7c8799;
  font-size: 13px;
  font-weight: 800;
  line-height: 1.6;
}

.profile-form {
  display: grid;
  grid-template-columns: repeat(2, minmax(220px, 1fr));
  gap: 0 18px;
}

.profile-form :deep(.el-form-item) {
  margin-bottom: 18px;
}

.profile-form :deep(.el-select),
.profile-form :deep(.el-date-editor.el-input) {
  width: 100%;
}

.form-wide,
.form-actions {
  grid-column: 1 / -1;
}

.form-actions {
  margin-top: 4px;
}
</style>
