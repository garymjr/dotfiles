import { workspace, FileSystemWatcher } from 'coc.nvim'
import { Prettier } from './types'

const prettier = require('prettier') as Prettier
/**
 * Prettier reads configuration from files
 */
const PRETTIER_CONFIG_FILES = [
  '.prettierrc',
  '.prettierrc.json',
  '.prettierrc.yaml',
  '.prettierrc.yml',
  '.prettierrc.js',
  'package.json',
  'prettier.config.js',
]

/**
 * Create a file watcher. Clears prettier's configuration cache on
 * file change, create, delete.
 * @returns disposable file system watcher.
 */
function fileListener(): FileSystemWatcher {
  const fileWatcher = workspace.createFileSystemWatcher(
    `**/{${PRETTIER_CONFIG_FILES.join(',')}}`
  )
  fileWatcher.onDidChange(prettier.clearConfigCache)
  fileWatcher.onDidCreate(prettier.clearConfigCache)
  fileWatcher.onDidDelete(prettier.clearConfigCache)
  return fileWatcher
}

export default fileListener
