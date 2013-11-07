COFFEE = coffee --map

all: debug

debug: src/kidoma.js

src/kidoma.js:
	$(COFFEE) -c src/kidoma.coffee 

tests: 
	phantomjs test/run-qunit.js test/test.html


