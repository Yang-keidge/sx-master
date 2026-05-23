<template>
  <div class="rich-editor">
    <div class="rich-toolbar">
      <button type="button" @click="exec('bold')">B</button>
      <button type="button" @click="exec('italic')">I</button>
      <button type="button" @click="exec('insertUnorderedList')">列表</button>
      <button type="button" @click="clear">清除格式</button>
    </div>
    <div
      ref="editorRef"
      class="rich-body"
      contenteditable="true"
      @input="syncValue"
      @blur="syncValue"
    ></div>
  </div>
</template>

<script setup>
import { nextTick, onMounted, ref, watch } from 'vue'

const props = defineProps({
  modelValue: {
    type: String,
    default: ''
  }
})

const emit = defineEmits(['update:modelValue'])
const editorRef = ref(null)
let internalUpdate = false

onMounted(() => setEditorHtml(props.modelValue))

watch(
  () => props.modelValue,
  (value) => {
    if (!internalUpdate) setEditorHtml(value)
    internalUpdate = false
  }
)

function setEditorHtml(value) {
  nextTick(() => {
    if (editorRef.value && editorRef.value.innerHTML !== (value || '')) {
      editorRef.value.innerHTML = value || ''
    }
  })
}

function syncValue() {
  internalUpdate = true
  emit('update:modelValue', editorRef.value?.innerHTML || '')
}

function exec(command) {
  editorRef.value?.focus()
  document.execCommand(command)
  syncValue()
}

function clear() {
  editorRef.value?.focus()
  document.execCommand('removeFormat')
  syncValue()
}
</script>

<style scoped>
.rich-editor {
  width: 100%;
  overflow: hidden;
  border: 1px solid #dcdfe6;
  border-radius: 6px;
  background: #fff;
}

.rich-toolbar {
  display: flex;
  align-items: center;
  gap: 8px;
  min-height: 38px;
  padding: 6px 8px;
  border-bottom: 1px solid #e5eaf3;
  background: #f8fafc;
}

.rich-toolbar button {
  height: 26px;
  padding: 0 9px;
  border: 1px solid #d8e1ef;
  border-radius: 5px;
  background: #fff;
  color: #27344d;
  font-size: 12px;
  font-weight: 800;
}

.rich-body {
  min-height: 150px;
  max-height: 260px;
  padding: 10px 12px;
  overflow-y: auto;
  color: #26324a;
  line-height: 1.7;
  outline: none;
}
</style>
