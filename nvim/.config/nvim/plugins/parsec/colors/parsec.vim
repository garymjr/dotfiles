lua package.loaded['parsec'] = nil
lua package.loaded['parsec.colors'] = nil
lua package.loaded['parsec.theme'] = nil
lua package.loaded['parsec.utils'] = nil

lua require('parsec').load_theme()
