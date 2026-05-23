import { createCrudApi } from './crud'
import request from './request'

export const { page, info, save, update, remove, batchInsert } = createCrudApi('/xuesheng')

export function session() {
  return request.get('/xuesheng/session')
}
