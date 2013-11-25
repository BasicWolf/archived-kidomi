BUILD_DIR = build
COFFEE = coffee --map -o $(BUILD_DIR)
CLOSURE = closure-compiler --compilation_level ADVANCED_OPTIMIZATIONS
SRC_DIR = src
TEST_DIR = testsuite


DEBUG_TEST_SRC_FILES = \
	$(TEST_DIR)/kidomi_test_common.coffee \
	$(TEST_DIR)/kidomi_test.coffee \
	$(TEST_DIR)/kidomi_test_release.coffee

RELEASE_TEST_SRC_FILES = \
	$(TEST_DIR)/kidomi_test_common.coffee \
	$(TEST_DIR)/kidomi_test_release.coffee

TEST_DEST_FILES = \
	$(BUILD_DIR)/run-qunit.js \
	$(BUILD_DIR)/test.html \
	$(BUILD_DIR)/qunit-1.12.0.css \
	$(BUILD_DIR)/qunit-1.12.0.js

TEST_RELEASE_BUNDLE_DEST_FILES = \
	$(TEST_DEST_FILES) \
	$(BUILD_DIR)/test_release_bundle.html

TEST_RELEASE_STANDALONE_FILES = \
	$(TEST_DEST_FILES) \
	$(BUILD_DIR)/test_release_standalone.html


## global targets ##
####################
all: release

release: $(BUILD_DIR)/kidomi.min.js

debug: $(BUILD_DIR)/kidomi.js


## test targets ##
##################
run-test: test
	phantomjs $(BUILD_DIR)/run-qunit.js $(BUILD_DIR)/test.html

run-test-release-bundle: test-release-bundle
	phantomjs $(BUILD_DIR)/run-qunit.js $(BUILD_DIR)/test_release_bundle.html

run-test-release-standalone: test-release-standalone
	phantomjs $(BUILD_DIR)/run-qunit.js $(BUILD_DIR)/test_release_standalone.html

run-test-all: run-test run-test-release-bundle run-test-release-standalone


test: $(BUILD_DIR)/kidomi_test.js $(TEST_DEST_FILES) | ${BUILD_DIR}

test-release-bundle:  $(TEST_RELEASE_BUNDLE_DEST_FILES) \
					  $(BUILD_DIR)/kidomi_test_release_bundle.js \
                      | ${BUILD_DIR}

test-release-standalone: $(TEST_RELEASE_STANDALONE_FILES) \
						 $(BUILD_DIR)/kidomi_test_release_standalone.js \
						 | ${BUILD_DIR}

test-all: test test-release-bundle test-release-standalone


## testsuite build ##
#####################
$(BUILD_DIR)/kidomi_test.js: $(DEBUG_TEST_SRC_FILES) $(BUILD_DIR)/kidomi.js
	$(COFFEE) --bare -j kidomi_test.js -c $(DEBUG_TEST_SRC_FILES)

$(BUILD_DIR)/kidomi_test_release_bundle.js: $(BUILD_DIR)/kidomi_test.js
	$(CLOSURE) --js $(BUILD_DIR)/kidomi.js --js $(BUILD_DIR)/kidomi_test.js \
		--externs $(BUILD_DIR)/qunit-1.12.0.js \
		--warning_level QUIET \
		--js_output_file $(BUILD_DIR)/kidomi_test_release_bundle.js

$(BUILD_DIR)/kidomi_test_release_standalone.js: $(RELEASE_TEST_SRC_FILES) \
												$(BUILD_DIR)/kidomi.min.js
	$(COFFEE) --bare -j kidomi_test_release_standalone.js -c $(RELEASE_TEST_SRC_FILES)


$(BUILD_DIR)/%.js: $(TEST_DIR)/%.js
	cp $< $(BUILD_DIR)

$(BUILD_DIR)/%.css: $(TEST_DIR)/%.css
	cp $< $(BUILD_DIR)

$(BUILD_DIR)/%.html: $(TEST_DIR)/%.html
	cp $< $(BUILD_DIR)


## kidomi build ##
##################
$(BUILD_DIR)/kidomi.js: $(SRC_DIR)/kidomi.coffee | ${BUILD_DIR}
	$(COFFEE) -c $(SRC_DIR)/kidomi.coffee

$(BUILD_DIR)/kidomi.min.js: $(BUILD_DIR)/kidomi.js | ${BUILD_DIR}
	$(CLOSURE) --js $(BUILD_DIR)/kidomi.js \
		--js_output_file $(BUILD_DIR)/kidomi.min.js


## miscellanious ##
###################
${BUILD_DIR}:
	mkdir ${BUILD_DIR}

clean:
	rm -rf $(BUILD_DIR)

.PHONY: clean
