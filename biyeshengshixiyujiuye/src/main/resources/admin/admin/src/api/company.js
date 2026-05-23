import { createCrudApi } from './crud'
import request from './request'

export const { page, info, save, update, remove, batchInsert } = createCrudApi('/qiye')

export function session() {
  return request.get('/qiye/session')
}
