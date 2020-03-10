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
    @State var windowDelegate = WindowsDelegate()
    
    let version: String
    let build: String
    
    private func openURL(url: String) {
        if let url = URL(string: url) {
            NSWorkspace.shared.open(url)
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                Image("SarukuIcon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 120)
                
                Text("Saruku")
                    .font(.custom("Acme", size: 18))
                    .foregroundColor(Color("Newspaper"))
                Text("Version \(self.version) (\(self.build))")
                    .font(.system(size: 12, weight: .regular, design: .rounded))
                
                Spacer().frame(height: 12)
                
                Text("Credits")
                    .font(.custom("Acme", size: 15))
                    .foregroundColor(Color("Newspaper"))
                ZStack(alignment: .leading) {
                    VStack(spacing: 0) {
                        Color.black.opacity(0.0001)
                            .frame(width: 73, height: 11)
                        
                        Rectangle()
                            .foregroundColor(Color("Sorrow").opacity(0.5))
                            .frame(width: 73, height: 5)
                    }
                    .onTapGesture {
                        self.openURL(url: "https://github.com/bufhdy/Saruku")
                    }
                    
                    HStack(spacing: 0) {
                        Text("Source code")
                            .font(.system(size: 12, weight: .bold, design: .rounded))
                        Text(" on GitHub")
                            .font(.system(size: 12, weight: .regular, design: .rounded))
                    }
                    
                    VStack(spacing: 0) {
                        Color.black.opacity(0.0001)
                            .frame(width: 71.5, height: 16)
                    }
                    .onTapGesture {
                        self.openURL(url: "https://github.com/bufhdy/Saruku")
                    }
                }
                .frame(height: 16)
                
                Spacer().frame(height: 2)
                
                ZStack(alignment: .leading) {
                    VStack(spacing: 0) {
                        Color.black.opacity(0.0001)
                            .frame(width: 32, height: 11)
                        
                        Rectangle()
                            .foregroundColor(Color("Sorrow").opacity(0.5))
                            .frame(width: 32, height: 5)
                    }
                    .offset(x: 57.5)
                    
                    VStack(spacing: 0) {
                        Color.black.opacity(0.0001)
                            .frame(width: 110.5, height: 11)
                        
                        Rectangle()
                            .foregroundColor(Color("Sorrow").opacity(0.5))
                            .frame(width: 110.5, height: 5)
                    }
                    .offset(x: 111)
                    
                    HStack(spacing: 0) {
                        Text("Typeface: ")
                            .font(.system(size: 12, weight: .regular, design: .rounded))
                        Text("Acme")
                            .font(.system(size: 12, weight: .bold, design: .rounded))
                        Text(" by ")
                            .font(.system(size: 12, weight: .regular, design: .rounded))
                        Text("Huerta Tipográfica")
                            .font(.system(size: 12, weight: .bold, design: .rounded))
                    }
                    
                    VStack(spacing: 0) {
                        Color.black.opacity(0.0001)
                            .frame(width: 32, height: 16)
                    }
                    .offset(x: 57.5)
                    .onTapGesture {
                        self.openURL(url: "https://fonts.google.com/specimen/Acme")
                    }
                    
                    VStack(spacing: 0) {
                        Color.black.opacity(0.0001)
                            .frame(width: 110.5, height: 16)
                    }
                    .offset(x: 111)
                    .onTapGesture {
                        self.openURL(url: "https://www.huertatipografica.com/en")
                    }
                }
                    
                Spacer().frame(height: 12)
                
                ZStack(alignment: .leading) {
                    VStack(spacing: 0) {
                        Color.black.opacity(0.0001)
                            .frame(width: 50, height: 11)
                        
                        Rectangle()
                            .foregroundColor(Color("Toto"))
                            .frame(width: 50, height: 5)
                    }
                    .offset(x: 89)
                    
                    Text("Copyright © 2020 Toto Minai")
                        .font(.custom("Acme", size: 12))
                        .foregroundColor(Color("Newspaper"))
                    
                    VStack(spacing: 0) {
                        Color.black.opacity(0.0001)
                            .frame(width: 50, height: 16)
                    }
                    .offset(x: 89)
                    .onTapGesture {
                        self.openURL(url: "https://twitter.com/bufhdy")
                    }
                }
            }.frame(height: 278)
            
            Spacer().frame(height: 12)
            
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
            contentRect: NSRect(x: 0, y: 0, width: 320, height: 320),
            styleMask: [.closable, .fullSizeContentView, .titled],
            backing: .buffered, defer: false)
        window.titlebarAppearsTransparent = true
        window.isMovableByWindowBackground = true
        window.backgroundColor = NSColor(named: "Vintage")
        window.standardWindowButton(.miniaturizeButton)?.isHidden = true
        window.standardWindowButton(.zoomButton)?.isHidden = true
        window.center()
        window.contentView = NSHostingView(rootView: self)
        window.delegate = windowDelegate
        windowDelegate.windowIsOpen = true
        window.makeKeyAndOrderFront(nil)
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
