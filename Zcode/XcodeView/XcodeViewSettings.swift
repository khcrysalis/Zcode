//
//  XcodeViewSettings.swift
//  Zcode
//
//  Created by samara on 1/23/24.
//

import Foundation

let TYPE_OVER_COMPLETIONS = false
let AUTO_INDENT = false
let AUTO_CLOSE_BRACE = false
let AUTO_OPEN_BRACKET = false
let USE_TABS = true
let WRAP = true
let WRAP_INDENT = 0
let WRAP_ON_WORDS = false
let SHOW_LINE_NUMBERS = true

func LANGUAGE_FALLBACKS() -> [String: String] {
    var result = [String: String]()

    // ActionScript
    result["as"] = "Xcode.SourceCodeLanguage.JavaScript"

    return result
}
