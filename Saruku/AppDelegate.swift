//
//  AppDelegate.swift
//  Saruku
//
//  Created by 御薬袋托托 on 2020/3/5.
//  Copyright © 2020 Minai Toto. All rights reserved.
//

import Cocoa
import SwiftUI
import HotKey
import Carbon

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSMenuDelegate {
    var popover: NSPopover!
    var statusBarItem: NSStatusItem!
    var statusBarMenu: NSMenu!
    var prefsView: PrefsView?
    var aboutView: AboutView?
    
    var prefsWindowIsOpen = false
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Create the popover
        let popover = NSPopover()
        popover.contentSize = NSSize(width: 60, height: 60)
        popover.behavior = .transient
        popover.animates = false
        popover.contentViewController = NSHostingController(rootView: ContentView()) // SwiftUI view
        self.popover = popover
        
        // Create the status bar
        statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusBarItem.button?.image = NSImage(named: "StatusIcon")
        statusBarItem.button?.action = #selector(statusBarButtonClicked(_:))
        statusBarItem.button?.sendAction(on: [.leftMouseUp, .rightMouseUp])
        
        // Create the status bar menu
        statusBarMenu = NSMenu()
        statusBarMenu.delegate = self
        statusBarMenu.addItem(withTitle: "About Saruku",
                              action: #selector(openAboutWindow(_:)),
                              keyEquivalent: "")
        statusBarMenu.addItem(NSMenuItem.separator())
        statusBarMenu.addItem(withTitle: "Preferences...",
                              action: #selector(openPrefsWindow(_:)),
                              keyEquivalent: ",")
        statusBarMenu.addItem(NSMenuItem.separator())
        statusBarMenu.addItem(withTitle: "Quit",
                              action: #selector(quitApp(_:)),
                              keyEquivalent: "q")
        
//        if Storage.fileExists("globalKeybind.json", in: .documents) {
//            let globalKeybinds = Storage.retrieve("globalKeybind.json", from: .documents, as: GlobalKeybindPreferences.self)
//            hotKey = HotKey(keyCombo: KeyCombo(carbonKeyCode: globalKeybinds.keyCode, carbonModifiers: globalKeybinds.carbonFlags))
//        }
    }
    
//    public var hotKey: HotKey? {
//        didSet {
//            guard let hotKey = hotKey else { return }
//            
//            hotKey.keyDownHandler = { [weak self] in
//                NSApplication.shared.orderedWindows.forEach { (window) in
//                    if let mainWindow = window as? MainWindow {
//                        print("woo")
//                        NSApplication.shared.activate(ignoringOtherApps: true)
//                        // to be conti
//                    }
//                }
//            }
//        }
//        
//    
//    }
    
    @objc func statusBarButtonClicked(_ sender: NSStatusBarButton) {
        let event = NSApp.currentEvent!
        if event.type == NSEvent.EventType.rightMouseUp {
            statusBarItem.menu = statusBarMenu
            statusBarItem.button?.performClick(nil)
        } else {
            if let button = self.statusBarItem.button {
                if self.popover.isShown { self.popover.performClose(sender) }
                else {
                    self.popover.show(relativeTo: button.bounds,
                                      of: button,
                                      preferredEdge: NSRectEdge.minY)
                }
            }
            
            self.popover.contentViewController?.view.window?.becomeKey()
        }
    }
    
    // Reset status bar
    @objc func menuDidClose(_ menu: NSMenu) {
        statusBarItem.menu = nil
    }
    
    // Menu actions
    @objc func openPrefsWindow(_ sender: Any) {
        if let prefsView = prefsView, prefsView.prefsWindowDelegate.windowIsOpen {
            prefsView.window.makeKeyAndOrderFront(self)
        } else {
            prefsView = PrefsView()
        }
    }
    
    @objc func openAboutWindow(_ sender: Any) {
        if let aboutView = aboutView, aboutView.aboutWindowDelegate.windowIsOpen {
            aboutView.window.makeKeyAndOrderFront(self)
        } else {
            aboutView = AboutView()
        }
    }

    @objc func quitApp(_ sender: Any) {
        NSApp.terminate(self)
    }
}

class WindowsDelegate: NSObject, NSWindowDelegate {
    var windowIsOpen = false
    
    func windowWillClose(_ notification: Notification) {
        windowIsOpen = false
    }
}
