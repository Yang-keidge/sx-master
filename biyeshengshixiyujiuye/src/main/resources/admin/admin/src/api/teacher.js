import { createCrudApi } from './crud'
import request from './request'

export const { page, info, save, update, remove, batchInsert } = createCrudApi('/laoshi')

export function session() {
  return request.get('/laoshi/session')
}
