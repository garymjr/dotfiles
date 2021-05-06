local colors = require('parsec.colors')

local theme = {}
theme.loadUI = function()
  local syntax = {
    Normal = { fg = colors.base0, bg = colors.base03 },
    SpecialKey = { fg = colors.base00, bg = colors.base02, style = 'bold' },
    NonText = { fg = colors.base00, style = 'bold' },
    StatusLine = { fg = colors.base02, bg = colors.base00, style = 'reverse' },
    StatusLineNC = { fg = colors.base02, bg = colors.base01, style = 'reverse' },
    Visual = { fg = colors.base01, bg = colors.base03, style = 'reverse' },
    VisualNOS = { fg = colors.base01, bg = colors.base02, style = 'reverse' },
    Directory = { fg = colors.blue, style = 'standout' },
    ErrorMsg = { fg = colors.red, style = 'reverse' },
    IncSearch = { fg = colors.orange, style = 'standout' },
    Search = { fg = colors.yellow, style = 'reverse' },
    MoreMsg = { bg = colors.blue },
    ModeMsg = { link = 'MoreMsg' },
    LineNr = { fg = colors.base01, bg = colors.base02 },
    Question = { fg = colors.cyan, style = 'bold' },
    VertSplit = { fg = colors.base02, bg = colors.base02 },
    Title = { fg = colors.orange, style = 'bold' },
    WarningMsg = { fg = colors.red, style = 'bold' },
    WildMenu = { fg = colors.base2, bg = colors.base02, style = 'reverse' },
    Folded = { fg = colors.base0, bg = colors.base02 },
    FoldColumn = { link = 'Folded' },
    SignColumn = { bg = colors.base02 },
    Conceal = { fg = colors.blue },
    Pmenu = { fg = colors.base0, bg = colors.base02, style = 'reverse' },
    PmenuSel = { fg = colors.base01, bg = colors.base2, style = 'reverse' },
    PmenuSbar = { fg = colors.base2, bg = colors.base0, style = 'reverse' },
    PmenuThumb = { fg = colors.base0, bg = colors.base03, style = 'reverse' },
    TabLine = { fg = colors.base0, bg = colors.base02 },
    TabLineFill = { link = 'TabLine' },
    TabLineSel = { fg = colors.base01, bg = colors.base2, style = 'reverse' },
    CursorColumn = { bg = colors.base02 },
    CursorLine = { link = 'CursorColumn' },
    Cursor = { fg = colors.base03, bg = colors.base0 },
    lCursor = { link = 'Cursor' },
    MatchParen = { fg = colors.red, bg = colors.base01, style = 'bold' },
    DiffAdd = { fg = colors.green, bg = colors.base02, style = 'reverse' },
    DiffChange = { fg = colors.yellow, bg = colors.base02, style = 'reverse' },
    DiffDelete = { fg = colors.red, bg = colors.base02, style = 'reverse' },
    DiffText = { fg = colors.blue, bg = colors.base02, style = 'reverse' },
  }
  return syntax
end

theme.loadSyntax = function()
  local syntax = {
    Comment = { fg = colors.base01 },

    Constant = { fg = colors.cyan },
    String = { link = 'Constant' },
    Character = { link = 'Constant' },
    Number = { link = 'Constant' },
    Boolean = { link = 'Constant' },
    Float = { link = 'Constant' },

    Identifier = { fg = colors.blue },
    Function = { link = 'Identifier' },

    Statement = { fg = colors.green },
    Conditional = { link = 'Statement' },
    Repeat = { link = 'Statement' },
    Label = { link = 'Statement' },
    Operator = { link = 'Statement' },
    Keyword = { link = 'Statement' },
    Exception = { link = 'Statement' },

    PreProc = { fg = colors.orange },
    Include = { link = 'PreProc' },
    Define = { link = 'PreProc' },
    Macro = { link = 'PreProc' },
    PreCondit = { link = 'PreProc' },

    Type = { fg = colors.yellow },
    StorageClass = { link = 'Type' },
    Structure = { link = 'Type' },
    TypeDef = { link = 'Type' },

    Special = { fg = colors.red },
    SpecialChar = { link = 'Special' },
    Tag = { link = 'Special' },
    Delimiter = { link = 'Special' },
    SpecialComment = { link = 'Special' },
    Debug = { link = 'Special' },

    Underlined = { fg = colors.violet },

    Ignore = {},

    Error = { fg = colors.red, style = 'bold' },

    Todo = { fg = colors.magenta, style = 'bold' }
  }
  return syntax
end

theme.loadPlugins = function()
  local plugins = {
    GitSignsAdd = { fg = colors.green },
    GitSignsChange = { fg = colors.yellow },
    GitSignsDelete = { fg = colors.red },
  }
  return plugins
end

theme.loadLSP = function()
  local lsp = {
    LspDiagnosticsDefaultError = { fg = colors.red },
    LspDiagnosticsDefaultWarning = { fg = colors.yellow },
    LspDiagnosticsDefaultInformation = { fg = colors.cyan },
    LspDiagnosticsDefaultHint = { fg = colors.green },

    LspDiagnosticsVirtualTextError = { link = 'LspDiagnosticsDefaultError' },
    LspDiagnosticsVirtualTextWarning = { link = 'LspDiagnosticsDefaultWarning' },
    LspDiagnosticsVirtualTextInformation = { link = 'LspDiagnosticsDefaultInformation' },
    LspDiagnosticsVirtualTextHint = { link = 'LspDiagnosticsDefaultHint' }
  }
  return lsp
end

theme.loadTreesitter = function()
  local treesitter = {
    TSBoolean = { link = 'Boolean' },
    TSCharacter = { link = 'Character' },
    TSComment = { link = 'Comment' },
    TSConditional = { link = 'Conditional' },
    TSConstant = { link = 'Constant' },
    TSConstBuiltin = { link = 'Boolean' },
    TSConstMacro = { link = 'Boolean' },
    TSError = { link = 'Error' },
    TSException = { link = 'Exception' },
    TSFloat = { link = 'Float' },
    TSFunction = { link = 'Function' },
    TSFuncBuiltin = { link = 'Function' },
    TSFuncMacro = { link = 'Function' },
    TSInclude = { link = 'Include' },
    TSKeyword = { link = 'Keyword' },
    TSKeywordFunction = { link = 'Function' },
    TSKeywordOperator = { link = 'Keyword' },
    TSLabel = { link = 'Label' },
    TSMethod = { link = 'Function' },
    TSNumber = { link = 'Number' }
  }
  return treesitter
end

return theme
