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


### tests runner targets ###
run-test-all: run-test run-test-release-bundle run-test-release-standalone

run-test: test
	phantomjs $(BUILD_DIR)/run-qunit.js $(BUILD_DIR)/test.html

run-test-release-bundle: test-release-bundle
	phantomjs $(BUILD_DIR)/run-qunit.js $(BUILD_DIR)/test_release_bundle.html

run-test-release-standalone: test-release-standalone
	phantomjs $(BUILD_DIR)/run-qunit.js $(BUILD_DIR)/test_release_standalone.html

### testsuite targets ###
test-all: test test-release-bundle test-release-standaloen

test: $(BUILD_DIR)/kidomi_test.js $(TEST_DEST_FILES) | ${BUILD_DIR}

test-release-bundle:  $(TEST_RELEASE_BUNDLE_DEST_FILES) \
					  $(BUILD_DIR)/kidomi_test_release_bundle.js \
                      | ${BUILD_DIR}

test-release-standalone: $(TEST_RELEASE_STANDALONE_FILES) \
						 $(BUILD_DIR)/kidomi_test_release_standalone.js \
						 | ${BUILD_DIR}



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

