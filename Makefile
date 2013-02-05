REPORTER = list

electron: 
	browserify ./electron.coffee -o ./built/electron.js

test: 
	@NODE_ENV=test ./node_modules/.bin/mocha \
		--compilers coffee:coffee-script \
		--reporter $(REPORTER) 		 \
		./tests/*

.PHONY: test


