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
                Text("Version 0.1 (4)")
                    .font(.system(.caption))
                
                Spacer().frame(height: 10)
                
                Text("Credits")
                    .font(.custom("Acme", size: 15))
                    .foregroundColor(Color("Newspaper"))
                Text("Source Code on GitHub")
                    .font(.system(.caption))
                Text("Typeface: Acme by Huerta Tipográfica")
                    .font(.system(.caption))
                
                Spacer().frame(height: 10)
                
                Text("Copyright © 2020 Toto Minai")
                    .font(.custom("Acme", size: 12))
                    .foregroundColor(Color("Newspaper"))
            }.frame(height: 300)
            
            
            
            Rectangle()
                .foregroundColor(.clear)
                .background(LinearGradient(gradient: Gradient(colors: [Color(hex: 0xFF2B5F, alpha: 0), Color(hex: 0xFF2B5F, alpha: 0.6)]), startPoint: .top, endPoint: .bottom))
                .frame(height: 20)
        }
        .background(Color("Vintage"))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    init() {
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 300, height: 320),
            styleMask: [.closable, .fullSizeContentView, .titled],
            backing: .buffered, defer: false)
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
