//
//  Document.swift
//  Zcode
//
//  Created by samara on 1/24/24.
//

import Foundation
import Cocoa

class Document: NSDocument {
    var windowController: WindowController?
    var cachedURL: URL?

    override func makeWindowControllers() {
        let controller = WindowController()
        windowController = controller
        
        if let cachedURL = cachedURL {
            if let xcodeView = windowController?.contentViewController?.view as? XcodeView {
                xcodeView.loadURL(cachedURL)
            }
        }
        
        addWindowController(windowController!)
    }

    override func read(from fileURL: URL, ofType typeName: String) throws {
        cachedURL = fileURL
    }

    override func write(to fileURL: URL, ofType typeName: String) throws {
        if let xcodeView = windowController?.contentViewController?.view as? XcodeView {
            xcodeView.saveURL(fileURL)
        }
    }

    deinit {
        windowController = nil
        cachedURL = nil
    }
}
