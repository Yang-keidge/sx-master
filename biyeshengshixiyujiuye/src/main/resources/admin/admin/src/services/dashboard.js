const API_BASE = import.meta.env.VITE_API_BASE || '/api'

export async function fetchDashboardSummary() {
  const token = localStorage.getItem('Token')
  const response = await fetch(`${API_BASE}/dashboard/summary`, {
    headers: {
      Token: token || ''
    }
  })

  if (!response.ok) {
    throw new Error(`首页数据请求失败：${response.status}`)
  }

  const result = await response.json()

  if (result.code !== 0) {
    throw new Error(result.msg || '首页数据加载失败')
  }

  return result.data
}
