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
    
    @State var isHover: Bool = false {
        willSet(newValue) {
            if self.isHover != newValue {
                if newValue {
                    NSCursor.pointingHand.push()
                } else {
                    NSCursor.pointingHand.pop()
                }
            }
        }
    }
    
    // Need to integrate
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                Image("SarukuIcon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 120, height: 140)
                
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
                    .onHover { value in
                        self.isHover = value
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
                        self.isHover = false
                    }
                    .onHover { value in
                        self.isHover = value
                    }
                }
                .frame(height: 16)
                
                Spacer().frame(height: 1)
                
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
                    .onHover { value in
                       self.isHover = value
                    }
                    .offset(x: 57.5)
                    .onTapGesture {
                        self.openURL(url: "https://fonts.google.com/specimen/Acme")
                        self.isHover = false
                    }
                    
                    
                    VStack(spacing: 0) {
                        Color.black.opacity(0.0001)
                            .frame(width: 110.5, height: 16)
                    }
                    .onHover { value in
                        self.isHover = value
                    }
                    .offset(x: 111)
                    .onTapGesture {
                        self.openURL(url: "https://www.huertatipografica.com/en")
                        self.isHover = false
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
                    .onTapGesture {
                        self.openURL(url: "https://twitter.com/bufhdy")
                        self.isHover = false
                        
                        print(self.isHover)
                    }
                    .onHover { value in
                        self.isHover = value
                    }
                    .offset(x: 89)
                    
                }
            }.frame(height: 278)
            
            Spacer().frame(height: 12)
            
            Rectangle()
                .foregroundColor(.clear)
                .background(LinearGradient(
                    gradient: Gradient(colors: [Color("Cherry").opacity(0), Color("Cherry").opacity(0.6)]),
                    startPoint: .top,
                    endPoint: .bottom))
                .frame(height: 22)
        }
        .background(Color("Vintage"))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .modifier(SchemeColoured())
    }
    
    init() {
        self.version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
        self.build = Bundle.main.infoDictionary?["CFBundleVersion"] as! String
        
        var colour: NSColor
        switch defaults.integer(forKey: "defaultTheme") {
        case 1:
            colour = NSColor.fromHex(hex: 0xF9F3DF)
        case 2:
            colour = NSColor.fromHex(hex: 0x4B3111)
        default:
            colour = NSColor(named: NSColor.Name("Vintage"))!
        }
        
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 320, height: 320),
            styleMask: [.closable, .fullSizeContentView, .titled],
            backing: .buffered, defer: false)
        window.titlebarAppearsTransparent = true
        window.isMovableByWindowBackground = true
        window.backgroundColor = colour
        window.standardWindowButton(.miniaturizeButton)?.isHidden = true
        window.standardWindowButton(.zoomButton)?.isHidden = true
        window.center()
        window.contentView = NSHostingView(rootView: self)
        window.delegate = windowDelegate
        windowDelegate.isOpen = true
        window.makeKeyAndOrderFront(nil)
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
