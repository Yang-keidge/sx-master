<template>
  <div class="upload-control">
    <el-upload
      :accept="accept"
      :auto-upload="true"
      :show-file-list="false"
      :http-request="handleUpload"
      :disabled="disabled || uploading"
    >
      <div v-if="isImage && previewUrl" class="image-preview">
        <img :src="previewUrl" alt="上传图片预览" />
        <span>更换</span>
      </div>
      <el-button v-else :loading="uploading" type="primary" plain>{{ buttonText }}</el-button>
    </el-upload>

    <div v-if="!isImage && modelValue" class="file-preview">
      <span>{{ fileName }}</span>
      <el-link :href="downloadUrl" target="_blank" type="primary">预览/下载</el-link>
    </div>
  </div>
</template>

<script setup>
import { computed, ref } from 'vue'
import { ElMessage } from 'element-plus'
import { downloadAsset, normalizeAssetUrl, uploadFile } from '../../api/request'

const props = defineProps({
  modelValue: {
    type: String,
    default: ''
  },
  type: {
    type: String,
    default: 'image'
  },
  accept: {
    type: String,
    default: ''
  },
  disabled: {
    type: Boolean,
    default: false
  }
})

const emit = defineEmits(['update:modelValue'])
const uploading = ref(false)

const isImage = computed(() => props.type === 'image')
const previewUrl = computed(() => normalizeAssetUrl(props.modelValue))
const downloadUrl = computed(() => downloadAsset(props.modelValue))
const buttonText = computed(() => (uploading.value ? '上传中' : isImage.value ? '上传图片' : '上传文件'))
const fileName = computed(() => {
  const raw = props.modelValue || ''
  return raw.includes('/') ? raw.slice(raw.lastIndexOf('/') + 1) : raw
})

async function handleUpload(options) {
  uploading.value = true
  try {
    const fileName = await uploadFile(options.file)
    emit('update:modelValue', fileName)
    ElMessage.success('上传成功')
    options.onSuccess?.({ file: fileName })
  } catch (error) {
    options.onError?.(error)
  } finally {
    uploading.value = false
  }
}
</script>

<style scoped>
.upload-control {
  display: grid;
  gap: 10px;
  justify-items: start;
}

.image-preview {
  position: relative;
  width: 72px;
  height: 72px;
  overflow: hidden;
  border: 1px solid #dce5f2;
  border-radius: 8px;
  background: #f6f9ff;
}

.image-preview img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.image-preview span {
  position: absolute;
  right: 0;
  bottom: 0;
  left: 0;
  height: 22px;
  background: rgba(23, 35, 61, 0.72);
  color: #fff;
  font-size: 12px;
  font-weight: 700;
  line-height: 22px;
  text-align: center;
}

.file-preview {
  display: inline-flex;
  align-items: center;
  gap: 10px;
  max-width: 320px;
  color: #526078;
  font-size: 13px;
  font-weight: 700;
}

.file-preview span {
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}
</style>
