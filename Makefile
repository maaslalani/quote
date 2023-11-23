live:
	elm-live src/Main.elm -- --output main.js

build:
	elm make src/Main.elm --output main.js --optimize
