//
//  XcodeView.swift
//  Zcode
//
//  Created by samara on 1/23/24.
//

import Foundation
import DVTBridge

private var frameworkInitPredicate: Int = 0

class XcodeView: DVTSourceTextScrollView {
    private static var isFrameworkInitialized = false
    
    var codeStorage: DVTTextStorage!
    var codeView: DVTSourceTextView!
    var hasBeenSaved = false

    private static func initializeFrameworkOnce() {
        guard !isFrameworkInitialized else { return }

        DVTPlugInManager.default().scan(forPlugIns: nil)
        DVTSourceSpecification.searchForAndRegisterAllAvailableSpecifications()
        DVTTheme.initialize()

        DVTTextPreferences.shared().enableTypeOverCompletions = TYPE_OVER_COMPLETIONS
        DVTTextPreferences.shared().useSyntaxAwareIndenting = AUTO_INDENT
        DVTTextPreferences.shared().autoInsertClosingBrace = AUTO_CLOSE_BRACE
        DVTTextPreferences.shared().autoInsertOpenBracket = AUTO_OPEN_BRACKET

        isFrameworkInitialized = true
    }

    override init(frame rect: NSRect) {
        super.init(frame: rect)

        XcodeView.initializeFrameworkOnce()

        hasBeenSaved = false
        loadURL(nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func loadURL(_ codeURL: URL?) {
        var codeString = ""
        do {
            if let codeURL = codeURL {
                codeString = try String(contentsOf: codeURL, encoding: .utf8)
                hasBeenSaved = true
            }

            codeStorage = DVTTextStorage(string: codeString)

            if let codeURL = codeURL {
                let codeFile = DVTFilePath(forFileURL: codeURL)

                do {
                    let codeType = try DVTFileDataType(for: codeFile, error: nil)
                    if let language = DVTSourceCodeLanguage.sourceCodeLanguages()?.first(where: {
                        let language = $0 as AnyObject
                        if class_getProperty(object_getClass(language), "fileDataType") != nil {
                            return (language.value(forKey: "fileDataType") as? DVTFileDataType) == codeType
                        }
                        return false
                    }) as? DVTSourceCodeLanguage {
                        codeStorage.language = language
                    } else if let identifier = LANGUAGE_FALLBACKS()[codeURL.pathExtension] {
                        let language = DVTSourceCodeLanguage(identifier: identifier)
                        codeStorage.language = language
                    }
                } catch {
                    // Handle the error when determining codeType
                    print("Error determining codeType: \(error)")
                }
            }

            codeStorage.usesTabs = USE_TABS
            codeStorage.wrappedLineIndentWidth = Int32(WRAP_INDENT)

            codeView = DVTSourceTextView()
            codeView.layoutManager?.replaceTextStorage(codeStorage)
            codeView.isHorizontallyResizable = true
            codeView.wrapsLines = WRAP
            codeView.allowsUndo = true
            codeView.maxSize = NSMakeSize(CGFloat.greatestFiniteMagnitude, CGFloat.greatestFiniteMagnitude)
            codeView.usesFindBar = true

            if !WRAP_ON_WORDS {
                codeView.layoutManager?.typesetter = XcodeWrapAnywhereTypesetter()
            }

            documentView = codeView
            hasVerticalScroller = true
            hasHorizontalScroller = true

            if SHOW_LINE_NUMBERS {
                let sidebarView = DVTTextSidebarView(scrollView: self, orientation: .verticalRuler)
                sidebarView.drawsLineNumbers = true
                //sidebarView.alphaValue = 0.3
                //scrollerStyle = .overlay
                verticalRulerView = sidebarView
                hasVerticalRuler = true
                rulersVisible = true
            }
        } catch {
            // Handle the error when reading the file
            print("Error loading file: \(error)")
        }
    }


    func saveURL(_ codeURL: URL) {
        codeView.breakUndoCoalescing()

        do {
            try codeStorage.string.write(to: codeURL, atomically: false, encoding: .utf8)

            if !hasBeenSaved {
                loadURL(codeURL)
            }

            hasBeenSaved = true
        } catch {
            print("Error saving file: \(error)")
        }
    }


    deinit { print("XcodeView: deinnit") }
}
