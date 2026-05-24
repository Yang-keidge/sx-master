<template>
  <main class="password-page">
    <section class="page-heading">
      <div>
        <h1>修改密码</h1>
        <p>更新当前教师账号的登录密码。</p>
      </div>
    </section>

    <section class="panel-card password-panel">
      <div class="password-copy">
        <span class="lock-icon">
          <LockKeyhole :size="30" stroke-width="2.3" />
        </span>
        <strong>{{ account.laoshiName || '教师用户' }}</strong>
        <p>{{ account.laoshiGonghao || '-' }}</p>
      </div>

      <el-form class="password-form" :model="form" label-position="top">
        <el-form-item label="原密码" required>
          <el-input v-model="form.oldPassword" type="password" show-password clearable placeholder="请输入原密码" />
        </el-form-item>
        <el-form-item label="新密码" required>
          <el-input v-model="form.newPassword" type="password" show-password clearable placeholder="请输入新密码" />
        </el-form-item>
        <el-form-item label="确认新密码" required>
          <el-input v-model="form.confirmPassword" type="password" show-password clearable placeholder="请再次输入新密码" />
        </el-form-item>
        <el-form-item class="form-actions">
          <el-button type="primary" :loading="submitting" @click="submitPassword">保存密码</el-button>
          <el-button @click="resetForm">重置</el-button>
        </el-form-item>
      </el-form>
    </section>
  </main>
</template>

<script setup>
import { onMounted, reactive, ref } from 'vue'
import { ElMessage } from 'element-plus'
import { LockKeyhole } from 'lucide-vue-next'
import { session, update } from '../../api/teacher'

const account = ref({})
const submitting = ref(false)
const form = reactive({
  oldPassword: '',
  newPassword: '',
  confirmPassword: ''
})

onMounted(loadAccount)

async function loadAccount() {
  try {
    const result = await session()
    account.value = result.data || {}
  } catch {
    ElMessage.error('账号信息加载失败')
  }
}

async function submitPassword() {
  if (!form.oldPassword) {
    ElMessage.warning('请输入原密码')
    return
  }
  if (!form.newPassword) {
    ElMessage.warning('请输入新密码')
    return
  }
  if (form.newPassword.length < 6) {
    ElMessage.warning('新密码至少 6 位')
    return
  }
  if (form.newPassword !== form.confirmPassword) {
    ElMessage.warning('两次输入的新密码不一致')
    return
  }
  if (account.value.password && form.oldPassword !== account.value.password) {
    ElMessage.warning('原密码不正确')
    return
  }

  submitting.value = true
  try {
    await update(buildPasswordPayload())
    account.value.password = form.newPassword
    resetForm()
    ElMessage.success('密码修改成功')
  } finally {
    submitting.value = false
  }
}

function buildPasswordPayload() {
  return {
    id: account.value.id,
    username: account.value.username,
    password: form.newPassword,
    laoshiGonghao: account.value.laoshiGonghao,
    laoshiName: account.value.laoshiName,
    laoshiPhone: account.value.laoshiPhone,
    laoshiIdNumber: account.value.laoshiIdNumber,
    laoshiPhoto: account.value.laoshiPhoto,
    sexTypes: account.value.sexTypes,
    yuanxiTypes: account.value.yuanxiTypes,
    zhuanyeTypes: account.value.zhuanyeTypes,
    laoshiEmail: account.value.laoshiEmail
  }
}

function resetForm() {
  form.oldPassword = ''
  form.newPassword = ''
  form.confirmPassword = ''
}
</script>

<style scoped>
.password-page {
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

.password-panel {
  display: grid;
  grid-template-columns: 260px minmax(0, 520px);
  gap: 34px;
  align-items: start;
  padding: 30px;
}

.password-copy {
  display: grid;
  justify-items: center;
  padding: 28px 20px;
  border: 1px solid #e6edf6;
  border-radius: 8px;
  background: #fbfcff;
  text-align: center;
}

.lock-icon {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 72px;
  height: 72px;
  border-radius: 50%;
  background: #edf3ff;
  color: #3657ff;
}

.password-copy strong {
  margin-top: 18px;
  color: #17233d;
  font-size: 20px;
  font-weight: 900;
}

.password-copy p {
  margin: 8px 0 0;
  color: #536078;
  font-size: 14px;
  font-weight: 800;
}

.password-form {
  width: min(520px, 100%);
}

.password-form :deep(.el-form-item) {
  margin-bottom: 20px;
}

.form-actions {
  padding-top: 4px;
}
</style>
