const fs = require('fs')
const { promisify } = require('util')

async function getAllFilesRecursively(dirPath) {
  const files = await promisify(fs.readdir)(dirPath, {
    withFileTypes: true,
  })

  const childFilePaths = files
    .filter((file) => file.isFile())
    .map((file) => `${dirPath}/${file.name}`)

  const descendantFilePaths = (
    await Promise.all(
      files
        .filter((file) => file.isDirectory())
        .map((file) => getAllFilesRecursively(`${dirPath}/${file.name}`))
    )
  ).reduce((acc, val) => acc.concat(val), [])

  return [...childFilePaths, ...descendantFilePaths]
}

function printAllFilesRecursively(dirPath) {
  getAllFilesRecursively(dirPath).then((filePaths) => {
    console.log('module.exports = [')
    filePaths.forEach((filePath) =>
      console.log(`  '${filePath.replace(new RegExp(`^${dirPath}/`), '')}',`)
    )
    console.log(']')
  })
}

printAllFilesRecursively(`${process.cwd()}/content/docs`)
