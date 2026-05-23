import axios from 'axios'
import { ElMessage } from 'element-plus'

export const API_BASE = import.meta.env.VITE_API_BASE || '/api'

const request = axios.create({
  baseURL: API_BASE,
  timeout: 20000
})

request.interceptors.request.use((config) => {
  const token = localStorage.getItem('Token')
  if (token) {
    config.headers.Token = token
  }
  return config
})

request.interceptors.response.use(
  (response) => {
    const result = response.data
    if (result && typeof result === 'object' && Object.prototype.hasOwnProperty.call(result, 'code')) {
      if (Number(result.code) !== 0) {
        const message = result.msg || '请求失败'
        ElMessage.error(message)
        return Promise.reject(new Error(message))
      }
      return result
    }
    return result
  },
  (error) => {
    const message = error.response?.data?.msg || error.message || '网络请求失败'
    ElMessage.error(message)
    return Promise.reject(error)
  }
)

export function normalizeAssetUrl(value) {
  const raw = String(value || '').trim()
  if (!raw) return ''
  if (/^(data:|blob:|https?:\/\/)/i.test(raw)) return raw
  if (raw.startsWith('/api/')) return raw
  if (raw.startsWith('/upload/')) return `${API_BASE}${raw}`

  const uploadIndex = raw.indexOf('/upload/')
  if (uploadIndex >= 0) {
    return `${API_BASE}/upload/${raw.slice(uploadIndex + '/upload/'.length)}`
  }

  if (raw.startsWith('/')) return raw
  return `${API_BASE}/upload/${raw}`
}

export function downloadAsset(value) {
  const raw = String(value || '').trim()
  if (!raw) return ''
  if (/^https?:\/\//i.test(raw)) return raw
  const fileName = raw.includes('/upload/') ? raw.slice(raw.lastIndexOf('/upload/') + 8) : raw
  return `${API_BASE}/file/download?fileName=${encodeURIComponent(fileName)}`
}

export async function uploadFile(file) {
  const formData = new FormData()
  formData.append('file', file)
  const result = await request.post('/file/upload', formData, {
    headers: {
      'Content-Type': 'multipart/form-data'
    }
  })
  return result.file
}

export default request
