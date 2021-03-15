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

local black = hsl('#282c34')
local red = hsl('#e06c75')
local green = hsl('#98c379')
local yellow = hsl('#e5c07b')
local blue = hsl('#61afef')
local purple = hsl('#c678dd')
local cyan = hsl('#56b6c2')
local white = hsl('#dcdfe4')

local fg = white
local bg = black

local comment = hsl('#5c6370')
local gutter = { fg = hsl('#919baa'), bg = hsl('#282c34') }

local non_text = hsl('#373c45')
local cursor_gray = hsl('#313640')

local selection = hsl('#474e5d')
local vertsplit = hsl('#313640')

local theme = lush(function()
  return {
    -- The following are all the Neovim default highlight groups from
    -- docs as of 0.5.0-1130, to aid your theme creation. Your themes should
    -- probably style all of these at a bare minimum.
    --
    -- Referenced/linked groups must come before being referenced/lined,
    -- so the order shown ((mostly) alphabetical) is likely
    -- not the order you will end up with.
    --
    -- You can uncomment these and leave them empty to disable any
    -- styling for that group (meaning they mostly get styled as Normal)
    -- or leave them commented to apply vims default colouring or linking.

    ColorColumn  { bg = cursor_gray }, -- used for the columns set with 'colorcolumn'
    Conceal      { fg = fg }, -- placeholder characters substituted for concealed text (see 'conceallevel')
    Cursor       { fg = bg, bg = blue }, -- character under the cursor
    -- lCursor      { }, -- the character under the cursor when |language-mapping| is used (see 'guicursor')
    -- CursorIM     { }, -- like Cursor, but used when in IME mode |CursorIM|
    CursorColumn { bg = cursor_gray }, -- Screen-column at the cursor, when 'cursorcolumn' is set.
    CursorLine   { bg = cursor_gray }, -- Screen-line at the cursor, when 'cursorline' is set.  Low-priority if foreground (ctermfg OR guifg) is not set.
    Directory    { fg = blue }, -- directory names (and other special names in listings)
    DiffAdd      { fg = green }, -- diff mode: Added line |diff.txt|
    DiffChange   { fg = yellow }, -- diff mode: Changed line |diff.txt|
    DiffDelete   { fg = red }, -- diff mode: Deleted line |diff.txt|
    DiffText     { fg = blue }, -- diff mode: Changed text within a changed line |diff.txt|
    EndOfBuffer  { fg = bg }, -- filler lines (~) after the end of the buffer.  By default, this is highlighted like |hl-NonText|.
    -- TermCursor   { }, -- cursor in a focused terminal
    -- TermCursorNC { }, -- cursor in an unfocused terminal
    ErrorMsg     { fg = fg }, -- error messages on the command line
    VertSplit    { fg = vertsplit, bg = vertsplit }, -- the column separating vertically split windows
    Folded       { fg = fg }, -- line used for closed folds
    FoldColumn   { fg = fg }, -- 'foldcolumn'
    SignColumn   { fg = fg }, -- column where |signs| are displayed
    IncSearch    { fg = bg, bg = yellow }, -- 'incsearch' highlighting; also used for the text replaced with ":s///c"
    -- Substitute   { }, -- |:substitute| replacement text highlighting
    LineNr       { fg = gutter.fg, bg = gutter.bg }, -- Line number for ":number" and ":#" commands, and when 'number' or 'relativenumber' option is set.
    CursorLineNr { fg = fg }, -- Like LineNr when 'cursorline' or 'relativenumber' is set for the cursor line.
    MatchParen   { fg = blue, gui = 'underline' }, -- The character under the cursor or just before it, if it is a paired bracket, and its match. |pi_paren.txt|
    ModeMsg      { fg = fg }, -- 'showmode' message (e.g., "-- INSERT -- ")
    -- MsgArea      { }, -- Area for messages and cmdline
    -- MsgSeparator { }, -- Separator for scrolled messages, `msgsep` flag of 'display'
    MoreMsg      { fg = fg }, -- |more-prompt|
    NonText      { fg = non_text }, -- '@' at the end of the window, characters from 'showbreak' and other characters that do not really exist in the text (e.g., ">" displayed when a double-wide character doesn't fit at the end of the line). See also |hl-EndOfBuffer|.
    Normal       { fg = fg, bg = bg }, -- normal text
    -- NormalFloat  { }, -- Normal text in floating windows.
    -- NormalNC     { }, -- normal text in non-current windows
    Pmenu        { fg = bg, bg = fg }, -- Popup menu: normal item.
    PmenuSel     { fg = fg, bg = blue }, -- Popup menu: selected item.
    PmenuSbar    { bg = selection }, -- Popup menu: scrollbar.
    PmenuThumb   { bg = fg }, -- Popup menu: Thumb of the scrollbar.
    Question     { fg = purple }, -- |hit-enter| prompt and yes/no questions
    -- QuickFixLine { }, -- Current |quickfix| item in the quickfix window. Combined with |hl-CursorLine| when the cursor is there.
    Search       { fg = bg, bg = yellow }, -- Last search pattern highlighting (see 'hlsearch').  Also used for similar items that need to stand out.
    SpecialKey   { fg = fg }, -- Unprintable characters: text displayed differently from what it really is.  But not 'listchars' whitespace. |hl-Whitespace|
    -- SpellBad     { }, -- Word that is not recognized by the spellchecker. |spell| Combined with the highlighting used otherwise.
    -- SpellCap     { }, -- Word that should start with a capital. |spell| Combined with the highlighting used otherwise.
    -- SpellLocal   { }, -- Word that is recognized by the spellchecker as one that is used in another region. |spell| Combined with the highlighting used otherwise.
    -- SpellRare    { }, -- Word that is recognized by the spellchecker as one that is hardly ever used.  |spell| Combined with the highlighting used otherwise.
    StatusLine   { fg = blue, bg = cursor_gray }, -- status line of current window
    StatusLineNC { fg = comment, bg = cursor_gray }, -- status lines of not-current windows Note: if this is equal to "StatusLine" Vim will use "^^^" in the status line of the current window.
    TabLine      { fg = comment, bg = cursor_gray }, -- tab pages line, not active tab page label
    TabLineFill  { fg = comment, bg = cursor_gray }, -- tab pages line, where there are no labels
    TabLineSel   { fg = fg, bg = bg }, -- tab pages line, active tab page label
    Title        { fg = green }, -- titles for output from ":set all", ":autocmd" etc.
    Visual       { bg = selection }, -- Visual mode selection
    VisualNOS    { bg = selection }, -- Visual mode selection when vim is "Not Owning the Selection".
    WarningMsg   { fg = red }, -- warning messages
    Whitespace   { fg = non_text }, -- "nbsp", "space", "tab" and "trail" in 'listchars'
    WildMenu     { fg = fg }, -- current match in 'wildmenu' completion

    -- These groups are not listed as default vim groups,
    -- but they are defacto standard group names for syntax highlighting.
    -- commented out groups should chain up to their "preferred" group by
    -- default,
    -- Uncomment and edit if you want more specific syntax highlighting.

    Comment           { fg = comment, gui = 'italic' },

    Constant       { fg = cyan }, -- (preferred) any constant
    String         { fg = green }, --   a string constant: "this is a string"
    Character      { fg = green }, --  a character constant: 'c', '\n'
    Number         { fg = yellow }, --   a number constant: 234, 0xff
    Boolean        { fg = yellow }, --  a boolean constant: TRUE, false
    Float          { fg = yellow }, --    a floating point constant: 2.3e10

    Identifier     { fg = red }, -- (preferred) any variable name
    Function       { fg = blue }, -- function name (also: methods for classes)

    Statement      { fg = purple }, -- (preferred) any statement
    Conditional    { fg = purple }, --  if, then, else, endif, switch, etc.
    Repeat         { fg = purple }, --   for, do, while, etc.
    Label          { fg = purple }, --    case, default, etc.
    Operator       { fg = fg }, -- "sizeof", "+", "*", etc.
    Keyword        { fg = red }, --  any other keyword
    Exception      { fg = purple }, --  try, catch, throw

    PreProc        { fg = yellow }, -- (preferred) generic Preprocessor
    Include        { fg = purple }, --  preprocessor #include
    Define         { fg = purple }, --   preprocessor #define
    Macro          { fg = purple }, --    same as Define
    PreCondit      { fg = yellow }, --  preprocessor #if, #else, #endif, etc.

    Type           { fg = yellow }, -- (preferred) int, long, char, etc.
    StorageClass   { fg = yellow }, -- static, register, volatile, etc.
    Structure      { fg = yellow }, --  struct, union, enum, etc.
    Typedef        { fg = yellow }, --  A typedef

    Special        { fg = blue }, -- (preferred) any special symbol
    SpecialChar    { fg = fg }, --  special character in a constant
    Tag            { fg = fg }, --    you can use CTRL-] on this
    Delimiter      { fg = fg }, --  character that needs attention
    SpecialComment { fg = fg }, -- special things inside a comment
    Debug          { fg = fg }, --    debugging statements

    Underlined { gui = "underline" }, -- (preferred) text that stands out, HTML links
    -- Bold       { fg = fg },
    Italic     { gui = "italic" },

    -- ("Ignore", below, may be invisible...)
    Ignore         { fg = fg }, -- (preferred) left blank, hidden  |hl-Ignore|

    Error          { fg = red, bg = gutter.bg }, -- (preferred) any erroneous construct

    Todo           { fg = purple }, -- (preferred) anything that needs extra attention; mostly the keywords TODO FIXME and XXX

    -- These groups are for the native LSP client. Some other LSP clients may
    -- use these groups, or use their own. Consult your LSP client's
    -- documentation.

    -- LspReferenceText                     { }, -- used for highlighting "text" references
    -- LspReferenceRead                     { }, -- used for highlighting "read" references
    -- LspReferenceWrite                    { }, -- used for highlighting "write" references

    LspDiagnosticsDefaultError           { fg = red }, -- Used as the base highlight group. Other LspDiagnostic highlights link to this by default (except Underline)
    LspDiagnosticsDefaultWarning         { fg = yellow }, -- Used as the base highlight group. Other LspDiagnostic highlights link to this by default (except Underline)
    LspDiagnosticsDefaultInformation     { fg = fg }, -- Used as the base highlight group. Other LspDiagnostic highlights link to this by default (except Underline)
    LspDiagnosticsDefaultHint            { fg = gutter.fg }, -- Used as the base highlight group. Other LspDiagnostic highlights link to this by default (except Underline)

    -- LspDiagnosticsVirtualTextError       { }, -- Used for "Error" diagnostic virtual text
    -- LspDiagnosticsVirtualTextWarning     { }, -- Used for "Warning" diagnostic virtual text
    -- LspDiagnosticsVirtualTextInformation { }, -- Used for "Information" diagnostic virtual text
    -- LspDiagnosticsVirtualTextHint        { }, -- Used for "Hint" diagnostic virtual text

    -- LspDiagnosticsUnderlineError         { }, -- Used to underline "Error" diagnostics
    -- LspDiagnosticsUnderlineWarning       { }, -- Used to underline "Warning" diagnostics
    -- LspDiagnosticsUnderlineInformation   { }, -- Used to underline "Information" diagnostics
    -- LspDiagnosticsUnderlineHint          { }, -- Used to underline "Hint" diagnostics

    -- LspDiagnosticsFloatingError          { }, -- Used to color "Error" diagnostic messages in diagnostics float
    -- LspDiagnosticsFloatingWarning        { }, -- Used to color "Warning" diagnostic messages in diagnostics float
    -- LspDiagnosticsFloatingInformation    { }, -- Used to color "Information" diagnostic messages in diagnostics float
    -- LspDiagnosticsFloatingHint           { }, -- Used to color "Hint" diagnostic messages in diagnostics float

    -- LspDiagnosticsSignError              { }, -- Used for "Error" signs in sign column
    -- LspDiagnosticsSignWarning            { }, -- Used for "Warning" signs in sign column
    -- LspDiagnosticsSignInformation        { }, -- Used for "Information" signs in sign column
    -- LspDiagnosticsSignHint               { }, -- Used for "Hint" signs in sign column


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
