live:
	mkdir -p dist
	cp index.html dist/index.html
	elm-live Main.elm --dir dist -- --output dist/main.js

build:
	mkdir -p dist
	cp index.html dist/index.html
	elm make Main.elm --output dist/main.js --optimize
