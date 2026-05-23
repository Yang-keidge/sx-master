import { createCrudApi } from './crud'

export const { page, info, save, update, remove, batchInsert } = createCrudApi('/shixi')
