export function formatStudentClass(row = {}) {
  const className = row.banjiValue || row.banjiName || ''
  if (className) return String(className)

  const rawMajor = row.zhuanyeValue || row.zhuanyeName || row.zhuanyeTypes || ''
  const year = row.ruxueYear || ''
  const shortYear = String(year).slice(-2)

  if (rawMajor && shortYear) return `${rawMajor}${shortYear}级`
  if (rawMajor) return String(rawMajor)
  if (year) return `${year}级`
  if (row.banjiTypes) return `班级 ${row.banjiTypes}`
  return ''
}
