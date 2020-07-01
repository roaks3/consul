import fs from 'fs'
import path from 'path'
import { promisify } from 'util'
import matter from 'gray-matter'
import Head from 'next/head'
import Link from 'next/link'
import { MDXProvider } from '@mdx-js/react'
import hydrate from 'next-mdx-remote/hydrate'
import renderToString from 'next-mdx-remote/render-to-string'
import DocsPage from '@hashicorp/react-docs-page'
import {
  anchorLinks,
  includeMarkdown,
  paragraphCustomAlerts,
  typography,
} from '@hashicorp/remark-plugins'
import EnterpriseAlert from '../../components/enterprise-alert'
import { Tabs, Tab } from '../../components/tabs'
import docFiles from '../../data/.tmp/docs-files'
import sidenavData from '../../data/.tmp/docs-frontmatter'
import order from '../../data/docs-navigation.js'

const DEFAULT_COMPONENTS = { EnterpriseAlert, Tabs, Tab }

export default function DocsDocsPage({
  renderedContent,
  frontMatter,
  filePath,
  url,
}) {
  const hydratedContent = hydrate(renderedContent)
  return (
    <MDXProvider components={DEFAULT_COMPONENTS}>
      <DocsPage
        product="consul"
        head={{
          is: Head,
          title: `${frontMatter.page_title} | Consul by HashiCorp`,
          description: frontMatter.description,
          siteName: 'Consul by HashiCorp',
        }}
        sidenav={{
          Link,
          category: 'docs',
          currentPage: `/${url}`,
          data: sidenavData,
          order,
        }}
        resourceURL={`https://github.com/hashicorp/consul/blob/master/website/${filePath}`}
      >
        {hydratedContent}
      </DocsPage>
    </MDXProvider>
  )
}

export async function getStaticProps({ params }) {
  const filePath = `content/docs/${params.slug.join('/')}.mdx`
  const url = `docs/${params.slug.join('/')}`
  const fileContent = (
    await promisify(fs.readFile)(`${process.cwd()}/${filePath}`)
  ).toString()

  const { content, data } = matter(fileContent)
  const renderedContent = await renderToString(content, DEFAULT_COMPONENTS, {
    remarkPlugins: [
      [includeMarkdown, { resolveFrom: path.join(process.cwd(), 'partials') }],
      anchorLinks,
      paragraphCustomAlerts,
      typography,
    ],
  })

  return {
    props: {
      renderedContent,
      frontMatter: data,
      filePath,
      url,
    },
  }
}

export async function getStaticPaths() {
  const paths = docFiles.map((filePath) => ({
    params: {
      slug: filePath.replace(/\.mdx/, '').split('/'),
    },
  }))

  return {
    paths,
    fallback: false,
  }
}
