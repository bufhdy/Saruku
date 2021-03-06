//
//  AppDelegate.swift
//  Saruku
//
//  Created by 御薬袋托托 on 2020/3/5.
//  Copyright © 2020 Minai Toto. All rights reserved.
//

import Cocoa
import SwiftUI
import UserNotifications

let defaults = UserDefaults.standard
let langs = [Bundle.main.preferredLocalizations.first!, "en", "zh-Hant", "ja"]
let langIndex = [
    "en": 1,
    "zh-Hant": 2,
    "ja": 3
]

func getLang() -> String {
    return defaults.integer(forKey: "defaultLang") == 0 ?
        Bundle.main.preferredLocalizations.first! :
        langs[defaults.integer(forKey: "defaultLang")]
}

struct SchemeColoured: ViewModifier {
    func body(content: Content) -> some View {
        if defaults.integer(forKey: "defaultTheme") == 0 {
            return AnyView(content)
        } else {
            return AnyView(content
                .colorScheme(defaults.integer(forKey: "defaultTheme") == 1 ? .light : .dark))
        }
    }
}

extension String {
    func localised() -> String {
        let path = Bundle.main.path(
            forResource: langs[defaults.integer(forKey: "defaultLang")],
            ofType: "lproj")
        let bundle = Bundle(path: path!)
        
        return NSLocalizedString(
            self,
            tableName: nil,
            bundle: bundle!,
            value: "",
            comment: "")
    }
}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSMenuDelegate, UNUserNotificationCenterDelegate {
    var popover: NSPopover!
    var statusBarItem: NSStatusItem!
    var statusBarMenu: NSMenu!
    var prefsView: PrefsView?
    var aboutView: AboutView?
    var cookbookView: CookbookView?
    var cookbookWindow: NSWindow!
    
    var prefsWindowIsOpen = false
    
    let defaultTheme = defaults.integer(forKey: "defaultTheme")
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Empty defaults
//        let domain = Bundle.main.bundleIdentifier!
//        defaults.removePersistentDomain(forName: domain)
//        defaults.synchronize()
//        exit(0)
        
        // Create the status bar
        statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusBarItem.button?.image = NSImage(named: "StatusIcon")
        statusBarItem.button?.action = #selector(statusBarButtonClicked(_:))
        statusBarItem.button?.sendAction(on: [.leftMouseUp, .rightMouseUp])
        
        // Create the status bar menu
        statusBarMenu = NSMenu()
        statusBarMenu.delegate = self
        statusBarMenu.addItem(withTitle: "aboutItem".localised(),
                              action: #selector(openAboutWindow(_:)),
                              keyEquivalent: "")
        statusBarMenu.addItem(NSMenuItem.separator())
        statusBarMenu.addItem(withTitle: "prefsItem".localised(),
                              action: #selector(openPrefsWindow(_:)),
                              keyEquivalent: ",")
        statusBarMenu.addItem(withTitle: "cookbookItem".localised(),
                              action: #selector(openHelpWindow(_:)),
                              keyEquivalent: "")
        statusBarMenu.addItem(NSMenuItem.separator())
        statusBarMenu.addItem(withTitle: "quitItem".localised(),
                              action: #selector(quitApp(_:)),
                              keyEquivalent: "q")
        
        // Create the popover
        popover = NSPopover()
        popover.contentSize = NSSize(width: 60, height: 60)
        popover.behavior = .transient
        popover.animates = true
        // SwiftUI view with colour scheme set
        popover.contentViewController = NSHostingController(rootView: ContentView().modifier(SchemeColoured()))
        
        // Open cookbook at first launch
        let showsCookbookAtLaunch = defaults.bool(forKey: "showsCookbookAtLaunch")
        let hasLaunched = defaults.bool(forKey: "hasLaunched")
        if showsCookbookAtLaunch || !hasLaunched {
            cookbookView = CookbookView()
        }
        
        if !showsCookbookAtLaunch && hasLaunched {
            self.popover.show(relativeTo: statusBarItem.button!.bounds,
                              of: statusBarItem.button!,
                              preferredEdge: .minY)
        }
    }
    
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
                                      preferredEdge: .minY)
                }
            }
        }
    }
    
    // Reset status bar
    @objc func menuDidClose(_ menu: NSMenu) {
        statusBarItem.menu = nil
    }
    
    // TODO: Integrate the 3 funcs
    @objc func openPrefsWindow(_ sender: Any) {
        NSApp.activate(ignoringOtherApps: true)
        if let view = prefsView, view.windowDelegate.isOpen {
            view.window.makeKeyAndOrderFront(self)
        } else {
            prefsView = PrefsView()
        }
    }
    
    @objc func openAboutWindow(_ sender: Any) {
        NSApp.activate(ignoringOtherApps: true)
        if let view = aboutView, view.windowDelegate.isOpen {
            view.window.makeKeyAndOrderFront(self)
        } else {
            aboutView = AboutView()
        }
    }
    
    @objc func openHelpWindow(_ sender: Any) {
        NSApp.activate(ignoringOtherApps: true)
        if let view = cookbookView, view.windowDelegate.isOpen {
            view.window.makeKeyAndOrderFront(self)
        } else {
            cookbookView = CookbookView()
        }
    }

    @objc func quitApp(_ sender: Any) {
        NSApp.terminate(self)
    }
    
    func notificationAction(named name: String) {
        let content = UNMutableNotificationContent()
        content.title = "Saruku"
        content.body = "\(name) is ready to go."
        content.userInfo = ["method": "new"]
        
        content.sound = UNNotificationSound.default
        content.categoryIdentifier = "NOTIFICATION"
        
        let showAction = UNNotificationAction(identifier: "SHOW_ACTION", title: "Show", options: .init(rawValue: 0))
        let dismissAction = UNNotificationAction(identifier: "DISMISS_ACTION", title: "Dismiss", options: .init(rawValue: 0))
        let testCaregory = UNNotificationCategory(identifier: "NOTIFICATION",
                                                  actions: [showAction, dismissAction],
                                                  intentIdentifiers: [],
                                                  options: .customDismissAction)
        
        let request = UNNotificationRequest(identifier: "NOTIFICATION_REQUEST", content: content, trigger: nil)
        
        let notificationCentre = UNUserNotificationCenter.current()
        notificationCentre.delegate = self
        notificationCentre.setNotificationCategories([testCaregory])
        notificationCentre.add(request)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        switch response.actionIdentifier {
        case "SHOW_ACTION":
            self.popover.show(relativeTo: self.statusBarItem.button!.bounds, of: self.statusBarItem.button!, preferredEdge: .minY)
        case "DISMISS_ACTION":
            break
        default:
            break
        }
        
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    
    func reloadTheme() {
        self.popover.contentViewController = NSHostingController(rootView:
            ContentView().colorScheme(self.defaultTheme == 0 ? .light : .dark))
    }
}

class WindowsDelegate: NSObject, NSWindowDelegate {
    var isOpen = false
    
    func windowWillClose(_ notification: Notification) {
        isOpen = false
    }
}
