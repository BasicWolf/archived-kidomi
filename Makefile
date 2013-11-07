COFFEE = coffee --map
SRC_DIR = src
TEST_DIR = testsuite

all: debug

debug: src/kidomi.js

test: $(TEST_DIR)/kidomi.test.js
	phantomjs testsuite/run-qunit.js testsuite/test.html


$(SRC_DIR)/kidomi.js: $(SRC_DIR)/kidomi.coffee
	$(COFFEE) -c $(SRC_DIR)/kidomi.coffee

$(TEST_DIR)/kidomi.js: $(SRC_DIR)/kidomi.js
	cp $(SRC_DIR)/kidomi.js $(TEST_DIR)

$(TEST_DIR)/kidomi.test.coffee: $(TEST_DIR)/kidomi.js

$(TEST_DIR)/kidomi.test.js: $(TEST_DIR)/kidomi.test.coffee
	$(COFFEE) --bare -c $(TEST_DIR)/kidomi.test.coffee

clean:
	rm -f $(TEST_DIR)/kidomi.test.js \
		$(TEST_DIR)/kidomi.test.map \
		$(SRC_DIR)/kidomi.js \
		$(SRC_DIR)/kidomi.map
