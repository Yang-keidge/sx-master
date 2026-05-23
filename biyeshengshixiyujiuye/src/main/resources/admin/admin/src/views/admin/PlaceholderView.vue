<template>
  <main class="placeholder-page">
    <section class="placeholder-card">
      <span class="placeholder-icon">
        <LayoutDashboard :size="32" stroke-width="2.2" />
      </span>
      <h1>{{ title }}</h1>
      <p>页面框架已接入左侧菜单和路由，业务表格、筛选、表单与接口将在后续按模块实现。</p>
    </section>
  </main>
</template>

<script setup>
import { computed } from 'vue'
import { useRoute } from 'vue-router'
import { LayoutDashboard } from 'lucide-vue-next'

const route = useRoute()
const title = computed(() => route.meta.title || '管理页面')
</script>

<style scoped>
.placeholder-page {
  min-width: 1026px;
  padding: 28px 40px 54px;
}

.placeholder-card {
  display: grid;
  justify-items: center;
  gap: 16px;
  min-height: 420px;
  padding: 68px 28px;
  border: 1px solid #e0e7f1;
  border-radius: 12px;
  background: #fff;
  box-shadow: 0 14px 34px rgba(46, 58, 92, 0.06);
  text-align: center;
}

.placeholder-icon {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 72px;
  height: 72px;
  border-radius: 18px;
  background: #edf3ff;
  color: #3f5fff;
}

.placeholder-card h1 {
  margin: 0;
  color: #17233d;
  font-size: 26px;
  font-weight: 900;
}

.placeholder-card p {
  max-width: 560px;
  margin: 0;
  color: #6c7890;
  font-size: 15px;
  font-weight: 700;
  line-height: 1.8;
}

</style>
