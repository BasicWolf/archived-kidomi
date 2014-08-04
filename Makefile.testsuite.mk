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
	$(BUILD_DIR)/qunit-1.12.0.js \
	$(BUILD_DIR)/jquery-2.1.1.min.js

TEST_RELEASE_FILES = \
	$(TEST_DEST_FILES) \
	$(BUILD_DIR)/test_release.html

show-test-usage:
	@echo 'TESTS:'
	@echo  'test             - build tests'
	@echo 'run-test-all      - run all tests'
	@echo 'run-test          - run development tests'
	@echo 'run-test-release  - run tests with kidomi.min.js'

### tests runner targets ###
run-test-all: run-test run-test-release

run-test: test
	phantomjs $(BUILD_DIR)/run-qunit.js $(BUILD_DIR)/test.html

run-test-release: test-release
	phantomjs $(BUILD_DIR)/run-qunit.js $(BUILD_DIR)/test_release.html

### testsuite targets ###
test-all: test test-release

test: $(BUILD_DIR)/kidomi_test.js $(TEST_DEST_FILES) | ${BUILD_DIR}

test-release: $(TEST_RELEASE_FILES) \
				 $(BUILD_DIR)/kidomi_test_release.js \
				 | ${BUILD_DIR}



## testsuite build ##
#####################
$(BUILD_DIR)/kidomi_test.js: $(DEBUG_TEST_SRC_FILES) $(BUILD_DIR)/kidomi.js
	$(COFFEE) --bare -j kidomi_test.js -c $(DEBUG_TEST_SRC_FILES)

$(BUILD_DIR)/kidomi_test_release.js: $(RELEASE_TEST_SRC_FILES) \
										$(BUILD_DIR)/kidomi.min.js
	$(COFFEE) --bare -j kidomi_test_release.js -c $(RELEASE_TEST_SRC_FILES)


$(BUILD_DIR)/%.js: $(TEST_DIR)/%.js
	cp $< $(BUILD_DIR)

$(BUILD_DIR)/%.css: $(TEST_DIR)/%.css
	cp $< $(BUILD_DIR)

$(BUILD_DIR)/%.html: $(TEST_DIR)/%.html
	cp $< $(BUILD_DIR)

