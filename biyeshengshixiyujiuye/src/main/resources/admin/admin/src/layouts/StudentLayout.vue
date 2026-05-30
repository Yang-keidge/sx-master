<template>
  <div class="student-layout">
    <aside class="student-sidebar">
      <RouterLink class="brand-block" :to="{ name: 'student.dashboard' }" aria-label="返回学生首页">
        <span class="brand-icon">
          <GraduationCap :size="27" stroke-width="2.4" />
        </span>
        <span>
          <strong>实习信息管理系统</strong>
          <small>学生端</small>
        </span>
      </RouterLink>

      <nav class="sidebar-nav" aria-label="学生端菜单">
        <section v-for="section in studentSidebarSections" :key="section.title || 'main'" class="nav-section">
          <h2 v-if="section.title">{{ section.title }}</h2>
          <RouterLink v-for="item in section.items" :key="item.routeName" class="nav-item" :to="{ name: item.routeName }">
            <component :is="item.icon" :size="19" stroke-width="2" />
            <span>{{ item.label }}</span>
          </RouterLink>
        </section>
      </nav>
    </aside>

    <div class="student-main">
      <header class="student-topbar">
        <div class="mobile-title">
          <strong>实习信息管理系统</strong>
          <span>学生端</span>
        </div>

        <div class="profile-dropdown">
          <button class="profile-wrap" type="button" aria-haspopup="menu">
            <span class="avatar-wrap">
              <img v-if="studentPhoto" :src="studentPhoto" alt="" />
              <span v-else>{{ studentInitial }}</span>
            </span>
            <span class="profile-copy">
              <strong>{{ studentName }}</strong>
              <small>{{ studentNumber }}</small>
            </span>
            <ChevronDown :size="17" stroke-width="2" />
          </button>
          <div class="profile-menu" role="menu">
            <button class="profile-menu-item" type="button" role="menuitem" @click="logout">
              <LogOut :size="16" stroke-width="2" />
              <span>退出登录</span>
            </button>
          </div>
        </div>
      </header>

      <RouterView />
    </div>
  </div>
</template>

<script setup>
import { computed, onMounted, ref } from 'vue'
import { RouterLink, RouterView, useRouter } from 'vue-router'
import { ChevronDown, GraduationCap, LogOut } from 'lucide-vue-next'
import { studentSidebarSections } from '../data/studentNavigation'
import { session } from '../api/student'
import { normalizeAssetUrl } from '../api/request'

const router = useRouter()
const student = ref(null)

onMounted(async () => {
  try {
    const result = await session()
    student.value = result.data || null
    updateStoredUser(student.value)
  } catch {
    student.value = null
  }
})

const currentUser = computed(() => {
  try {
    return JSON.parse(localStorage.getItem('currentUser') || '{}')
  } catch {
    return {}
  }
})

const studentName = computed(() => student.value?.xueshengName || currentUser.value?.username || '学生用户')
const studentNumber = computed(() => student.value?.xueshengXuehao || currentUser.value?.studentNumber || '学生端')
const studentPhoto = computed(() => normalizeAssetUrl(student.value?.xueshengPhoto))
const studentInitial = computed(() => studentName.value.slice(0, 1) || '学')

function updateStoredUser(data) {
  if (!data) return

  const stored = currentUser.value || {}
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

function logout() {
  localStorage.removeItem('Token')
  localStorage.removeItem('currentUser')
  router.replace({ name: 'login' })
}
</script>

<style scoped>
.student-layout {
  display: grid;
  grid-template-columns: 254px minmax(0, 1fr);
  min-width: 1280px;
  min-height: 100vh;
  background: #f8fafc;
  color: #17233d;
}

.student-sidebar {
  position: sticky;
  top: 0;
  display: grid;
  grid-template-rows: auto 1fr;
  height: 100vh;
  border-right: 1px solid #dfe5ef;
  background: rgba(255, 255, 255, 0.94);
  box-shadow: 8px 0 30px rgba(42, 58, 92, 0.04);
}

.brand-block {
  display: grid;
  grid-template-columns: 42px 1fr;
  gap: 12px;
  align-items: center;
  min-height: 76px;
  padding: 16px 18px;
  border-bottom: 1px solid #e2e8f2;
  color: #18243d;
  text-decoration: none;
}

.brand-icon {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 42px;
  height: 42px;
  border-radius: 10px;
  background: linear-gradient(135deg, #3f5fff, #6479ff);
  color: #fff;
  box-shadow: 0 12px 24px rgba(63, 95, 255, 0.2);
}

.brand-block strong {
  display: block;
  margin-bottom: 5px;
  font-size: 17px;
  font-weight: 800;
  line-height: 1.15;
}

.brand-block small {
  color: #6e7b91;
  font-size: 13px;
  font-weight: 700;
}

.sidebar-nav {
  min-height: 0;
  padding: 18px 16px;
  overflow-y: auto;
}

.nav-section + .nav-section {
  margin-top: 21px;
}

.nav-section h2 {
  margin: 0 0 12px 8px;
  color: #8b97aa;
  font-size: 13px;
  font-weight: 800;
  line-height: 1.4;
}

.nav-item {
  display: grid;
  grid-template-columns: 22px 1fr;
  align-items: center;
  gap: 12px;
  min-height: 39px;
  padding: 0 10px;
  border-radius: 8px;
  color: #536078;
  font-size: 15px;
  font-weight: 800;
  text-decoration: none;
  transition:
    background 0.16s ease,
    color 0.16s ease;
}

.nav-item + .nav-item {
  margin-top: 5px;
}

.nav-item:hover,
.nav-item.router-link-active {
  background: #f0f4fb;
  color: #3657ff;
}

.student-main {
  min-width: 0;
}

.student-topbar {
  display: flex;
  align-items: center;
  justify-content: flex-end;
  height: 70px;
  padding: 0 32px;
  background: rgba(255, 255, 255, 0.52);
}

.mobile-title {
  display: none;
}

.profile-wrap {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 0;
  background: transparent;
  color: #26324a;
  font-size: 15px;
  font-weight: 800;
}

.profile-copy {
  display: grid;
  justify-items: start;
  gap: 3px;
  min-width: 0;
}

.profile-copy strong,
.profile-copy small {
  max-width: 148px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.profile-copy small {
  color: #748097;
  font-size: 12px;
  font-weight: 800;
}

.profile-dropdown {
  position: relative;
}

.profile-menu {
  position: absolute;
  top: calc(100% + 10px);
  right: 0;
  z-index: 20;
  min-width: 132px;
  padding: 6px;
  border: 1px solid #dfe5ef;
  border-radius: 8px;
  background: #fff;
  box-shadow: 0 14px 28px rgba(42, 58, 92, 0.12);
  opacity: 0;
  pointer-events: none;
  transform: translateY(-4px);
  transition:
    opacity 0.16s ease,
    transform 0.16s ease;
}

.profile-dropdown:hover .profile-menu,
.profile-dropdown:focus-within .profile-menu {
  opacity: 1;
  pointer-events: auto;
  transform: translateY(0);
}

.profile-menu-item {
  display: flex;
  align-items: center;
  gap: 8px;
  width: 100%;
  height: 36px;
  padding: 0 10px;
  border-radius: 6px;
  background: transparent;
  color: #536078;
  font-size: 14px;
  font-weight: 800;
}

.profile-menu-item:hover {
  background: #f0f4fb;
  color: #3657ff;
}

.avatar-wrap {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 38px;
  height: 38px;
  overflow: hidden;
  border: 2px solid #d9e2ef;
  border-radius: 50%;
  background: linear-gradient(135deg, #e9eff8, #f8fbff);
  color: #3657ff;
  font-size: 15px;
  font-weight: 900;
}

.avatar-wrap img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}
</style>
