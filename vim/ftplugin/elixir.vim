" Required, tell ALE where to find Elixir LS

let g:ale_elixir_elixir_ls_release = expand("~/repos/elixir-ls/rel")
let g:vim_elixir_ls_elixir_ls_dir = expand("~/repos/elixir-ls")

let g:ale_fixers = ['mix_format']
let g:ale_linters.elixir = ['elixir-ls', 'credo']
