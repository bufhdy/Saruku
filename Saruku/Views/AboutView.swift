//
//  AboutView.swift
//  Saruku
//
//  Created by 御薬袋托托 on 2020/3/8.
//  Copyright © 2020 Minai Toto. All rights reserved.
//

import SwiftUI

struct AboutView: View {
    var window: NSWindow!
    @State var aboutWindowDelegate = WindowsDelegate()
    
    let version: String
    let build: String
    
    var body: some View {
        VStack(spacing: 0) {
            VStack {
                Image("SarukuIcon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 120)
                
                Text("Saruku")
                    .font(.custom("Acme", size: 18))
                    .foregroundColor(Color("Newspaper"))
                Text("Version \(self.version) (\(self.build))")
                    .font(.system(.caption))
                
                Spacer().frame(height: 10)
                
                Text("Credits")
                    .font(.custom("Acme", size: 15))
                    .foregroundColor(Color("Newspaper"))
                Text("Source code on GitHub")
                    .font(.system(.caption))
                Text("Typeface: Acme by Huerta Tipográfica")
                    .font(.system(.caption))
                
                Spacer().frame(height: 10)
                
                Text("Copyright © 2020 Toto Minai")
                    .font(.custom("Acme", size: 12))
                    .foregroundColor(Color("Newspaper"))
            }.frame(height: 278)
            
            Rectangle()
                .foregroundColor(.clear)
                .background(LinearGradient(gradient: Gradient(colors: [Color("Cherry").opacity(0), Color("Cherry").opacity(0.6)]), startPoint: .top, endPoint: .bottom))
                .frame(height: 22)
        }
        .background(Color("Vintage"))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    init() {
        self.version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
        self.build = Bundle.main.infoDictionary?["CFBundleVersion"] as! String
        
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 300, height: 300),
            styleMask: [.closable, .fullSizeContentView, .titled],
            backing: .buffered, defer: false)
        window.titlebarAppearsTransparent = true
        window.isMovableByWindowBackground = true
        window.backgroundColor = NSColor(named: "Vintage")
        window.standardWindowButton(.miniaturizeButton)?.isHidden = true
        window.standardWindowButton(.zoomButton)?.isHidden = true
        window.center()
        window.contentView = NSHostingView(rootView: self)
        window.delegate = aboutWindowDelegate
        aboutWindowDelegate.windowIsOpen = true
        window.makeKeyAndOrderFront(nil)
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
