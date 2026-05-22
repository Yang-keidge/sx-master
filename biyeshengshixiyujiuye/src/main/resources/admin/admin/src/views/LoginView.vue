<template>
  <main class="login-page">
    <section class="login-shell" aria-label="实习就业管理系统登录">
      <div class="brand-panel">
        <div class="brand-copy">
          <h1>实习就业管理系统</h1>
          <p>高效管理实习与就业全过程，助力学生成长与发展</p>
        </div>

        <div class="visual-wrap" aria-hidden="true">
          <img class="login-visual" src="../assets/login/login-illustration.png" alt="" />
        </div>
      </div>

      <form class="login-card" @submit.prevent="submitLogin">
        <header class="login-card-header">
          <h2>欢迎登录</h2>
          <p>请输入您的账号和密码</p>
        </header>

        <label class="field-group" for="username">
          <span>账号</span>
          <div class="control">
            <UserRound :size="19" stroke-width="2" />
            <input
              id="username"
              v-model.trim="form.username"
              autocomplete="username"
              placeholder="请输入账号"
              type="text"
              @input="clearMessage"
            />
          </div>
        </label>

        <label class="field-group" for="password">
          <span>密码</span>
          <div class="control">
            <LockKeyhole :size="19" stroke-width="2" />
            <input
              id="password"
              v-model="form.password"
              autocomplete="current-password"
              placeholder="请输入密码"
              :type="showPassword ? 'text' : 'password'"
              @input="clearMessage"
            />
            <button
              class="icon-button"
              type="button"
              :aria-label="showPassword ? '隐藏密码' : '显示密码'"
              :title="showPassword ? '隐藏密码' : '显示密码'"
              @click="showPassword = !showPassword"
            >
              <EyeOff v-if="showPassword" :size="18" stroke-width="2" />
              <Eye v-else :size="18" stroke-width="2" />
            </button>
          </div>
        </label>

        <label class="field-group" for="role">
          <span>角色</span>
          <div class="control select-control">
            <UsersRound :size="19" stroke-width="2" />
            <select
              id="role"
              v-model="selectedStandardRole"
              :class="{ 'is-empty': !selectedStandardRole }"
              aria-label="请选择角色"
            >
              <option disabled value="">请选择角色</option>
              <option v-for="role in roles" :key="role.value" :value="role.value">
                {{ role.label }}
              </option>
            </select>
            <ChevronDown class="select-arrow" :size="18" stroke-width="2" />
          </div>
        </label>

        <div class="form-options">
          <label class="remember-option">
            <input v-model="form.remember" type="checkbox" />
            <span>记住我</span>
          </label>
          <button class="link-button" type="button" @click="showResetHint">忘记密码?</button>
        </div>

        <p v-if="message.text" class="form-message" :class="message.type" role="status">
          {{ message.text }}
        </p>

        <button class="login-submit" type="submit" :disabled="isSubmitting">
          <LoaderCircle v-if="isSubmitting" class="spin" :size="18" stroke-width="2.2" />
          <span>{{ isSubmitting ? '登录中' : '登 录' }}</span>
        </button>

        <div class="alternate-login" aria-label="其他登录方式">
          <div class="divider"><span>其他登录方式</span></div>
          <button
            class="admin-login"
            :class="{ 'is-active': form.role === 'admin' }"
            type="button"
            title="切换到管理员角色"
            :aria-pressed="form.role === 'admin'"
            @click="selectAdminRole"
          >
            <span class="admin-icon">
              <ShieldCheck :size="24" stroke-width="2.3" />
            </span>
            <strong>管理员登录</strong>
          </button>
        </div>
      </form>
    </section>

    <footer class="copyright">© 2025 实习就业管理系统 版权所有</footer>
  </main>
</template>

<script setup>
import { computed, onBeforeUnmount, onMounted, reactive, ref } from 'vue'
import {
  ChevronDown,
  Eye,
  EyeOff,
  LoaderCircle,
  LockKeyhole,
  ShieldCheck,
  UserRound,
  UsersRound
} from 'lucide-vue-next'
import { loginByRole } from '../services/auth'

const roles = [
  { label: '学生', value: 'student' },
  { label: '老师', value: 'teacher' },
  { label: '企业', value: 'company' }
]

const form = reactive({
  username: '',
  password: '',
  role: '',
  remember: false
})

const showPassword = ref(false)
const isSubmitting = ref(false)
const messageTimer = ref(null)
const message = reactive({
  type: '',
  text: ''
})

const selectedStandardRole = computed({
  get() {
    return roles.some((role) => role.value === form.role) ? form.role : ''
  },
  set(value) {
    form.role = value
    clearMessage()
  }
})

onMounted(() => {
  const remembered = localStorage.getItem('login.remembered')
  if (!remembered) return

  try {
    const data = JSON.parse(remembered)
    form.username = data.username || ''
    form.role = data.role || ''
    form.remember = Boolean(data.username || data.role)
  } catch {
    localStorage.removeItem('login.remembered')
  }
})

onBeforeUnmount(() => {
  if (messageTimer.value) {
    window.clearTimeout(messageTimer.value)
  }
})

function clearMessage() {
  if (messageTimer.value) {
    window.clearTimeout(messageTimer.value)
    messageTimer.value = null
  }

  message.type = ''
  message.text = ''
}

function setMessage(type, text, duration = 0) {
  if (messageTimer.value) {
    window.clearTimeout(messageTimer.value)
    messageTimer.value = null
  }

  message.type = type
  message.text = text

  if (duration > 0) {
    messageTimer.value = window.setTimeout(() => {
      message.type = ''
      message.text = ''
      messageTimer.value = null
    }, duration)
  }
}

function persistRememberedLogin() {
  if (form.remember) {
    localStorage.setItem(
      'login.remembered',
      JSON.stringify({
        username: form.username,
        role: form.role
      })
    )
    return
  }

  localStorage.removeItem('login.remembered')
}

function selectAdminRole() {
  form.role = 'admin'
  clearMessage()
}

function showResetHint() {
  setMessage('info', '请联系管理员重置密码', 3000)
}

async function submitLogin() {
  if (!form.username) {
    setMessage('error', '请输入账号')
    return
  }

  if (!form.password) {
    setMessage('error', '请输入密码')
    return
  }

  if (!form.role) {
    setMessage('error', '请选择角色')
    return
  }

  isSubmitting.value = true
  setMessage('', '')

  try {
    const result = await loginByRole(form.role, {
      username: form.username,
      password: form.password
    })

    localStorage.setItem('Token', result.token)
    localStorage.setItem(
      'currentUser',
      JSON.stringify({
        userId: result.userId,
        username: result.username || form.username,
        role: result.role,
        tableName: result.tableName
      })
    )
    persistRememberedLogin()
    setMessage('success', '登录成功，正在进入系统')
  } catch (error) {
    setMessage('error', error.message || '登录失败，请稍后重试')
  } finally {
    isSubmitting.value = false
  }
}
</script>

<style scoped>
.login-page {
  position: relative;
  display: flex;
  min-height: 100vh;
  padding: clamp(28px, 5vh, 52px) clamp(18px, 3vw, 46px) 54px;
  overflow: hidden;
  background:
    radial-gradient(circle at 8% 4%, rgba(67, 113, 245, 0.11) 0 11rem, transparent 11.1rem),
    radial-gradient(circle at 53% 100%, rgba(71, 119, 245, 0.08) 0 18rem, transparent 18.1rem),
    linear-gradient(145deg, #f8fbff 0%, #f4f7ff 48%, #fbfcff 100%);
}

.login-shell {
  position: relative;
  z-index: 1;
  display: grid;
  grid-template-columns: minmax(0, 1fr) minmax(430px, 540px);
  gap: clamp(34px, 4vw, 64px);
  width: min(1480px, 100%);
  min-height: min(780px, calc(100vh - 112px));
  margin: auto;
  padding: clamp(46px, 7vh, 72px) clamp(40px, 6vw, 86px);
  overflow: hidden;
  border: 1px solid rgba(185, 199, 225, 0.45);
  border-radius: 20px;
  background: rgba(255, 255, 255, 0.68);
  box-shadow: 0 18px 54px rgba(46, 79, 128, 0.12);
  backdrop-filter: blur(14px);
}

.login-shell::before,
.login-shell::after {
  position: absolute;
  z-index: -1;
  border-radius: 999px;
  background: rgba(64, 108, 237, 0.07);
  content: "";
}

.login-shell::before {
  width: 430px;
  height: 430px;
  left: -110px;
  top: -190px;
}

.login-shell::after {
  width: 540px;
  height: 540px;
  right: 18%;
  bottom: -330px;
}

.brand-panel {
  display: grid;
  align-content: center;
  grid-template-rows: auto minmax(360px, 1fr);
  min-width: 0;
  padding: 28px 0 18px;
}

.brand-copy {
  margin-left: 0;
}

.brand-copy h1 {
  margin: 0 0 20px;
  color: #102148;
  font-size: clamp(32px, 3vw, 46px);
  font-weight: 800;
  line-height: 1.14;
  letter-spacing: 0;
}

.brand-copy p {
  max-width: 620px;
  margin: 0;
  color: #6e7d98;
  font-size: clamp(15px, 1.35vw, 18px);
  font-weight: 500;
  line-height: 1.7;
  letter-spacing: 0;
}

.visual-wrap {
  display: flex;
  align-items: center;
  justify-content: flex-start;
  min-height: 315px;
  margin: clamp(14px, 2vh, 28px) 0 0;
}

.login-visual {
  display: block;
  width: min(860px, 120%);
  max-width: none;
  height: auto;
  object-fit: contain;
  filter: drop-shadow(0 20px 26px rgba(41, 87, 178, 0.08));
  transform: translateX(-104px);
}

.login-card {
  align-self: center;
  width: 100%;
  min-height: 620px;
  padding: 52px 48px 44px;
  border: 1px solid rgba(232, 237, 248, 0.92);
  border-radius: 12px;
  background: rgba(255, 255, 255, 0.88);
  box-shadow: 0 24px 52px rgba(49, 69, 111, 0.11);
}

.login-card-header {
  margin-bottom: 40px;
  text-align: center;
}

.login-card-header h2 {
  margin: 0 0 12px;
  color: #14254a;
  font-size: 30px;
  font-weight: 800;
  line-height: 1.2;
  letter-spacing: 0;
}

.login-card-header p {
  margin: 0;
  color: #6b7891;
  font-size: 15px;
  font-weight: 600;
  letter-spacing: 0;
}

.field-group {
  display: block;
  margin-bottom: 27px;
}

.field-group > span {
  display: block;
  margin-bottom: 10px;
  color: #182641;
  font-size: 15px;
  font-weight: 800;
  line-height: 1.35;
}

.control {
  display: flex;
  align-items: center;
  width: 100%;
  height: 44px;
  padding: 0 14px;
  border: 1px solid #dbe3f0;
  border-radius: 8px;
  background: rgba(255, 255, 255, 0.78);
  color: #53627e;
  transition:
    border-color 0.18s ease,
    box-shadow 0.18s ease,
    background 0.18s ease;
}

.control:focus-within {
  border-color: #4b67ff;
  background: #fff;
  box-shadow: 0 0 0 4px rgba(61, 91, 255, 0.1);
}

.control input,
.control select {
  min-width: 0;
  flex: 1;
  height: 100%;
  margin-left: 10px;
  border: 0;
  outline: 0;
  background: transparent;
  color: #1b2945;
  font-size: 15px;
  font-weight: 600;
  letter-spacing: 0;
}

.control input::placeholder {
  color: #a1abc0;
}

.icon-button {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 28px;
  height: 28px;
  margin-left: 8px;
  border-radius: 6px;
  background: transparent;
  color: #8b98b0;
  transition:
    background 0.16s ease,
    color 0.16s ease;
}

.icon-button:hover {
  background: #eef3ff;
  color: #425cff;
}

.select-control {
  position: relative;
}

.select-control select {
  appearance: none;
  padding-right: 28px;
  cursor: pointer;
}

.select-control select {
  color: #1b2945;
}

.select-control select.is-empty {
  color: #8f9bb1;
}

.select-arrow {
  position: absolute;
  right: 13px;
  color: #8b98b0;
  pointer-events: none;
}

.form-options {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 16px;
  margin: -2px 0 28px;
}

.remember-option {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  color: #526079;
  font-size: 14px;
  font-weight: 600;
  white-space: nowrap;
}

.remember-option input {
  width: 15px;
  height: 15px;
  margin: 0;
  accent-color: #405eff;
}

.link-button {
  padding: 0;
  background: transparent;
  color: #4965ff;
  font-size: 14px;
  font-weight: 700;
  white-space: nowrap;
}

.link-button:hover {
  color: #263df2;
}

.form-message {
  min-height: 22px;
  margin: -12px 0 12px;
  font-size: 13px;
  font-weight: 700;
  line-height: 1.5;
}

.form-message.error {
  color: #e14f57;
}

.form-message.success {
  color: #12815c;
}

.form-message.info {
  color: #4965ff;
}

.login-submit {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  width: 100%;
  height: 46px;
  border-radius: 8px;
  background: linear-gradient(90deg, #3958ff 0%, #2f53f6 100%);
  color: #fff;
  box-shadow: 0 10px 18px rgba(54, 84, 255, 0.24);
  font-size: 15px;
  font-weight: 800;
  line-height: 1;
  transition:
    transform 0.16s ease,
    box-shadow 0.16s ease,
    opacity 0.16s ease;
}

.login-submit:not(:disabled):hover {
  transform: translateY(-1px);
  box-shadow: 0 14px 24px rgba(54, 84, 255, 0.28);
}

.login-submit:disabled {
  cursor: not-allowed;
  opacity: 0.72;
}

.spin {
  animation: spin 0.9s linear infinite;
}

.alternate-login {
  margin-top: 34px;
  text-align: center;
}

.divider {
  display: flex;
  align-items: center;
  gap: 14px;
  color: #8b97ad;
  font-size: 13px;
  font-weight: 700;
}

.divider::before,
.divider::after {
  flex: 1;
  height: 1px;
  background: #e0e6f0;
  content: "";
}

.admin-login {
  display: inline-grid;
  justify-items: center;
  gap: 10px;
  margin-top: 24px;
  padding: 0;
  background: transparent;
  color: #6f7b92;
  font-size: 13px;
  font-weight: 800;
}

.admin-icon {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 52px;
  height: 52px;
  border-radius: 50%;
  background: #edf3ff;
  color: #3f5fff;
  box-shadow: 0 10px 24px rgba(46, 80, 183, 0.1);
  transition:
    transform 0.16s ease,
    background 0.16s ease;
}

.admin-login:hover .admin-icon {
  transform: translateY(-1px);
  background: #e3ecff;
}

.admin-login.is-active {
  color: #3657ff;
}

.admin-login.is-active .admin-icon {
  background: #3f5fff;
  color: #fff;
  box-shadow: 0 12px 26px rgba(54, 84, 255, 0.24);
}

.copyright {
  position: absolute;
  left: 50%;
  bottom: 22px;
  transform: translateX(-50%);
  color: #79869c;
  font-size: 14px;
  font-weight: 600;
  white-space: nowrap;
}

@keyframes spin {
  to {
    transform: rotate(360deg);
  }
}

@media (max-width: 1180px) {
  .login-shell {
    grid-template-columns: minmax(0, 1fr) minmax(360px, 420px);
    gap: 34px;
    padding: 40px;
  }

  .login-card {
    padding: 44px 36px 38px;
  }
}

@media (max-width: 930px) {
  .login-page {
    padding: 18px 14px 46px;
  }

  .login-shell {
    grid-template-columns: 1fr;
    min-height: auto;
    padding: 34px 22px 28px;
  }

  .brand-panel {
    grid-template-rows: auto auto;
    padding: 0;
  }

  .brand-copy {
    margin-left: 0;
    text-align: center;
  }

  .brand-copy p {
    margin-inline: auto;
  }

  .visual-wrap {
    justify-content: center;
    min-height: auto;
    margin-top: 16px;
  }

  .login-visual {
    width: min(600px, 100%);
    transform: none;
  }

  .login-card {
    width: min(460px, 100%);
    min-height: auto;
    margin: 0 auto;
  }
}

@media (max-width: 560px) {
  .login-shell {
    padding: 28px 16px 22px;
    border-radius: 14px;
  }

  .brand-copy h1 {
    font-size: 28px;
  }

  .brand-copy p {
    font-size: 14px;
  }

  .visual-wrap {
    display: none;
  }

  .login-card {
    padding: 32px 18px 28px;
  }

  .login-card-header {
    margin-bottom: 28px;
  }

  .login-card-header h2 {
    font-size: 25px;
  }

  .field-group {
    margin-bottom: 20px;
  }

  .form-options {
    align-items: flex-start;
    margin-bottom: 22px;
  }
}
</style>
