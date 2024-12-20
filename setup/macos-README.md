# Install the following

** Homebrew **

## Window Management and Helpers
- Aerospace
- JankyBorders
```
brew tap FelixKratz/formulae
brew install borders
```

- SketchyBar
```
brew tap FelixKratz/formulae
brew install sketchybar

mkdir -p ~/.config/sketchybar/plugins
cp $(brew --prefix)/share/sketchybar/examples/sketchybarrc ~/.config/sketchybar/sketchybarrc
cp -r $(brew --prefix)/share/sketchybar/examples/plugins/ ~/.config/sketchybar/plugins/
```
