make:
	elm make src/Main.elm --output dist/main.js
	sass src/main.scss dist/main.css
	cp src/index.html dist/index.html
