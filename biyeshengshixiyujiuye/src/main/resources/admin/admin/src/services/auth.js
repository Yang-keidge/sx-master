const API_BASE = import.meta.env.VITE_API_BASE || '/api'

const roleEndpoints = {
  admin: 'users',
  student: 'xuesheng',
  teacher: 'laoshi',
  company: 'qiye'
}

export async function loginByRole(role, payload) {
  const endpoint = roleEndpoints[role]

  if (!endpoint) {
    throw new Error('请选择登录角色')
  }

  const body = new URLSearchParams()
  body.set('username', payload.username)
  body.set('password', payload.password)
  body.set('captcha', payload.captcha || '')

  const response = await fetch(`${API_BASE}/${endpoint}/login`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8'
    },
    body
  })

  if (!response.ok) {
    throw new Error(`登录请求失败：${response.status}`)
  }

  const result = await response.json()

  if (result.code !== 0) {
    throw new Error(result.msg || '账号或密码不正确')
  }

  return {
    ...result,
    tableName: result.tableName || endpoint
  }
}
