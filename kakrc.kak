
source "%val{config}/plugins/plug.kak/rc/plug.kak"

plug "andreyorst/fzf.kak"

add-highlighter global/ number-lines


map -docstring 'fzf-mode' global user z ': fzf-mode<ret>'
map -docstring 'write buffer' global user w ': write<ret>'
