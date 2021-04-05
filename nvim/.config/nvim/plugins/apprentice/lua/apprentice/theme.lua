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

local eerie_black = hsl('#262626')
local silver = hsl('#bcbcbc')
local granite_gray = hsl('#585858')
local dove_gray = hsl('#6c6c6c')
local portafino = hsl('#ffffaf')
local flush_orange = hsl('#ff8700')
local matrix = hsl('#af5f5f')
local hippie_blue = hsl('#5f87af')
local polo_blue = hsl('#87afd7')
local shadow_blue = hsl('#8787af')
local tundora = hsl('#444444')
local bay_leaf = hsl('#87af87')
local steel_teal = hsl('#5f8787')
local glade_green = hsl('#5f875f')
local clay_creek = hsl('#87875f')
local mine_shaft = hsl('#303030')
local tradewind = hsl('#5fafaf')

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

    Normal       { bg = eerie_black, fg = silver }, -- normal text
    NonText      { fg = granite_gray }, -- '@' at the end of the window, characters from 'showbreak' and other characters that do not really exist in the text (e.g., ">" displayed when a double-wide character doesn't fit at the end of the line). See also |hl-EndOfBuffer|.
    EndOfBuffer  { NonText }, -- filler lines (~) after the end of the buffer.  By default, this is highlighted like |hl-NonText|.
    LineNr       { bg = eerie_black, fg = dove_gray }, -- Line number for ":number" and ":#" commands, and when 'number' or 'relativenumber' option is set.
    FoldColumn   { LineNr }, -- 'foldcolumn'
    Folded       { FoldColumn }, -- line used for closed folds
    MatchParen   { bg = eerie_black, fg = portafino }, -- The character under the cursor or just before it, if it is a paired bracket, and its match. |pi_paren.txt|
    SignColumn   { LineNr }, -- column where |signs| are displayed
    Comment      { fg = granite_gray }, -- any comment
    Conceal      { fg = silver }, -- placeholder characters substituted for concealed text (see 'conceallevel')
    ErrorMsg     { bg = eerie_black, fg = matrix, gui = 'reverse' }, -- error messages on the command line
    ModeMsg      { bg = eerie_black, fg = bay_leaf, gui = 'reverse' }, -- 'showmode' message (e.g., "-- INSERT -- ")
    MoreMsg      { fg = steel_teal }, -- |more-prompt|
    Pmenu        { bg = tundora, fg = silver }, -- Popup menu: normal item.
    PmenuSel     { bg = steel_teal, fg = eerie_black }, -- Popup menu: selected item.
    PmenuSbar    { bg = granite_gray }, -- Popup menu: scrollbar.
    PmenuThumb   { bg = steel_teal, fg = steel_teal }, -- Popup menu: Thumb of the scrollbar.
    Question     { fg = bay_leaf }, -- |hit-enter| prompt and yes/no questions
    TabLine      { bg = tundora, fg = clay_creek }, -- tab pages line, not active tab page label
    TabLineFill  { bg = tundora, fg = tundora }, -- tab pages line, where there are no labels
    TabLineSel   { bg = clay_creek, fg = eerie_black }, -- tab pages line, active tab page label
    WarningMsg   { fg = matrix }, -- warning messages
    Cursor       { bg = dove_gray }, -- character under the cursor
    CursorColumn { bg = mine_shaft }, -- Screen-column at the cursor, when 'cursorcolumn' is set.
    CursorLine   { CursorColumn }, -- Screen-line at the cursor, when 'cursorline' is set.  Low-priority if foreground (ctermfg OR guifg) is not set.
    StatusLine   { bg = clay_creek, fg = eerie_black }, -- status line of current window
    StatusLineNC { bg = tundora, fg = clay_creek }, -- status lines of not-current windows Note: if this is equal to "StatusLine" Vim will use "^^^" in the status line of the current window.
    Visual       { bg = eerie_black, fg = polo_blue, gui = 'reverse' }, -- Visual mode selection
    VisualNOS    { gui = 'underline' }, -- Visual mode selection when vim is "Not Owning the Selection".
    VertSplit    { bg = tundora, fg = tundora }, -- the column separating vertically split windows
    WildMenu     { bg = polo_blue, fg = eerie_black }, -- current match in 'wildmenu' completion
    SpecialKey   { fg = granite_gray }, -- Unprintable characters: text displayed differently from what it really is.  But not 'listchars' whitespace. |hl-Whitespace|
    Title        { fg = hsl('#ffffff') }, -- titles for output from ":set all", ":autocmd" etc.
    DiffAdd      { bg = eerie_black, fg = bay_leaf, gui = 'reverse' }, -- diff mode: Added line |diff.txt|
    DiffChange   { bg = eerie_black, fg = hippie_blue, gui = 'reverse' }, -- diff mode: Changed line |diff.txt|
    DiffDelete   { bg = eerie_black, fg = matrix, gui= 'reverse' }, -- diff mode: Deleted line |diff.txt|
    DiffText     { bg = eerie_black, fg = flush_orange, gui = 'reverse' }, -- diff mode: Changed text within a changed line |diff.txt|
    IncSearch    { bg = matrix, fg = eerie_black }, -- 'incsearch' highlighting; also used for the text replaced with ":s///c"
    Search       { bg = portafino, fg = eerie_black }, -- Last search pattern highlighting (see 'hlsearch').  Also used for similar items that need to stand out.
    Directory    { fg = tradewind }, -- directory names (and other special names in listings)
    ColorColumn  { bg = eerie_black }, -- used for the columns set with 'colorcolumn'
    CursorIM     { Cursor }, -- like Cursor, but used when in IME mode |CursorIM|
    QuickFixLine { Search }, -- Current |quickfix| item in the quickfix window. Combined with |hl-CursorLine| when the cursor is there.
    -- lCursor      { }, -- the character under the cursor when |language-mapping| is used (see 'guicursor')
    -- TermCursor   { }, -- cursor in a focused terminal
    -- TermCursorNC { }, -- cursor in an unfocused terminal
    -- Substitute   { }, -- |:substitute| replacement text highlighting
    -- CursorLineNr { }, -- Like LineNr when 'cursorline' or 'relativenumber' is set for the cursor line.
    -- MsgArea      { }, -- Area for messages and cmdline
    -- MsgSeparator { }, -- Separator for scrolled messages, `msgsep` flag of 'display'
    -- NormalFloat  { }, -- Normal text in floating windows.
    -- NormalNC     { }, -- normal text in non-current windows
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

    Constant       { fg = flush_orange }, -- (preferred) any constant
    String         { fg = bay_leaf }, --   a string constant: "this is a string"
    -- Character      { }, --  a character constant: 'c', '\n'
    Number         { Constant }, --   a number constant: 234, 0xff
    -- Boolean        { }, --  a boolean constant: TRUE, false
    Float          { Number }, --    a floating point constant: 2.3e10

    Identifier     { fg = hippie_blue }, -- (preferred) any variable name
    Function       { fg = portafino }, -- function name (also: methods for classes)

    Statement      { fg = polo_blue }, -- (preferred) any statement
    -- Conditional    { }, --  if, then, else, endif, switch, etc.
    -- Repeat         { }, --   for, do, while, etc.
    -- Label          { }, --    case, default, etc.
    -- Operator       { }, -- "sizeof", "+", "*", etc.
    -- Keyword        { }, --  any other keyword
    -- Exception      { }, --  try, catch, throw
    HelpCommand    { Statement },
    HelpExample    { Statement },

    PreProc        { fg = steel_teal }, -- (preferred) generic Preprocessor
    -- Include        { }, --  preprocessor #include
    -- Define         { }, --   preprocessor #define
    -- Macro          { }, --    same as Define
    -- PreCondit      { }, --  preprocessor #if, #else, #endif, etc.

    Type           { fg = shadow_blue }, -- (preferred) int, long, char, etc.
    -- StorageClass   { }, -- static, register, volatile, etc.
    -- Structure      { }, --  struct, union, enum, etc.
    -- Typedef        { }, --  A typedef

    Special        { fg = glade_green }, -- (preferred) any special symbol
    -- SpecialChar    { }, --  special character in a constant
    -- Tag            { }, --    you can use CTRL-] on this
    -- Delimiter      { }, --  character that needs attention
    -- SpecialComment { }, -- special things inside a comment
    -- Debug          { }, --    debugging statements

    Underlined { fg = steel_teal, gui = "underline" }, -- (preferred) text that stands out, HTML links
    -- Bold       { gui = "bold" },
    -- Italic     { gui = "italic" },

    -- ("Ignore", below, may be invisible...)
    -- Ignore         { }, -- (preferred) left blank, hidden  |hl-Ignore|

    Error          { fg = matrix }, -- (preferred) any erroneous construct

    Todo           { gui = 'reverse' }, -- (preferred) anything that needs extra attention; mostly the keywords TODO FIXME and XXX

    -- These groups are for the native LSP client. Some other LSP clients may
    -- use these groups, or use their own. Consult your LSP client's
    -- documentation.

    -- LspReferenceText                     { }, -- used for highlighting "text" references
    -- LspReferenceRead                     { }, -- used for highlighting "read" references
    -- LspReferenceWrite                    { }, -- used for highlighting "write" references

    LspDiagnosticsDefaultError           { fg = matrix }, -- Used as the base highlight group. Other LspDiagnostic highlights link to this by default (except Underline)
    LspDiagnosticsDefaultWarning         { fg = portafino }, -- Used as the base highlight group. Other LspDiagnostic highlights link to this by default (except Underline)
    LspDiagnosticsDefaultInformation     { fg = polo_blue }, -- Used as the base highlight group. Other LspDiagnostic highlights link to this by default (except Underline)
    LspDiagnosticsDefaultHint            { fg = dove_gray }, -- Used as the base highlight group. Other LspDiagnostic highlights link to this by default (except Underline)

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
    -- TSError              { };    -- For syntax/parser errors.
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
    TSVariable           { Normal };    -- Any variable name that does not have another highlight.
    -- TSVariableBuiltin    { };    -- Variable names that are defined by the languages, like `this` or `self`.

    -- TSTag                { };    -- Tags like html tag names.
    -- TSTagDelimiter       { };    -- Tag delimiter like `<` `>` `/`
    -- TSText               { };    -- For strings considered text in a markup language.
    -- TSEmphasis           { };    -- For text to be represented with emphasis.
    TSUnderline          { Underlined };    -- For text to be represented with an underline.
    -- TSStrike             { };    -- For strikethrough text.
    -- TSTitle              { };    -- Text that is part of a title.
    -- TSLiteral            { };    -- Literal text.
    -- TSURI                { };    -- Any URI like a link or email.

  }
end)

-- return our parsed theme for extension or use else where.
return theme

-- vi:nowrap
