import request from './request'
import { createCrudApi } from './crud'

const api = createCrudApi('/dictionary')

export const { page, info, save, update, remove, batchInsert } = api

export async function getDictionary(type) {
  const result = await page({
    page: 1,
    limit: 1000,
    dicCode: type,
    orderBy: 'code_index'
  })
  return result.data?.list || []
}

export function maxCodeIndex(dicCode) {
  return request.post('/dictionary/maxCodeIndex', {
    dicCode
  })
}
