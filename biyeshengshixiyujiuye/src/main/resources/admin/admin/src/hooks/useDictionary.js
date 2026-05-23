import { computed, reactive } from 'vue'
import { getDictionary } from '../api/dictionary'

const cache = reactive({})
const loading = reactive({})

const fallbackLabels = {
  sex_types: '性别',
  yuanxi_types: '院系',
  banji_types: '班级',
  qiye_types: '行业',
  gonggao_types: '公告类型',
  shixi_types: '实习类型',
  shixi_jieguo_types: '实习结果'
}

export function useDictionary() {
  async function ensure(type) {
    if (!type || cache[type]) return cache[type] || []
    if (loading[type]) return loading[type]

    loading[type] = getDictionary(type)
      .then((list) => {
        cache[type] = list.map((item) => ({
          label: item.indexName,
          value: item.codeIndex,
          raw: item
        }))
        return cache[type]
      })
      .catch(() => {
        cache[type] = []
        return cache[type]
      })
      .finally(() => {
        delete loading[type]
      })

    return loading[type]
  }

  function getOptions(type) {
    ensure(type).catch(() => [])
    return computed(() => cache[type] || [])
  }

  function getLabel(type, value, fallback = '') {
    const options = cache[type] || []
    const found = options.find((item) => String(item.value) === String(value))
    return found?.label || fallback || (value == null || value === '' ? '' : `${fallbackLabels[type] || '字典'} ${value}`)
  }

  function clearDictionary(type) {
    if (type) {
      delete cache[type]
      return
    }

    Object.keys(cache).forEach((key) => delete cache[key])
  }

  return {
    ensure,
    getOptions,
    getLabel,
    clearDictionary
  }
}
