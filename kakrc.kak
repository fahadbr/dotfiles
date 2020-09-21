
source "%val{config}/plugins/plug.kak/rc/plug.kak"

plug "andreyorst/fzf.kak"
#plug "ul/kak-lsp" do %{
#    cargo install --locked --force --path .
#}

add-highlighter global/ number-lines


colorscheme desertex

map -docstring 'fzf-mode' global user z ': fzf-mode<ret>'
map -docstring 'write buffer' global user w ': write<ret>'

eval %sh{kak-lsp --kakoune -s $kak_session}
hook global WinSetOption filetype=(go|rust|c|cpp|scala) %{
        lsp-enable-window
}
