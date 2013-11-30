COFFEE = coffee --map -o $(BUILD_DIR)
CLOSURE = closure-compiler --compilation_level ADVANCED_OPTIMIZATIONS
SRC_DIR = src
BUILD_DIR = build

### global targets ###
all: release

release: $(BUILD_DIR)/kidomi.min.js

debug: $(BUILD_DIR)/kidomi.js


### kidomi build ###
$(BUILD_DIR)/kidomi.js: $(SRC_DIR)/kidomi.coffee | ${BUILD_DIR}
	$(COFFEE) -c $(SRC_DIR)/kidomi.coffee

$(BUILD_DIR)/kidomi.min.js: $(BUILD_DIR)/kidomi.js | ${BUILD_DIR}
	$(CLOSURE) --js $(BUILD_DIR)/kidomi.js \
		--js_output_file $(BUILD_DIR)/kidomi.min.js


### miscellanious ###
${BUILD_DIR}:
	mkdir ${BUILD_DIR}

clean:
	rm -rf $(BUILD_DIR)

.PHONY: clean

### testsuite build ###
include Makefile.testsuite.mk
