import request from './request'

export function createCrudApi(basePath) {
  return {
    page(params = {}) {
      return request.get(`${basePath}/page`, { params })
    },
    info(id) {
      return request.get(`${basePath}/info/${id}`)
    },
    save(data) {
      return request.post(`${basePath}/save`, data)
    },
    update(data) {
      return request.post(`${basePath}/update`, data)
    },
    remove(ids) {
      return request.post(`${basePath}/delete`, ids)
    },
    batchInsert(fileName) {
      return request.post(`${basePath}/batchInsert`, null, {
        params: {
          fileName
        }
      })
    }
  }
}
