//
//  XcodeWrapAnywhereTypesetter.swift
//  Zcode
//
//  Created by samara on 1/23/24.
//

import Foundation
import DVTBridge

class XcodeWrapAnywhereTypesetter: DVTAnnotatingTypesetter {

    override func shouldBreakLine(byWordBeforeCharacterAt charIndex: Int) -> Bool {
        return false
    }
}
