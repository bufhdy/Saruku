//
//  PrefsView.swift
//  Saruku
//
//  Created by 御薬袋托托 on 2020/3/8.
//  Copyright © 2020 Minai Toto. All rights reserved.
//

import Cocoa
import SwiftUI

struct PrefsView: View {
    var window: NSWindow!
    
    var body: some View {
        Text("Hello, Prefs!")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    init() {
        // Create the window
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 300, height: 100),
            styleMask: [.titled, .closable, .miniaturizable, .utilityWindow, .fullSizeContentView],
            backing: .buffered,
            defer: false)
        window.center()
        window.contentView = NSHostingView(rootView: self)
        window.setFrameAutosaveName("Main Window")
        window.makeKeyAndOrderFront(nil)
        self.window = window
    }
}

//
//struct PrefsView_Previews: PreviewProvider {
//    static var previews: some View {
//        PrefsView()
//    }
//}
