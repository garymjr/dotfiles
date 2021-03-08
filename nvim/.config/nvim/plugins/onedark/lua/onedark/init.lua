--
-- Built with,
--
--        ,gggg,
--       d8" "8I                         ,dPYb,
--       88  ,dP                         IP'`Yb
--    8888888P"                          I8  8I
--       88                              I8  8'
--       88        gg      gg    ,g,     I8 dPgg,
--  ,aa,_88        I8      8I   ,8'8,    I8dP" "8I
-- dP" "88P        I8,    ,8I  ,8'  Yb   I8P    I8
-- Yb,_,d88b,,_   ,d8b,  ,d8b,,8'_   8) ,d8     I8,
--  "Y8P"  "Y888888P'"Y88P"`Y8P' "YY8P8P88P     `Y8
--

-- Enable lush.ify on this file, run:
--
--  `:Lushify`
--
--  or
--
--  `:lua require('lush').ify()`

local lush = require('lush')
local hsl = lush.hsl

local colors = {
  red = hsl('#e06c75'),
  dark_red = hsl('#be5046'),
  green = hsl('#98c379'),
  yellow = hsl('#e5c07b'),
  dark_yellow = hsl('#d19a66'),
  blue = hsl('#61afef'),
  purple = hsl('#c678dd'),
  cyan = hsl('#56b6c2'),
  white = hsl('#abb2bf'),
  black = hsl('#282c34'),
  visual_black = 'NONE',
  comment_grey = hsl('#5c6370'),
  gutter_fg_grey = hsl('#4b5263'),
  cursor_grey = hsl('#2c323c'),
  visual_grey = hsl('#3e4452'),
  menu_grey = hsl('#3e4452'),
  special_grey = hsl('#3b4048'),
  vertsplit = hsl('#181a1f')
}

local theme = lush(function()
  return {
    -- The following are all the Neovim default highlight groups from
    -- docs as of 0.5.0-812, to aid your theme creation. Your themes should
    -- probably style all of these at a bare minimum.
    --
    -- Referenced/linked groups must come before being referenced/lined,
    -- so the order shown ((mostly) alphabetical) is likely
    -- not the order you will end up with.
    --
    -- You can uncomment these and leave them empty to disable any
    -- styling for that group (meaning they mostly get styled as Normal)
    -- or leave them commented to apply vims default colouring or linking.

    ColorColumn  { bg = colors.cursor_grey }, -- used for the columns set with 'colorcolumn'
    Comment      { fg = colors.comment_grey, gui = 'italic' }, -- use for comments
    -- Conceal      { }, -- placeholder characters substituted for concealed text (see 'conceallevel')
    Cursor       { bg = colors.blue, fg = colors.black }, -- character under the cursor
    -- lCursor      { }, -- the character under the cursor when |language-mapping| is used (see 'guicursor')
    -- CursorIM     { }, -- like Cursor, but used when in IME mode |CursorIM|
    CursorColumn { bg = colors.cursor_grey }, -- Screen-column at the cursor, when 'cursorcolumn' is set.
    CursorLine   { bg = colors.cursor_grey }, -- Screen-line at the cursor, when 'cursorline' is set.  Low-priority if foreground (ctermfg OR guifg) is not set.
    Directory    { fg = colors.blue }, -- directory names (and other special names in listings)
    DiffAdd      { bg = colors.green, fg = colors.black }, -- diff mode: Added line |diff.txt|
    DiffChange   { fg = colors.yellow, gui = 'underline' }, -- diff mode: Changed line |diff.txt|
    DiffDelete   { bg = colors.red, fg = colors.black }, -- diff mode: Deleted line |diff.txt|
    DiffText     { bg = colors.yellow, fg = colors.black }, -- diff mode: Changed text within a changed line |diff.txt|
    -- EndOfBuffer  {}, -- filler lines (~) after the end of the buffer.  By default, this is highlighted like |hl-NonText|.
    -- TermCursor   { }, -- cursor in a focused terminal
    -- TermCursorNC { }, -- cursor in an unfocused terminal
    ErrorMsg     { fg = colors.red }, -- error messages on the command line
    VertSplit    { fg = colors.vertsplit }, -- the column separating vertically split windows
    Folded       { fg = colors.comment_grey }, -- line used for closed folds
    -- FoldColumn   { }, -- 'foldcolumn'
    -- SignColumn   { }, -- column where |signs| are displayed
    IncSearch    { bg = colors.comment_grey, fg = colors.yellow }, -- 'incsearch' highlighting; also used for the text replaced with ":s///c"
    -- Substitute   { }, -- |:substitute| replacement text highlighting
    LineNr       { fg = colors.gutter_fg_grey }, -- Line number for ":number" and ":#" commands, and when 'number' or 'relativenumber' option is set.
    -- CursorLineNr { }, -- Like LineNr when 'cursorline' or 'relativenumber' is set for the cursor line.
    MatchParen   { fg = colors.blue, gui = 'underline' }, -- The character under the cursor or just before it, if it is a paired bracket, and its match. |pi_paren.txt|
    -- ModeMsg      { }, -- 'showmode' message (e.g., "-- INSERT -- ")
    -- MsgArea      { }, -- Area for messages and cmdline
    -- MsgSeparator { }, -- Separator for scrolled messages, `msgsep` flag of 'display'
    -- MoreMsg      { }, -- |more-prompt|
    NonText      { fg = colors.special_grey }, -- '@' at the end of the window, characters from 'showbreak' and other characters that do not really exist in the text (e.g., ">" displayed when a double-wide character doesn't fit at the end of the line). See also |hl-EndOfBuffer|.
    Normal       { bg = colors.black, fg = colors.white }, -- normal text
    -- NormalFloat  { }, -- Normal text in floating windows.
    -- NormalNC     { }, -- normal text in non-current windows
    Pmenu        { bg = colors.menu_grey }, -- Popup menu: normal item.
    PmenuSel     { bg = colors.blue, fg = colors.black }, -- Popup menu: selected item.
    PmenuSbar    { bg = colors.special_grey }, -- Popup menu: scrollbar.
    PmenuThumb   { bg = colors.white }, -- Popup menu: Thumb of the scrollbar.
    Question     { fg = colors.purple }, -- |hit-enter| prompt and yes/no questions
    QuickFixLine { bg = colors.yellow, fg = colors.black }, -- Current |quickfix| item in the quickfix window. Combined with |hl-CursorLine| when the cursor is there.
    Search       { bg = colors.yellow, fg = colors.black }, -- Last search pattern highlighting (see 'hlsearch').  Also used for similar items that need to stand out.
    SpecialKey   { bg = colors.special_grey }, -- Unprintable characters: text displayed differently from what it really is.  But not 'listchars' whitespace. |hl-Whitespace| SpellBad  Word that is not recognized by the spellchecker. |spell| Combined with the highlighting used otherwise.  SpellCap  Word that should start with a capital. |spell| Combined with the highlighting used otherwise.  SpellLocal  Word that is recognized by the spellchecker as one that is used in another region. |spell| Combined with the highlighting used otherwise.
    SpellRare    { fg = colors.dark_yellow }, -- Word that is recognized by the spellchecker as one that is hardly ever used.  |spell| Combined with the highlighting used otherwise.
    -- StatusLine   { }, -- status line of current window
    -- StatusLineNC { }, -- status lines of not-current windows Note: if this is equal to "StatusLine" Vim will use "^^^" in the status line of the current window.
    -- TabLine      { }, -- tab pages line, not active tab page label
    -- TabLineFill  { }, -- tab pages line, where there are no labels
    -- TabLineSel   { }, -- tab pages line, active tab page label
    Title        { fg = colors.green }, -- titles for output from ":set all", ":autocmd" etc.
    Visual       { bg = colors.visual_grey, fg = colors.visual_black }, -- Visual mode selection
    VisualNOS    { bg = colors.visual_grey }, -- Visual mode selection when vim is "Not Owning the Selection".
    WarningMsg   { fg = colors.yellow }, -- warning messages
    -- Whitespace   { }, -- "nbsp", "space", "tab" and "trail" in 'listchars'
    WildMenu     { bg = colors.blue, fg = colors.black }, -- current match in 'wildmenu' completion

    -- These groups are not listed as default vim groups,
    -- but they are defacto standard group names for syntax highlighting.
    -- commented out groups should chain up to their "preferred" group by
    -- default,
    -- Uncomment and edit if you want more specific syntax highlighting.

    Constant       { fg = colors.cyan }, -- (preferred) any constant
    String         { fg = colors.green }, --   a string constant: "this is a string"
    Character      { fg = colors.green }, --  a character constant: 'c', '\n'
    Number         { fg = colors.dark_yellow }, --   a number constant: 234, 0xff
    Boolean        { fg = colors.dark_yellow }, --  a boolean constant: TRUE, false
    Float          { fg = colors.dark_yellow }, --    a floating point constant: 2.3e10

    Identifier     { fg = colors.red }, -- (preferred) any variable name
    Function       { fg = colors.blue }, -- function name (also: methods for classes)

    Statement      { fg = colors.purple }, -- (preferred) any statement
    Conditional    { fg = colors.purple }, --  if, then, else, endif, switch, etc.
    Repeat         { fg = colors.purple }, --   for, do, while, etc.
    Label          { fg = colors.purple }, --    case, default, etc.
    Operator       { fg = colors.purple }, -- "sizeof", "+", "*", etc.
    Keyword        { fg = colors.red }, --  any other keyword
    Exception      { fg = colors.purple }, --  try, catch, throw

    PreProc        { fg = colors.yellow }, -- (preferred) generic Preprocessor
    Include        { fg = colors.blue }, --  preprocessor #include
    Define         { fg = colors.purple }, --   preprocessor #define
    Macro          { fg = colors.purple }, --    same as Define
    PreCondit      { fg = colors.yellow }, --  preprocessor #if, #else, #endif, etc.

    Type           { fg = colors.yellow }, -- (preferred) int, long, char, etc.
    StorageClass   { fg = colors.yellow }, -- static, register, volatile, etc.
    Structure      { fg = colors.yellow }, --  struct, union, enum, etc.
    Typedef        { fg = colors.yellow }, --  A typedef

    Special        { fg = colors.blue }, -- (preferred) any special symbol
    SpecialChar    { fg = colors.dark_yellow }, --  special character in a constant
    -- Tag            { }, --    you can use CTRL-] on this
    -- Delimiter      { }, --  character that needs attention
    SpecialComment { fg = colors.comment_grey }, -- special things inside a comment
    -- Debug          { }, --    debugging statements

    -- Underlined { gui = "underline" }, -- (preferred) text that stands out, HTML links
    -- Bold       { gui = "bold" },
    -- Italic     { gui = "italic" },

    -- ("Ignore", below, may be invisible...)
    -- Ignore         { }, -- (preferred) left blank, hidden  |hl-Ignore|

    Error          { fg = colors.red }, -- (preferred) any erroneous construct

    Todo           { fg = colors.purple }, -- (preferred) anything that needs extra attention; mostly the keywords TODO FIXME and XXX

    -- These groups are for the native LSP client. Some other LSP clients may use
    -- these groups, or use their own. Consult your LSP client's documentation.

    LspDiagnosticsDefaultError        { fg = colors.red },
    LspDiagnosticsErrorSign           { fg = colors.red },
    LspDiagnosticsUnderlineError      { LspDiagnosticsDefaultError, gui = 'underline' },
    LspDiagnosticsDefaultWarning      { fg = colors.yellow },
    LspDiagnosticsWarningSign         { fg = colors.yellow },
    LspDiagnosticsUnderlineWarning    { LspDiagnosticsDefaultWarning, gui = 'underline' },
    LspDiagnosticsDefaultInformation         { fg = colors.white },
    LspDiagnosticsInformationSign     { fg = colors.white },
    LspDiagnosticsUnderlineInformation { LspDiagnosticsDefaultInformation, gui = 'underline' },
    LspDiagnosticsDefaultHint                { fg = colors.comment_grey },
    LspDiagnosticsHintSign            { fg = colors.comment_grey },
    LspDiagnosticsUnderlineHint       { LspDiagnosticsDefaultHint, gui = 'underline' },

    -- These groups are for the neovim tree-sitter highlights.
    -- As of writing, tree-sitter support is a WIP, group names may change.
    -- By default, most of these groups link to an appropriate Vim group,
    -- TSError -> Error for example, so you do not have to define these unless
    -- you explicitly want to support Treesitter's improved syntax awareness.

    -- TSError              { }, -- For syntax/parser errors.
    -- TSPunctDelimiter     { }, -- For delimiters ie: `.`
    -- TSPunctBracket       { }, -- For brackets and parens.
    -- TSPunctSpecial       { }, -- For special punctutation that does not fall in the catagories before.
    -- TSConstant           { }, -- For constants
    -- TSConstBuiltin       { }, -- For constant that are built in the language: `nil` in Lua.
    -- TSConstMacro         { }, -- For constants that are defined by macros: `NULL` in C.
    -- TSString             { }, -- For strings.
    -- TSStringRegex        { }, -- For regexes.
    -- TSStringEscape       { }, -- For escape characters within a string.
    -- TSCharacter          { }, -- For characters.
    -- TSNumber             { }, -- For integers.
    -- TSBoolean            { }, -- For booleans.
    -- TSFloat              { }, -- For floats.
    -- TSFunction           { }, -- For function (calls and definitions).
    -- TSFuncBuiltin        { }, -- For builtin functions: `table.insert` in Lua.
    -- TSFuncMacro          { }, -- For macro defined fuctions (calls and definitions): each `macro_rules` in Rust.
    -- TSParameter          { }, -- For parameters of a function.
    -- TSParameterReference { }, -- For references to parameters of a function.
    -- TSMethod             { }, -- For method calls and definitions.
    -- TSField              { }, -- For fields.
    -- TSProperty           { }, -- Same as `TSField`.
    -- TSConstructor        { }, -- For constructor calls and definitions: `{ }` in Lua, and Java constructors.
    -- TSConditional        { }, -- For keywords related to conditionnals.
    -- TSRepeat             { }, -- For keywords related to loops.
    -- TSLabel              { }, -- For labels: `label:` in C and `:label:` in Lua.
    -- TSOperator           { }, -- For any operator: `+`, but also `->` and `*` in C.
    -- TSKeyword            { }, -- For keywords that don't fall in previous categories.
    -- TSKeywordFunction    { }, -- For keywords used to define a fuction.
    -- TSException          { }, -- For exception related keywords.
    -- TSType               { }, -- For types.
    -- TSTypeBuiltin        { }, -- For builtin types (you guessed it, right ?).
    -- TSNamespace          { }, -- For identifiers referring to modules and namespaces.
    -- TSInclude            { }, -- For includes: `#include` in C, `use` or `extern crate` in Rust, or `require` in Lua.
    -- TSAnnotation         { }, -- For C++/Dart attributes, annotations that can be attached to the code to denote some kind of meta information.
    -- TSText               { }, -- For strings considered text in a markup language.
    -- TSStrong             { }, -- For text to be represented with strong.
    -- TSEmphasis           { }, -- For text to be represented with emphasis.
    -- TSUnderline          { }, -- For text to be represented with an underline.
    -- TSTitle              { }, -- Text that is part of a title.
    -- TSLiteral            { }, -- Literal text.
    -- TSURI                { }, -- Any URI like a link or email.
    -- TSVariable           { }, -- Any variable name that does not have another highlight.
    -- TSVariableBuiltin    { }, -- Variable names that are defined by the languages, like `this` or `self`.
  }
end)

-- return our parsed theme for extension or use else where.
return theme

-- vi:nowrap
