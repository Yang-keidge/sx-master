<template>
  <main class="profile-page">
    <section class="page-heading">
      <div>
        <h1>企业信息</h1>
        <p>维护当前企业基础资料、联系方式、行业与企业介绍。</p>
      </div>
      <el-button type="primary" @click="openEdit">编辑信息</el-button>
    </section>

    <section class="profile-panel">
      <div class="profile-hero">
        <span class="company-image">
          <img v-if="companyPhoto" :src="companyPhoto" alt="" />
          <Building2 v-else :size="38" stroke-width="2" />
        </span>
        <div>
          <h2>{{ form.qiyeName || '企业用户' }}</h2>
          <p>{{ form.qiyeBianhao || '-' }}</p>
          <el-tag v-if="industryLabel" effect="light">{{ industryLabel }}</el-tag>
        </div>
      </div>

      <el-descriptions :column="2" border class="profile-descriptions">
        <el-descriptions-item label="账号">{{ form.username || '-' }}</el-descriptions-item>
        <el-descriptions-item label="企业编号">{{ form.qiyeBianhao || '-' }}</el-descriptions-item>
        <el-descriptions-item label="企业名称">{{ form.qiyeName || '-' }}</el-descriptions-item>
        <el-descriptions-item label="所在行业">{{ industryLabel || '-' }}</el-descriptions-item>
        <el-descriptions-item label="联系方式">{{ form.qiyePhone || '-' }}</el-descriptions-item>
        <el-descriptions-item label="企业邮箱">{{ form.qiyeEmail || '-' }}</el-descriptions-item>
        <el-descriptions-item label="企业地址" :span="2">{{ form.qiyeAddress || '-' }}</el-descriptions-item>
        <el-descriptions-item label="企业详情" :span="2">
          <div class="profile-content" v-html="form.qiyeContent || '-'"></div>
        </el-descriptions-item>
      </el-descriptions>
    </section>

    <el-dialog v-model="dialogVisible" title="编辑企业信息" width="760px" destroy-on-close>
      <el-form class="profile-form" :model="editForm" label-position="top">
        <el-form-item label="账号" required>
          <el-input v-model="editForm.username" clearable />
        </el-form-item>
        <el-form-item label="密码" required>
          <el-input v-model="editForm.password" type="password" show-password clearable />
        </el-form-item>
        <el-form-item label="企业编号" required>
          <el-input v-model="editForm.qiyeBianhao" clearable />
        </el-form-item>
        <el-form-item label="企业名称" required>
          <el-input v-model="editForm.qiyeName" clearable />
        </el-form-item>
        <el-form-item label="联系方式" required>
          <el-input v-model="editForm.qiyePhone" clearable />
        </el-form-item>
        <el-form-item label="企业邮箱" required>
          <el-input v-model="editForm.qiyeEmail" clearable />
        </el-form-item>
        <el-form-item label="所在行业" required>
          <el-select v-model="editForm.qiyeTypes" clearable filterable placeholder="请选择所在行业">
            <el-option v-for="option in industryOptions" :key="option.value" :label="option.label" :value="option.value" />
          </el-select>
        </el-form-item>
        <el-form-item label="企业图片">
          <UploadControl v-model="editForm.qiyePhoto" type="image" accept="image/*" />
        </el-form-item>
        <el-form-item label="企业地址" class="form-wide">
          <el-input v-model="editForm.qiyeAddress" clearable />
        </el-form-item>
        <el-form-item label="企业详情" class="form-wide">
          <RichTextEditor v-model="editForm.qiyeContent" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" :loading="submitting" @click="submitForm">保存</el-button>
      </template>
    </el-dialog>
  </main>
</template>

<script setup>
import { computed, onMounted, reactive, ref } from 'vue'
import { ElMessage } from 'element-plus'
import { Building2 } from 'lucide-vue-next'
import * as companyApi from '../../api/company'
import { normalizeAssetUrl } from '../../api/request'
import RichTextEditor from '../../components/RichTextEditor.vue'
import UploadControl from '../../components/Upload/index.vue'
import { useDictionary } from '../../hooks/useDictionary'

const { ensure, getOptions, getLabel } = useDictionary()
const form = reactive({})
const editForm = reactive({})
const dialogVisible = ref(false)
const submitting = ref(false)

const industryOptions = getOptions('qiye_types')
const companyPhoto = computed(() => normalizeAssetUrl(form.qiyePhoto))
const industryLabel = computed(() => form.qiyeValue || getLabel('qiye_types', form.qiyeTypes, ''))

onMounted(async () => {
  await ensure('qiye_types')
  await loadCompany()
})

async function loadCompany() {
  const result = await companyApi.session()
  Object.keys(form).forEach((key) => delete form[key])
  Object.assign(form, result.data || {})
}

function openEdit() {
  Object.keys(editForm).forEach((key) => delete editForm[key])
  Object.assign(editForm, form)
  dialogVisible.value = true
}

async function submitForm() {
  const required = [
    ['username', '账号'],
    ['password', '密码'],
    ['qiyeBianhao', '企业编号'],
    ['qiyeName', '企业名称'],
    ['qiyePhone', '联系方式'],
    ['qiyeEmail', '企业邮箱'],
    ['qiyeTypes', '所在行业']
  ]
  const missing = required.find(([prop]) => editForm[prop] === '' || editForm[prop] == null)
  if (missing) {
    ElMessage.warning(`请填写${missing[1]}`)
    return
  }

  submitting.value = true
  try {
    await companyApi.update({ ...editForm })
    ElMessage.success('保存成功')
    dialogVisible.value = false
    await loadCompany()
  } finally {
    submitting.value = false
  }
}
</script>

<style scoped>
.profile-page {
  min-width: 1026px;
  padding: 0 40px 54px;
}

.page-heading {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 20px;
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

.profile-panel {
  min-height: 420px;
  padding: 24px;
  border: 1px solid #e0e7f1;
  border-radius: 8px;
  background: #fff;
  box-shadow: 0 12px 26px rgba(46, 58, 92, 0.06);
}

.profile-hero {
  display: flex;
  align-items: center;
  gap: 18px;
  margin-bottom: 24px;
}

.company-image {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 76px;
  height: 76px;
  overflow: hidden;
  border: 1px solid #dfe7f3;
  border-radius: 8px;
  background: #edf3ff;
  color: #3657ff;
}

.company-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.profile-hero h2 {
  margin: 0 0 8px;
  color: #17233d;
  font-size: 22px;
  font-weight: 900;
}

.profile-hero p {
  margin: 0 0 10px;
  color: #66738b;
  font-size: 14px;
  font-weight: 800;
}

.profile-descriptions :deep(.el-descriptions__label) {
  width: 118px;
  color: #5f6d84;
  font-weight: 800;
}

.profile-content {
  max-height: 260px;
  overflow: auto;
  color: #344057;
  line-height: 1.7;
}

.profile-form {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 0 18px;
}

.profile-form :deep(.el-form-item) {
  margin-bottom: 18px;
}

.form-wide {
  grid-column: 1 / -1;
}
</style>
