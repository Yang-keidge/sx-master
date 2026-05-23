<template>
  <CrudPage v-if="config" :key="moduleName" :config="config" />
  <PlaceholderView v-else />
</template>

<script setup>
import { computed } from 'vue'
import PlaceholderView from '../../admin/PlaceholderView.vue'
import CrudPage from '../../admin/crud/CrudPage.vue'
import { studentModuleConfigs } from './modules'

const props = defineProps({
  moduleName: {
    type: String,
    required: true
  }
})

const config = computed(() => studentModuleConfigs[props.moduleName])
</script>
