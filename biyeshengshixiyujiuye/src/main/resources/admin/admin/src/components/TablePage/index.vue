<template>
  <main class="management-page">
    <section class="page-heading">
      <div>
        <h1>{{ title }}</h1>
        <p v-if="subtitle">{{ subtitle }}</p>
      </div>
      <slot name="heading-extra" />
    </section>

    <section class="panel-card search-panel">
      <slot name="search" />
    </section>

    <section class="panel-card table-panel">
      <div class="table-toolbar">
        <slot name="toolbar" />
      </div>

      <slot name="table" />

      <footer class="pagination-row">
        <slot name="pagination" />
      </footer>
    </section>
  </main>
</template>

<script setup>
defineProps({
  title: {
    type: String,
    required: true
  },
  subtitle: {
    type: String,
    default: ''
  }
})
</script>

<style scoped>
.management-page {
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

.panel-card {
  border: 1px solid #e0e7f1;
  border-radius: 8px;
  background: #fff;
  box-shadow: 0 12px 26px rgba(46, 58, 92, 0.06);
}

.search-panel {
  margin-bottom: 20px;
  padding: 20px 20px 4px;
}

.table-panel {
  min-width: 0;
  padding: 18px 20px 20px;
}

.table-toolbar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 14px;
  margin-bottom: 16px;
}

.pagination-row {
  display: flex;
  justify-content: flex-end;
  margin-top: 18px;
}
</style>
