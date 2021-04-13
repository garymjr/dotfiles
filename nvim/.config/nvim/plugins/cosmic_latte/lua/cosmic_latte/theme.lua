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

local lush = require('lush')
local hsl = lush.hsl

local directory = hsl('#00FFFF')
local cadet_blue = hsl('#abb0c0')
local ebony_clay = hsl('#202a31')
local manatee = hsl('#898f9e')
local outer_space = hsl('#2b3740')
local blue_haze = hsl('#c5cbdb')
local black_coral_pearl = hsl('#4c5764')
local purple = hsl('#9b85bb')
local old_rose = hsl('#c17b8d')
local teak = hsl('#b28761')
local asparagus = hsl('#7d9761')
local jade = hsl('#459d90')
local steel_blue = hsl('#5496bd')

local theme = lush(function()
  return {
    -- The following are all the Neovim default highlight groups from the docs
    -- as of 0.5.0-nightly-446, to aid your theme creation. Your themes should
    -- probably style all of these at a bare minimum.
    --
    -- Referenced/linked groups must come before being referenced/lined,
    -- so the order shown ((mostly) alphabetical) is likely
    -- not the order you will end up with.
    --
    -- You can uncomment these and leave them empty to disable any
    -- styling for that group (meaning they mostly get styled as Normal)
    -- or leave them commented to apply vims default colouring or linking.

    Normal       { fg = cadet_blue, bg = ebony_clay }, -- normal text
    Directory    { fg = directory, gui = 'bold' }, -- directory names (and other special names in listings)
    Conceal      { Normal }, -- placeholder characters substituted for concealed text (see 'conceallevel')
    EndOfBuffer  { Normal }, -- filler lines (~) after the end of the buffer.  By default, this is highlighted like |hl-NonText|.
    FoldColumn   { fg = cadet_blue }, -- 'foldcolumn'
    ModeMsg      { Normal }, -- 'showmode' message (e.g., "-- INSERT -- ")
    MoreMsg      { Normal }, -- |more-prompt|
    NonText      { Normal }, -- '@' at the end of the window, characters from 'showbreak' and other characters that do not really exist in the text (e.g., ">" displayed when a double-wide character doesn't fit at the end of the line). See also |hl-EndOfBuffer|.
    Question     { Normal }, -- |hit-enter| prompt and yes/no questions
    SignColumn   { fg = cadet_blue }, -- column where |signs| are displayed
    Title        { gui = 'bold' }, -- titles for output from ":set all", ":autocmd" etc.
    Comment      { fg = manatee }, -- any comment
    CursorLineNr { fg = manatee }, -- Like LineNr when 'cursorline' or 'relativenumber' is set for the cursor line.
    LineNr       { fg = manatee }, -- Line number for ":number" and ":#" commands, and when 'number' or 'relativenumber' option is set.
    ColorColumn  { bg = outer_space }, -- used for the columns set with 'colorcolumn'
    CursorColumn { bg = outer_space }, -- Screen-column at the cursor, when 'cursorcolumn' is set.
    CursorLine   { bg = outer_space }, -- Screen-line at the cursor, when 'cursorline' is set.  Low-priority if foreground (ctermfg OR guifg) is not set.
    DiffChange   { bg = outer_space }, -- diff mode: Changed line |diff.txt|
    Folded       { bg = outer_space }, -- line used for closed folds
    Pmenu        { fg = cadet_blue, bg = outer_space }, -- Popup menu: normal item.
    QuickFixLine { bg = outer_space }, -- Current |quickfix| item in the quickfix window. Combined with |hl-CursorLine| when the cursor is there.
    StatusLineNC { fg = cadet_blue, bg = outer_space }, -- status lines of not-current windows Note: if this is equal to "StatusLine" Vim will use "^^^" in the status line of the current window.
    TabLine      { fg = cadet_blue, bg = outer_space }, -- tab pages line, not active tab page label
    VisualNOS    { fg = cadet_blue, bg = outer_space }, -- Visual mode selection when vim is "Not Owning the Selection".
    WildMenu     { fg = cadet_blue, bg = outer_space }, -- current match in 'wildmenu' completion
    PmenuSel     { fg = cadet_blue, bg = ebony_clay, gui = 'reverse' }, -- Popup menu: selected item.
    StatusLine   { fg = cadet_blue, bg = ebony_clay, gui = 'reverse' }, -- status line of current window
    TabLineSel   { fg = cadet_blue, bg = ebony_clay, gui = 'reverse' }, -- tab pages line, active tab page label
    Cursor       { fg = blue_haze, bg = ebony_clay, gui = 'reverse' }, -- character under the cursor
    MatchParen   { fg = blue_haze, bg = black_coral_pearl }, -- The character under the cursor or just before it, if it is a paired bracket, and its match. |pi_paren.txt|
    Visual       { fg = blue_haze, bg = black_coral_pearl }, -- Visual mode selection
    PmenuSbar    { fg = black_coral_pearl, bg = black_coral_pearl }, -- Popup menu: scrollbar.
    PmenuThumb   { fg = cadet_blue, bg = cadet_blue }, -- Popup menu: Thumb of the scrollbar.
    TabLineFill  { fg = outer_space, bg = outer_space }, -- tab pages line, where there are no labels
    VertSplit    { fg = outer_space }, -- the column separating vertically split windows
    WarningMsg   { fg = purple, bg = ebony_clay, gui = 'reverse' }, -- warning messages
    DiffDelete   { fg = old_rose, bg = ebony_clay, gui = 'reverse' }, -- diff mode: Deleted line |diff.txt|
    ErrorMsg     { fg = old_rose, bg = ebony_clay, gui = 'reverse' }, -- error messages on the command line
    DiffText     { fg = teak, bg = ebony_clay, gui = 'reverse' }, -- diff mode: Changed text within a changed line |diff.txt|
    Search       { fg = teak, bg = ebony_clay, gui = 'reverse' }, -- Last search pattern highlighting (see 'hlsearch').  Also used for similar items that need to stand out.
    DiffAdd      { fg = asparagus, bg = ebony_clay, gui = 'reverse' }, -- diff mode: Added line |diff.txt|
    IncSearch    { fg = steel_blue, bg = ebony_clay, gui = 'reverse' }, -- 'incsearch' highlighting; also used for the text replaced with ":s///c"
    -- lCursor      { }, -- the character under the cursor when |language-mapping| is used (see 'guicursor')
    -- CursorIM     { }, -- like Cursor, but used when in IME mode |CursorIM|
    -- TermCursor   { }, -- cursor in a focused terminal
    -- TermCursorNC { }, -- cursor in an unfocused terminal
    -- Substitute   { }, -- |:substitute| replacement text highlighting
    -- MsgArea      { }, -- Area for messages and cmdline
    -- MsgSeparator { }, -- Separator for scrolled messages, `msgsep` flag of 'display'
    -- NormalFloat  { }, -- Normal text in floating windows.
    -- NormalNC     { }, -- normal text in non-current windows
    -- SpecialKey   { }, -- Unprintable characters: text displayed differently from what it really is.  But not 'listchars' whitespace. |hl-Whitespace|
    -- SpellBad     { }, -- Word that is not recognized by the spellchecker. |spell| Combined with the highlighting used otherwise. 
    -- SpellCap     { }, -- Word that should start with a capital. |spell| Combined with the highlighting used otherwise.
    -- SpellLocal   { }, -- Word that is recognized by the spellchecker as one that is used in another region. |spell| Combined with the highlighting used otherwise.
    -- SpellRare    { }, -- Word that is recognized by the spellchecker as one that is hardly ever used.  |spell| Combined with the highlighting used otherwise.
    -- Whitespace   { }, -- "nbsp", "space", "tab" and "trail" in 'listchars'

    -- These groups are not listed as default vim groups,
    -- but they are defacto standard group names for syntax highlighting.
    -- commented out groups should chain up to their "preferred" group by
    -- default,
    -- Uncomment and edit if you want more specific syntax highlighting.

    Constant       { fg = steel_blue }, -- (preferred) any constant
    String         { fg = steel_blue }, --   a string constant: "this is a string"
    Character      { fg = steel_blue }, --  a character constant: 'c', '\n'
    Number         { fg = steel_blue }, --   a number constant: 234, 0xff
    Boolean        { fg = steel_blue }, --  a boolean constant: TRUE, false
    Float          { fg = steel_blue }, --    a floating point constant: 2.3e10

    Identifier     { fg = old_rose }, -- (preferred) any variable name
    Function       { fg = old_rose }, -- function name (also: methods for classes)

    Statement      { fg = asparagus }, -- (preferred) any statement
    Conditional    { fg = asparagus }, --  if, then, else, endif, switch, etc.
    Repeat         { fg = asparagus }, --   for, do, while, etc.
    Label          { fg = asparagus }, --    case, default, etc.
    Operator       { fg = asparagus }, -- "sizeof", "+", "*", etc.
    Keyword        { fg = asparagus }, --  any other keyword
    Exception      { fg = asparagus }, --  try, catch, throw

    PreProc        { fg = jade }, -- (preferred) generic Preprocessor
    Include        { fg = jade }, --  preprocessor #include
    Define         { fg = jade }, --   preprocessor #define
    Macro          { fg = jade }, --    same as Define
    PreCondit      { fg = jade }, --  preprocessor #if, #else, #endif, etc.

    Type           { fg = purple }, -- (preferred) int, long, char, etc.
    StorageClass   { fg = purple }, -- static, register, volatile, etc.
    Structure      { fg = purple }, --  struct, union, enum, etc.
    Typedef        { fg = purple }, --  A typedef

    Special        { fg = teak }, -- (preferred) any special symbol
    SpecialChar    { fg = teak }, --  special character in a constant
    Tag            { fg = teak }, --    you can use CTRL-] on this
    Delimiter      { fg = teak }, --  character that needs attention
    SpecialComment { fg = teak }, -- special things inside a comment
    Debug          { fg = teak }, --    debugging statements

    Bold       { gui = 'bold' },
    Underlined { gui = "underline" }, -- (preferred) text that stands out, HTML links
    -- Italic     { gui = "italic" },

    -- ("Ignore", below, may be invisible...)
    -- Ignore         { }, -- (preferred) left blank, hidden  |hl-Ignore|

    Error          { ErrorMsg }, -- (preferred) any erroneous construct

    Todo           { fg = jade, bg = ebony_clay, gui = 'reverse' }, -- (preferred) anything that needs extra attention; mostly the keywords TODO FIXME and XXX

    -- These groups are for the native LSP client. Some other LSP clients may
    -- use these groups, or use their own. Consult your LSP client's
    -- documentation.

    -- LspReferenceText                     { }, -- used for highlighting "text" references
    -- LspReferenceRead                     { }, -- used for highlighting "read" references
    -- LspReferenceWrite                    { }, -- used for highlighting "write" references

    LspDiagnosticsDefaultError           { fg = old_rose }, -- Used as the base highlight group. Other LspDiagnostic highlights link to this by default (except Underline)
    LspDiagnosticsDefaultWarning         { fg = teak }, -- Used as the base highlight group. Other LspDiagnostic highlights link to this by default (except Underline)
    LspDiagnosticsDefaultInformation     { Normal }, -- Used as the base highlight group. Other LspDiagnostic highlights link to this by default (except Underline)
    LspDiagnosticsDefaultHint            { fg = steel_blue }, -- Used as the base highlight group. Other LspDiagnostic highlights link to this by default (except Underline)

    -- LspDiagnosticsVirtualTextError       { }, -- Used for "Error" diagnostic virtual text
    -- LspDiagnosticsVirtualTextWarning     { }, -- Used for "Warning" diagnostic virtual text
    -- LspDiagnosticsVirtualTextInformation { }, -- Used for "Information" diagnostic virtual text
    -- LspDiagnosticsVirtualTextHint        { }, -- Used for "Hint" diagnostic virtual text

    LspDiagnosticsUnderlineError         { LspDiagnosticsDefaultError }, -- Used to underline "Error" diagnostics
    LspDiagnosticsUnderlineWarning       { LspDiagnosticsDefaultWarning }, -- Used to underline "Warning" diagnostics
    LspDiagnosticsUnderlineInformation   { LspDiagnosticsDefaultInformation }, -- Used to underline "Information" diagnostics
    LspDiagnosticsUnderlineHint          { LspDiagnosticsDefaultHint }, -- Used to underline "Hint" diagnostics

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

    -- TSAnnotation         { };    -- For C++/Dart attributes, annotations that can be attached to the code to denote some kind of meta information.
    -- TSAttribute          { };    -- (unstable) TODO: docs
    -- TSBoolean            { };    -- For booleans.
    -- TSCharacter          { };    -- For characters.
    -- TSComment            { };    -- For comment blocks.
    -- TSConstructor        { };    -- For constructor calls and definitions: ` { }` in Lua, and Java constructors.
    -- TSConditional        { };    -- For keywords related to conditionnals.
    -- TSConstant           { };    -- For constants
    -- TSConstBuiltin       { };    -- For constant that are built in the language: `nil` in Lua.
    -- TSConstMacro         { };    -- For constants that are defined by macros: `NULL` in C.
    TSError              { fg = old_rose };    -- For syntax/parser errors.
    -- TSException          { };    -- For exception related keywords.
    -- TSField              { };    -- For fields.
    -- TSFloat              { };    -- For floats.
    -- TSFunction           { };    -- For function (calls and definitions).
    -- TSFuncBuiltin        { };    -- For builtin functions: `table.insert` in Lua.
    -- TSFuncMacro          { };    -- For macro defined fuctions (calls and definitions): each `macro_rules` in Rust.
    -- TSInclude            { };    -- For includes: `#include` in C, `use` or `extern crate` in Rust, or `require` in Lua.
    -- TSKeyword            { };    -- For keywords that don't fall in previous categories.
    -- TSKeywordFunction    { };    -- For keywords used to define a fuction.
    -- TSLabel              { };    -- For labels: `label:` in C and `:label:` in Lua.
    -- TSMethod             { };    -- For method calls and definitions.
    -- TSNamespace          { };    -- For identifiers referring to modules and namespaces.
    -- TSNone               { };    -- TODO: docs
    -- TSNumber             { };    -- For all numbers
    -- TSOperator           { };    -- For any operator: `+`, but also `->` and `*` in C.
    -- TSParameter          { };    -- For parameters of a function.
    -- TSParameterReference { };    -- For references to parameters of a function.
    -- TSProperty           { };    -- Same as `TSField`.
    -- TSPunctDelimiter     { };    -- For delimiters ie: `.`
    -- TSPunctBracket       { };    -- For brackets and parens.
    -- TSPunctSpecial       { };    -- For special punctutation that does not fall in the catagories before.
    -- TSRepeat             { };    -- For keywords related to loops.
    -- TSString             { };    -- For strings.
    -- TSStringRegex        { };    -- For regexes.
    -- TSStringEscape       { };    -- For escape characters within a string.
    -- TSSymbol             { };    -- For identifiers referring to symbols or atoms.
    -- TSType               { };    -- For types.
    -- TSTypeBuiltin        { };    -- For builtin types.
    -- TSVariable           { };    -- Any variable name that does not have another highlight.
    -- TSVariableBuiltin    { };    -- Variable names that are defined by the languages, like `this` or `self`.

    -- TSTag                { };    -- Tags like html tag names.
    -- TSTagDelimiter       { };    -- Tag delimiter like `<` `>` `/`
    -- TSText               { };    -- For strings considered text in a markup language.
    -- TSEmphasis           { };    -- For text to be represented with emphasis.
    -- TSUnderline          { };    -- For text to be represented with an underline.
    -- TSStrike             { };    -- For strikethrough text.
    -- TSTitle              { };    -- Text that is part of a title.
    -- TSLiteral            { };    -- Literal text.
    -- TSURI                { };    -- Any URI like a link or email.

    GitSignsAdd          { fg = asparagus };
    GitSignsChange       { fg = teak };
    GitSignsDelete       { fg = old_rose };
  }
end)

-- return our parsed theme for extension or use else where.
return theme

-- vi:nowrap
