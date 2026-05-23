import { createCrudApi } from './crud'
import request from './request'

export const { page, info, remove } = createCrudApi('/gonggaoComment')

export function save(data) {
  return request.post('/gonggaoComment/save', data)
}

export function update(data) {
  return request.post('/gonggaoComment/update', data)
}
