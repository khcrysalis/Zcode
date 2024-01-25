//
//  WindowController.swift
//  Zcode
//
//  Created by samara on 1/24/24.
//

import Foundation
import Cocoa

class WindowController: NSWindowController {
    var xcodeView: XcodeView!

    override init(window: NSWindow?) {
        super.init(window: window)
        
        windowFrameAutosaveName = "window"
        
        let minWidth: CGFloat = 500
        let windowRect = NSRect(x: 0, y: 0, width: minWidth, height: minWidth)
        let windowStyle: NSWindow.StyleMask = [.titled, .closable, .miniaturizable, .resizable]
        let window = NSWindow(contentRect: windowRect, styleMask: windowStyle, backing: .buffered, defer: false)
        window.minSize = NSSize(width: minWidth, height: minWidth)
        window.tabbingMode = .preferred
        self.window = window
        
        xcodeView = XcodeView(frame: window.frame)
        self.contentViewController = NSViewController()
        self.contentViewController?.view = xcodeView
        window.contentView = xcodeView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        self.contentViewController = nil
    }
}
