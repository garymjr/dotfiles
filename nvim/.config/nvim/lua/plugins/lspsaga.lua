local remap = require('core.utils').remap

require('lspsaga').init_lsp_saga({
  use_saga_diagnostic_sign = true,
  error_sign = '',
  warn_sign = '',
  hint_sign = '',
  infor_sign = '',
  dianostic_header_icon = '   ',
  code_action_prompt = {
    enable = false
  }
})

remap('n', 'cd', [[<cmd>lua require('lspsaga.diagnostic').show_line_diagnostics()<cr>]], { noremap = true, silent = true })
remap('n', 'K', [[<cmd>lua require('lspsaga.hover').render_hover_doc()<cr>]], { noremap = true, silent = true })
remap('n', 'gs', [[<cmd>lua require('lspsaga.signaturehelp').signature_help()<cr>]], { noremap = true, silent = true })
remap('n', 'gD', [[<cmd>lua require('lspsaga.provider').preview_definition()<cr>]], { noremap = true, silent = true })
