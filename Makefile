BUILD_DIR = build
COFFEE = coffee --map -o $(BUILD_DIR)
CLOSURE = closure-compiler # --compilation_level ADVANCED_OPTIMIZATIONS
SRC_DIR = src


TEST_DIR = testsuite


DEBUG_TEST_SRC_FILES = \
	$(TEST_DIR)/kidomi.test.base.coffee \
	$(TEST_DIR)/kidomi.test.coffee \
	$(TEST_DIR)/kidomi.test.release.coffee

RELEASE_TEST_SRC_FILES = \
	$(TEST_DIR)/kidomi.test.base.coffee \
	$(TEST_DIR)/kidomi.test.release.coffee

TEST_DEST_FILES = \
	$(BUILD_DIR)/run-qunit.js \
	$(BUILD_DIR)/test.html \
	$(BUILD_DIR)/qunit-1.12.0.css \
	$(BUILD_DIR)/qunit-1.12.0.js


all: release

release: $(BUILD_DIR)/kidomi.min.js

debug: $(BUILD_DIR)/kidomi.js

test: $(BUILD_DIR)/kidomi.test.js $(TEST_DEST_FILES)

run-test: test
	phantomjs $(BUILD_DIR)/run-qunit.js $(BUILD_DIR)/test.html

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(BUILD_DIR)/kidomi.min.js: $(BUILD_DIR) $(BUILD_DIR)/kidomi.js
	$(CLOSURE) --js $(BUILD_DIR)/kidomi.js \
		--js_output_file $(BUILD_DIR)/kidomi.min.js

$(BUILD_DIR)/kidomi.js: $(BUILD_DIR) $(SRC_DIR)/kidomi.coffee
	$(COFFEE) -c $(SRC_DIR)/kidomi.coffee

$(BUILD_DIR)/kidomi.test.js: $(DEBUG_TEST_SRC_FILES)
	$(COFFEE) --bare -j kidomi.test.js -c $(DEBUG_TEST_SRC_FILES)


$(BUILD_DIR)/run-qunit.js: $(TEST_DIR)/run-qunit.js
	cp $(TEST_DIR)/run-qunit.js $(BUILD_DIR)

$(BUILD_DIR)/test.html: $(TEST_DIR)/test.html
	cp $(TEST_DIR)/test.html $(BUILD_DIR)

$(BUILD_DIR)/qunit-1.12.0.js: $(TEST_DIR)/qunit-1.12.0.js
	cp $(TEST_DIR)/qunit-1.12.0.js $(BUILD_DIR)

$(BUILD_DIR)/qunit-1.12.0.css: $(TEST_DIR)/qunit-1.12.0.css
	cp $(TEST_DIR)/qunit-1.12.0.css $(BUILD_DIR)


.PHONY: clean $(BUILD_DIR)

clean:
	rm -rf $(BUILD_DIR)
