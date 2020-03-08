//
//  PrefsView.swift
//  Saruku
//
//  Created by 御薬袋托托 on 2020/3/8.
//  Copyright © 2020 Minai Toto. All rights reserved.
//

import SwiftUI

struct PrefsView: View {
    var window: NSWindow!
    @State var prefsWindowDelegate = WindowsDelegate()
    
    var body: some View {
        Text("Hello, Prefs!")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("Vintage"))
    }
    
    init() {
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 400, height: 300),
            styleMask: [.borderless, .closable, .fullSizeContentView, .titled],
            backing: .buffered, defer: false)
        window.title = "Preferences"
        window.center()
        window.contentView = NSHostingView(rootView: self)
        window.delegate = prefsWindowDelegate
        prefsWindowDelegate.windowIsOpen = true
        window.makeKeyAndOrderFront(nil)
    }
}

//
//struct PrefsView_Previews: PreviewProvider {
//    static var previews: some View {
//        PrefsView()
//    }
//}

