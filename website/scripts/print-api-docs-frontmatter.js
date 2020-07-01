const fs = require('fs')
const { promisify } = require('util')
const matter = require('gray-matter')
const filePaths = require('../data/.tmp/api-docs-files')

async function getAllFrontMatter() {
  const files = await Promise.all(
    filePaths.map((filePath) =>
      promisify(fs.readFile)(`${process.cwd()}/content/api-docs/${filePath}`)
    )
  )

  return filePaths.map((filePath, index) => ({
    ...matter(files[index].toString()).data,
    __resourcePath: `api-docs/${filePath}`,
  }))
}

function printAllFrontMatter() {
  getAllFrontMatter().then((allFrontMatter) => {
    console.log('module.exports = [')
    allFrontMatter.forEach((frontMatter) =>
      console.log(`  ${JSON.stringify(frontMatter)},`)
    )
    console.log(']')
  })
}

printAllFrontMatter()
