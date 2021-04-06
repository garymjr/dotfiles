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

local shark = hsl('#1D2021')
local ivory = hsl('#FFFFF0')
local killarney = hsl('#336633')
local flush_mahogany = hsl('#CB4335')
local wisteria = hsl('#A569BD')
local monza = hsl('#DC0000')
local japanese_laurel = hsl('#007200')
local jungle_green = hsl('#28B463')
local mountain_meadow = hsl('#2ECC71')
local green_malachite = hsl('#20DE20')
local monte_carlo = hsl('#73C6B6')
local tree_poppy = hsl('#FD971F')
local masala = hsl('#504945')
local eerie_black = hsl('#1A1A1A')
local mine_shaft = hsl('#282828')
local forest_green = hsl('#228822')
local eucalyptus = hsl('#239b56')
local quick_silver = hsl('#999999')
local saffron = hsl('#F4D03F')
local malachite = hsl('#458588')
local teal = hsl('#007A7A')

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

    Cursor       { fg = shark, bg = ivory }, -- character under the cursor
    CursorIM     { Cursor, bg = killarney }, -- like Cursor, but used when in IME mode |CursorIM|
    ColorColumn  { bg = shark }, -- used for the columns set with 'colorcolumn'
    DiffAdd      { fg = shark, bg = japanese_laurel }, -- diff mode: Added line |diff.txt|
    DiffChange   { DiffAdd }, -- diff mode: Changed line |diff.txt|
    DiffDelete   { fg = shark, bg = monza }, -- diff mode: Deleted line |diff.txt|
    DiffText     { fg = jungle_green, bg = shark }, -- diff mode: Changed text within a changed line |diff.txt|
    Directory    { fg = mountain_meadow, gui = 'bold' }, -- directory names (and other special names in listings)
    Folded       { fg = green_malachite, bg = shark }, -- line used for closed folds
    FoldColumn   { Folded }, -- 'foldcolumn'
    IncSearch    { fg = shark, bg = tree_poppy }, -- 'incsearch' highlighting; also used for the text replaced with ":s///c"
    MatchParen   { fg = mountain_meadow }, -- The character under the cursor or just before it, if it is a paired bracket, and its match. |pi_paren.txt|
    ModeMsg      { fg = mountain_meadow, gui = 'bold' }, -- 'showmode' message (e.g., "-- INSERT -- ")
    MoreMsg      { ModeMsg }, -- |more-prompt|
    LineNr       { fg = masala }, -- Line number for ":number" and ":#" commands, and when 'number' or 'relativenumber' option is set.
    Normal       { fg = ivory, bg = eerie_black }, -- normal text
    CursorLine   { bg = mine_shaft }, -- Screen-line at the cursor, when 'cursorline' is set.  Low-priority if foreground (ctermfg OR guifg) is not set.
    Comment      { fg = forest_green }, -- any comment
    NonText      { fg = tree_poppy }, -- '@' at the end of the window, characters from 'showbreak' and other characters that do not really exist in the text (e.g., ">" displayed when a double-wide character doesn't fit at the end of the line). See also |hl-EndOfBuffer|.
    Pmenu        { fg = eucalyptus, bg = mine_shaft }, -- Popup menu: normal item.
    PmenuSel     { fg = shark, bg = quick_silver }, -- Popup menu: selected item.
    PmenuSbar    { fg = shark, bg = eucalyptus }, -- Popup menu: scrollbar.
    PmenuThumb   { fg = quick_silver, bg = shark }, -- Popup menu: Thumb of the scrollbar.
    Question     { fg = tree_poppy }, -- |hit-enter| prompt and yes/no questions
    Search       { fg = shark, bg = tree_poppy }, -- Last search pattern highlighting (see 'hlsearch').  Also used for similar items that need to stand out.
    SignColumn   { fg = eucalyptus, bg = shark }, -- column where |signs| are displayed
    SpecialKey   { fg = quick_silver }, -- Unprintable characters: text displayed differently from what it really is.  But not 'listchars' whitespace. |hl-Whitespace|
    StatusLine   { fg = shark, bg = forest_green }, -- status line of current window
    StatusLineNC { fg = shark, bg = killarney }, -- status lines of not-current windows Note: if this is equal to "StatusLine" Vim will use "^^^" in the status line of the current window.
    TabLine      { StatusLine }, -- tab pages line, not active tab page label
    TabLineFill  { TabLine }, -- tab pages line, where there are no labels
    TabLineSel   { TabLine, gui = 'reverse' }, -- tab pages line, active tab page label
    Title        { fg = mountain_meadow }, -- titles for output from ":set all", ":autocmd" etc.
    Visual       { bg = mine_shaft }, -- Visual mode selection
    VertSplit    { fg = mine_shaft }, -- the column separating vertically split windows
    WarningMsg   { fg = monza, bg = teal }, -- warning messages
    WildMenu     { fg = malachite, bg = mine_shaft }, -- current match in 'wildmenu' completion
    VisualNOS    { Visual }, -- Visual mode selection when vim is "Not Owning the Selection".
    -- Conceal      { }, -- placeholder characters substituted for concealed text (see 'conceallevel')
    -- lCursor      { }, -- the character under the cursor when |language-mapping| is used (see 'guicursor')
    -- CursorColumn { }, -- Screen-column at the cursor, when 'cursorcolumn' is set.
    -- EndOfBuffer  { }, -- filler lines (~) after the end of the buffer.  By default, this is highlighted like |hl-NonText|.
    -- TermCursor   { }, -- cursor in a focused terminal
    -- TermCursorNC { }, -- cursor in an unfocused terminal
    -- Substitute   { }, -- |:substitute| replacement text highlighting
    -- CursorLineNr { }, -- Like LineNr when 'cursorline' or 'relativenumber' is set for the cursor line.
    -- MsgArea      { }, -- Area for messages and cmdline
    -- MsgSeparator { }, -- Separator for scrolled messages, `msgsep` flag of 'display'
    -- NormalFloat  { }, -- Normal text in floating windows.
    -- NormalNC     { }, -- normal text in non-current windows
    -- QuickFixLine { }, -- Current |quickfix| item in the quickfix window. Combined with |hl-CursorLine| when the cursor is there.
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

    Constant       { fg = flush_mahogany }, -- (preferred) any constant
    String         { fg = flush_mahogany }, --   a string constant: "this is a string"
    -- Character      { }, --  a character constant: 'c', '\n'
    Number         { fg = wisteria }, --   a number constant: 234, 0xff
    Boolean        { Number }, --  a boolean constant: TRUE, false
    -- Float          { }, --    a floating point constant: 2.3e10

    Identifier     { fg = tree_poppy }, -- (preferred) any variable name
    Function       { fg = monte_carlo }, -- function name (also: methods for classes)

    Statement      { fg = saffron }, -- (preferred) any statement
    -- Conditional    { }, --  if, then, else, endif, switch, etc.
    -- Repeat         { }, --   for, do, while, etc.
    -- Label          { }, --    case, default, etc.
    -- Operator       { }, -- "sizeof", "+", "*", etc.
    -- Keyword        { }, --  any other keyword
    -- Exception      { }, --  try, catch, throw

    PreProc        { fg = tree_poppy }, -- (preferred) generic Preprocessor
    -- Include        { }, --  preprocessor #include
    -- Define         { }, --   preprocessor #define
    -- Macro          { }, --    same as Define
    -- PreCondit      { }, --  preprocessor #if, #else, #endif, etc.

    Type           { fg = malachite }, -- (preferred) int, long, char, etc.
    Structure      { fg = mountain_meadow }, --  struct, union, enum, etc.
    -- Typedef        { }, --  A typedef

    Special        { fg = quick_silver }, -- (preferred) any special symbol
    -- SpecialChar    { }, --  special character in a constant
    -- Tag            { }, --    you can use CTRL-] on this
    -- Delimiter      { }, --  character that needs attention
    -- SpecialComment { }, -- special things inside a comment
    StorageClass   { Special }, -- static, register, volatile, etc.
    Debug          { fg = monza, bg = shark }, --    debugging statements

    Underlined { fg = killarney, gui = 'underline' }, -- (preferred) text that stands out, HTML links
    -- Bold       { gui = "bold" },
    -- Italic     { gui = "italic" },

    -- ("Ignore", below, may be invisible...)
    -- Ignore         { }, -- (preferred) left blank, hidden  |hl-Ignore|

    Error          { fg = ivory, bg = monza, gui = 'bold' }, -- (preferred) any erroneous construct
    ErrorMsg     { Error }, -- error messages on the command line

    Todo           { fg = ivory, bg = killarney }, -- (preferred) anything that needs extra attention; mostly the keywords TODO FIXME and XXX

    -- These groups are for the native LSP client. Some other LSP clients may
    -- use these groups, or use their own. Consult your LSP client's
    -- documentation.

    -- LspReferenceText                     { }, -- used for highlighting "text" references
    -- LspReferenceRead                     { }, -- used for highlighting "read" references
    -- LspReferenceWrite                    { }, -- used for highlighting "write" references

    LspDiagnosticsDefaultError           { fg = flush_mahogany }, -- Used as the base highlight group. Other LspDiagnostic highlights link to this by default (except Underline)
    LspDiagnosticsDefaultWarning         { fg = saffron }, -- Used as the base highlight group. Other LspDiagnostic highlights link to this by default (except Underline)
    LspDiagnosticsDefaultInformation     { fg = malachite }, -- Used as the base highlight group. Other LspDiagnostic highlights link to this by default (except Underline)
    LspDiagnosticsDefaultHint            { fg = quick_silver }, -- Used as the base highlight group. Other LspDiagnostic highlights link to this by default (except Underline)

    -- LspDiagnosticsVirtualTextError       { }, -- Used for "Error" diagnostic virtual text
    -- LspDiagnosticsVirtualTextWarning     { }, -- Used for "Warning" diagnostic virtual text
    -- LspDiagnosticsVirtualTextInformation { }, -- Used for "Information" diagnostic virtual text
    -- LspDiagnosticsVirtualTextHint        { }, -- Used for "Hint" diagnostic virtual text

    LspDiagnosticsUnderlineError         { LspDiagnosticsDefaultError, gui = 'underline' }, -- Used to underline "Error" diagnostics
    LspDiagnosticsUnderlineWarning       { LspDiagnosticsDefaultWarning, gui = 'underline' }, -- Used to underline "Warning" diagnostics
    LspDiagnosticsUnderlineInformation   { LspDiagnosticsDefaultInformation, gui = 'underline' }, -- Used to underline "Information" diagnostics
    LspDiagnosticsUnderlineHint          { LspDiagnosticsDefaultHint, gui = 'underline' }, -- Used to underline "Hint" diagnostics

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

  }
end)

-- return our parsed theme for extension or use else where.
return theme

-- vi:nowrap
