$env.path ++= [
  "/opt/homebrew/bin",
  "~/go/bin",
  "/usr/local/bin",
  "/opt/homebrew/opt/libpq/bin",
  "/opt/homebrew/opt/mysql-client/bin"
]

$env.config.buffer_editor = "code"

$env.KERL_BUILD_DOCS = "yes"
$env.ERL_AFLAGS = "-kernel shell_history enabled"

$env.ERL_AFLAGS = "-public_key cacerts_path '\"/Users/gamurray/Cisco_Umbrella_Root_CA.cer\"'"
$env.ERL_ZFLAGS = "-public_key cacerts_path '\"/Users/gamurray/Cisco_Umbrella_Root_CA.cer\"'"

$env.GOPROXY = "direct"

alias c = ^open -a `/Applications/Visual Studio Code - Insiders.app`
alias lg = lazygit
alias chez = chezmoi

mkdir ($nu.data-dir | path join "vendor/autoload")
^mise activate nu | save -f ($nu.data-dir | path join "vendor/autoload/mise.nu")
^zoxide init nushell | save -f ($nu.data-dir | path join "vendor/autoload/zoxide.nu")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")