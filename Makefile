all: build live

live:
	mkdir -p "./dist"
	cp "./src/index.html" "./dist/index.html"
	elm-live "./src/Main.elm" --dir dist -- --output "./dist/main.js"

build:
	mkdir -p "./dist"
	cp "./src/index.html" "./dist/index.html"
	elm make "./src/Main.elm" --output "./dist/main.js" --optimize
