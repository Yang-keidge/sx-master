export function formatStudentClass(row = {}) {
  const rawMajor = row.banjiValue || row.banjiName || row.banjiTypes || ''
  const year = row.ruxueYear || ''
  const major = String(rawMajor).replace(/\s*\d{4}级?$/, '')

  if (major && year) return `${major}${year}级`
  if (rawMajor) return String(rawMajor)
  if (year) return `${year}级`
  return ''
}
