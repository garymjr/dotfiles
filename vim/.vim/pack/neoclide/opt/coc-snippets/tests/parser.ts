import UltiSnipsParser from '../src/ultisnipsParser'
import path from 'path'
import fs from 'fs'
import { TriggerKind } from '../src/types'
// tslint:disable: no-invalid-template-strings

describe('ultisnips parser', () => {

  it('basic parser works', async () => {
    let parser = new UltiSnipsParser('pyx')
    let file = path.join(__dirname, './files/basic.snippets')
    let res = await parser.parseUltisnipsFile(file)
    expect(res.snippets[0].body).toBe('${1:content} ${2:two} ${3} $1')
    expect(res.snippets[0].triggerKind).toBe(TriggerKind.LineBegin)
    expect(res.snippets[0].prefix).toBe('number')
    expect(res.snippets[0].description).toBe('number placeholder')
    expect(res.snippets[0].priority).toBe(-60)

    expect(res.snippets[1].prefix).toBe('with space')
    expect(res.snippets[1].description).toBe('space placeholder')
    expect(res.snippets[1].triggerKind).toBe(TriggerKind.LineBegin)

    expect(res.snippets[2].prefix).toBe('empty')
    expect(res.snippets[2].description).toBe('empty')
    expect(res.snippets[2].triggerKind).toBe(TriggerKind.WordBoundary)

    expect(res.snippets[3].prefix).toBe('inword')
    expect(res.snippets[3].triggerKind).toBe(TriggerKind.InWord)

    expect(res.snippets[4].prefix).toBe('.')
    expect(res.snippets[4].regex != null).toBe(true)

    expect(res.snippets[5].prefix).toBe('"')
    expect(res.snippets[5].triggerKind).toBe(TriggerKind.LineBegin)

    expect(res.snippets[6].prefix).toBe('f')
    expect(res.snippets[7].prefix).toBe('im')
  })

  it('transform parse works', async () => {
    let parser = new UltiSnipsParser('pyx')
    let file = path.join(__dirname, './files/transform.snippets')
    let res = await parser.parseUltisnipsFile(file)
    // tslint:disable-next-line: no-invalid-template-strings
    expect(res.snippets[0].body).toBe('${VISUAL/(?<name>\\w+)/, /g}')
    expect(res.snippets[1].body).toBe('${1/^(?<word>[a-z]+)!\\k<word>$/$1/g}')
  })

  it('should resolve VISUAL', async () => {
    let parser = new UltiSnipsParser('pyx')
    let res = await parser.resolveUltisnipsBody('a $VISUAL b')
    expect(res).toBe('a $TM_SELECTED_TEXT b')
    res = await parser.resolveUltisnipsBody('${VISUAL}')
    expect(res).toBe('${TM_SELECTED_TEXT}')
    res = await parser.resolveUltisnipsBody('${VISUAL:abc}')
    expect(res).toBe('${TM_SELECTED_TEXT:abc}')
  })

  it('should decode escaped characters', async () => {
    let parser = new UltiSnipsParser('pyx')
    let res = await parser.resolveUltisnipsBody('\\`\\{}\\`')
    expect(res).toBe('`{}`')
  })

  it('should load snippets of vim-snippets', async () => {
    let parser = new UltiSnipsParser('pyx')
    let dir = path.join(__dirname, 'snippets')
    let files = fs.readdirSync(dir, 'utf8')
    for (let file of files) {
      let filepath = path.join(dir, file)
      await parser.parseUltisnipsFile(filepath)
    }
  })

  it('context parser works', async () => {
    let parser = new UltiSnipsParser('pyx')
    let file = path.join(__dirname, './files/context.snippets')
    let res = await parser.parseUltisnipsFile(file)
    expect(typeof res.snippets[0].context).toBe('string')
    expect(typeof res.snippets[1].context).toBe('string')
  })
})
