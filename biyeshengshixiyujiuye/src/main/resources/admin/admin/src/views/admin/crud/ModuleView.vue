<template>
  <CrudPage v-if="config" :key="moduleName" :config="config" />
  <PlaceholderView v-else />
</template>

<script setup>
import { computed } from 'vue'
import PlaceholderView from '../PlaceholderView.vue'
import CrudPage from './CrudPage.vue'
import { moduleConfigs } from './modules'

const props = defineProps({
  moduleName: {
    type: String,
    required: true
  }
})

const config = computed(() => moduleConfigs[props.moduleName])
</script>
