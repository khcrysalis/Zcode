//
//  ZcodeApp.swift
//  Zcode
//
//  Created by samara on 1/23/24.
//

import DVTBridge


class AppDelegate: NSObject, NSApplicationDelegate {
    var contentView: WindowController!
    var document: Document!
    var info = Bundle.main.infoDictionary!

    func applicationDidFinishLaunching(_ aNotification: Notification) {

        setupMenuBar()

        NSApp.activate(ignoringOtherApps: true)

        NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
            if event.modifierFlags.contains(.command) {
                if "123456789".contains(event.characters!) {
                    let tabWindows = NSApp.keyWindow?.tabbedWindows ?? []
                    let tabIndex = Int(event.characters ?? "") ?? 0
                    if tabIndex == 8 || tabIndex >= tabWindows.count {
                        tabWindows.last?.makeKey()
                    } else {
                        tabWindows[tabIndex - 1].makeKey()
                    }
                    return nil
                }
            }
            return event
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {}

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}



extension AppDelegate {
    @objc func quit() { NSApplication.shared.terminate(self)}
    @objc func orderFrontStandardAboutPanel() { NSApplication.shared.orderFrontStandardAboutPanel(nil) }

    @objc func undo() { contentView.xcodeView.undo() }
    @objc func redo() { contentView.xcodeView.redo() }
    @objc func save() { NSApp.sendAction(#selector(NSDocument.save(_:)), to: nil, from: nil) }
}

extension AppDelegate {
    private func setupMenuBar() {
        let menu = NSMenu()
        
        // Zcode
        let Zcode = NSMenu()
        Zcode.addItem(withTitle: "About Zcode", action: #selector(orderFrontStandardAboutPanel), keyEquivalent: "")
        Zcode.addItem(NSMenuItem.separator())
        Zcode.addItem(withTitle: "Quit", action: #selector(AppDelegate.quit), keyEquivalent: "q")
        
        let ZcodeItem = NSMenuItem()
        ZcodeItem.submenu = Zcode
        menu.addItem(ZcodeItem)
        
        // File
        let fileMenu = NSMenu()
        fileMenu.addItem(withTitle: "New", action: #selector(contentView.document?.newDocument(_:)), keyEquivalent: "n")
        fileMenu.addItem(withTitle: "Open", action: #selector(contentView.document?.openDocument(_:)), keyEquivalent: "o")
        fileMenu.addItem(NSMenuItem.separator())
        fileMenu.addItem(withTitle: "Close", action: #selector(contentView.document?.close(_:)), keyEquivalent: "w")
        fileMenu.addItem(withTitle: "Save", action: #selector(AppDelegate.save), keyEquivalent: "s")

        let fileMenuItem = NSMenuItem()
        fileMenuItem.title = "File"
        fileMenuItem.submenu = fileMenu
        menu.addItem(fileMenuItem)
        
        // Edit
        let editMenu = NSMenu()
        editMenu.addItem(withTitle: "Undo", action: #selector(AppDelegate.undo), keyEquivalent: "z")
        editMenu.addItem(withTitle: "Redo", action: #selector(AppDelegate.redo), keyEquivalent: "Z")

        editMenu.addItem(NSMenuItem.separator())
        editMenu.addItem(withTitle: "Cut", action: #selector(NSText.cut(_:)), keyEquivalent: "x")
        editMenu.addItem(withTitle: "Copy", action: #selector(NSText.copy(_:)), keyEquivalent: "c")
        editMenu.addItem(withTitle: "Paste", action: #selector(NSText.paste(_:)), keyEquivalent: "v")
        editMenu.addItem(withTitle: "Select All", action: #selector(NSText.selectAll(_:)), keyEquivalent: "a")
        
        let editMenuItem = NSMenuItem()
        editMenuItem.title = "Edit"
        editMenuItem.submenu = editMenu
        menu.addItem(editMenuItem)
        
        // View
        let viewMenu = NSMenu()
        
        let viewMenuItem = NSMenuItem()
        viewMenuItem.title = "View"
        viewMenuItem.submenu = viewMenu
        menu.addItem(viewMenuItem)
        
        
        
        
        
        NSApplication.shared.mainMenu = menu
    }
}

