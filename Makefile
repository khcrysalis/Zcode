xcode_path := $(shell find /Applications -type d -name "Xcode*.app" -print -quit)
shared_frameworks_path := $(xcode_path)/Contents/SharedFrameworks

STRIP := $(shell command -v strip)
ZCODETMP := $(TMPDIR)/ZCODE
ZCODE_STAGE_DIR := $(ZCODETMP)/stage
ZCODE_APP_DIR := $(ZCODETMP)/Build/Products/Release/ZCODE.app

.PHONY: package dvt-include

dvt-include:
	@if [ -n "$(xcode_path)" ]; then \
		echo "Path to SharedFrameworks: $(shared_frameworks_path)"; \
		ln -s "$(shared_frameworks_path)" DVT-Include; \
		echo "Symbolic link 'DVT-Include' created in the current directory."; \
	else \
		echo "Xcode not found."; \
	fi
package: dvt-include
	# Build
	@set -o pipefail; \
		xcodebuild -jobs $(shell sysctl -n hw.ncpu) -project 'Zcode.xcodeproj' -scheme Zcode -configuration Release -sdk macosx -derivedDataPath $(ZCODETMP) \
		DSTROOT=$(ZCODETMP)/install ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES=NO \
		SYSTEM_FRAMEWORK_SEARCH_PATHS=$(shared_frameworks_path) RUNPATH_SEARCH_PATHS=$(shared_frameworks_path)
	
	@rm -rf $(ZCODE_STAGE_DIR)/
	@mkdir -p $(ZCODE_STAGE_DIR)/Payload
	@mv $(ZCODE_APP_DIR) $(ZCODE_STAGE_DIR)/Payload/ZCODE.app

	# Package
	@echo $(ZCODETMP)
	@rm -rf packages

	# Move new app bundle to package directory
	@mkdir packages
	@mv $(ZCODE_STAGE_DIR)/Payload/ZCODE.app packages/ZCODE.app
	@rm -rf $(ZCODETMP)
	@rm -rf Payload
	@codesign -f -s - packages/ZCODE.app --preserve-metadata=entitlements
