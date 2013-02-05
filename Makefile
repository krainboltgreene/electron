REPORTER = list

test: 
	@NODE_ENV=test ./node_modules/.bin/mocha \
		--compilers coffee:coffee-script \
		--reporter $(REPORTER) 		 \
		./tests/*

.PHONY: test


