STRIP := $(shell command -v strip)
ZCODETMP := $(TMPDIR)/ZCODE
ZCODE_STAGE_DIR := $(ZCODETMP)/stage
ZCODE_APP_DIR := $(ZCODETMP)/Build/Products/Release/ZCODE.app

.PHONY: package

package:
	# Build
	@set -o pipefail; \
		xcodebuild -jobs $(shell sysctl -n hw.ncpu) -project 'Zcode.xcodeproj' -scheme Zcode -configuration Release -sdk macosx -derivedDataPath $(ZCODETMP) \
		DSTROOT=$(ZCODETMP)/install ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES=NO
	
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
