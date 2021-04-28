lua << EOF
package.loaded['cosmic_latte'] = nil
package.loaded['cosmic_latte.utils'] = nil
package.loaded['cosmic_latte.colors'] = nil
package.loaded['cosmic_latte.theme'] = nil

require('cosmic_latte').setup()
EOF
