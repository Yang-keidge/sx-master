import { createCrudApi } from './crud'
import request from './request'

export const { page, info, save, update, remove, batchInsert } = createCrudApi('/yingpin')

export function apply(zhaopinId) {
  return request.post(`/yingpin/apply/${zhaopinId}`)
}

export function accept(id) {
  return request.post(`/yingpin/accept/${id}`)
}
