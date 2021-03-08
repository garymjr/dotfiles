local Color, colors, Group = require('colorbuddy').setup()

Color.new('white', '#abb2bf')
Color.new('syntax_bg', '#282c34')
Group.new('Normal', colors.white, colors.syntax_bg)
