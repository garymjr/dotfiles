local colors = require('cosmic_latte.colors')

local theme = {}

theme.loadSyntax = function()
  local syntax = {
    ColorColumn = { bg = colors.outer_space },
    Conceal = {},
    Cursor = { fg = colors.blue_haze, bg = colors.ebony_clay, gui = 'reverse' },
    lCursor = {},
    CursorIM = {},
    CursorColumn = { link = 'ColorColumn' },
    CursorLine = { link = 'CursorLine' },
    Directory = { gui = 'bold' },
    DiffAdd = { fg = colors.asparagus, colors.ebony_clay, gui = 'reverse' },
    DiffChange = { fg = colors.outer_space },
    DiffDelete = { fg = colors.old_rose, bg = colors.ebony_clay, gui = 'reverse' },
    DiffText = { fg = colors.teak, bg = colors.ebony_clay, gui = 'reverse' },
    EndOfBuffer = {},
    TermCursor = {},
    TermCursorNC = {},
    ErrorMsg = { fg = colors.old_rose, bg = colors.ebony_clay, gui = 'reverse' },
    Folded = { bg = colors.outer_space },
    FoldColumn = { fg = colors.foreground },
    SignColumn = { fg = colors.foreground },
    IncSearch = { fg = colors.steel_blue, bg = colors.ebony_clay, gui = 'reverse' },
    Substitute = {},
    LineNr = { colors.comment },
    CursorLineNr = { colors.comment },
    MatchParen = { fg = colors.blue_haze, bg = colors.black_coral_pearl },
    ModeMsg = {},
    MsgArea = {},
    MsgSeparator = {},
    MoreMsg = {},
    NonText = {},
    Normal = { fg = colors.foreground, bg = colors.background },
    NormalFloat = {},
    NormalNC = {},
    Pmenu = { fg = colors.foreground, bg = colors.outer_space },
    PmenuSel = { fg = colors.foreground, bg = colors.ebony_clay, gui = 'reverse' },
    PmenuSbar = { fg = colors.black_coral_pearl, bg = colors.black_coral_pearl },
    PmenuThumb = { fg = colors.foreground, bg = colors.foreground },
    Question = {},
    QuickFixLine = { bg = colors.outer_space },
    Search = { fg = colors.teak, bg = colors.ebony_clay, gui = 'reverse' },
    SpecialKey = { fg = colors.teak },
    StatusLine = { fg = colors.foreground, bg = colors.ebony_clay, gui = 'reverse' },
    StatusLineTerm = { link = 'StatusLine' },
    StatusLineNC = { fg = colors.foreground, bg = colors.outer_space },
    TabLine = { fg = colors.foreground, bg = colors.outer_space },
    TabLineFill = { fg = colors.outer_space, bg = colors.outer_space },
    TabLineSel = { fg = colors.foreground, bg = colors.ebony_clay, gui = 'reverse' },
    Title = { gui = 'bold' },
    VertSplit = { fg = colors.outer_space, bg = colors.outer_space },
    Visual = { fg = colors.blue_haze, bg = colors.black_coral_pearl },
    VisualNOS = { fg = colors.foreground, bg = colors.outer_space },
    WarningMsg = { fg = colors.purple, bg = colors.ebony_clay, gui = 'reverse' },
    Whitespace = {},
    WildMenu = { fg = colors.foreground, bg = colors.outer_space },

    Comment = { fg = colors.comment },
    Constant = { fg = colors.steel_blue },
    String = { fg = colors.steel_blue },
    Character = { fg = colors.steel_blue },
    Number = { fg = colors.steel_blue },
    Boolean = { fg = colors.steel_blue },
    Float = { fg = colors.steel_blue },
    Identifier = { fg = colors.old_rose },
    Function = { fg = colors.old_rose },
    Statement = { fg = colors.asparagus },
    Conditional = { fg = colors.asparagus},
    Repeat = { fg = colors.asparagus },
    Label = { fg = colors.asparagus },
    Operator = { fg = colors.asparagus },
    Keyword = { fg = colors.asparagus },
    Exception = { fg = colors.asparagus },
    PreProc = { fg = colors.jade },
    Include = { fg = colors.jade },
    Define = { fg = colors.jade },
    Macro = { fg = colors.jade },
    PreCondit = { fg = colors.jade },
    Type = { colors.purple },
    StorageClass = { fg = colors.purple },
    Structure = { fg = colors.purple },
    Typedef = { fg = colors.purple },
    Special = { fg = colors.teak },
    SpecialChar = { fg = colors.teak },
    Tag = { fg = colors.teak },
    Delimiter = { fg = colors.teak },
    SpecialComment = { fg = colors.teak },
    Debug = { fg = colors.teak },
    Bold = { gui = 'bold' },
    Italic = {},
    Underlined = { gui = 'underline' },
    Ignore = {},
    Error = { link = 'ErrorMsg' },
    Todo = { fg = colors.jade, bg = colors.ebony_clay, gui = 'reverse' }
  }
  return syntax
end

theme.loadPlugins = function()
  local plugins = {
    GitSignsAdd = { fg = colors.asparagus },
    GitSignsChange = { fg = colors.teak },
    GitSignsDelete = { fg = colors.old_rose },
    GitSignsCurrentLineBlame = { fg = colors.comment }
  }
  return plugins
end

theme.loadLsp = function()
  local lsp = {
    LspDiagnosticsDefaultError = { fg = colors.old_rose },
    LspDiagnosticsDefaultWarning = { fg = colors.teak },
    LspDiagnosticsDefaultInformation = { fg = colors.jade },
    LspDiagnosticsDefaultHint = { fg = colors.black_coral_pearl }
  }
  return lsp
end

return theme
