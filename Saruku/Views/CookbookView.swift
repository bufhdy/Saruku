//
//  CookbookView.swift
//  Saruku
//
//  Created by 御薬袋托托 on 2020/3/10.
//  Copyright © 2020 Minai Toto. All rights reserved.
//

import SwiftUI



struct CookbookView: View {
    var window: NSWindow!
    @State var windowDelegate = WindowsDelegate()
    @State var page = 1
    
    struct Page1: View {
        @Binding var page: Int
        
        var body: some View {
            VStack {
                HStack(spacing: -42) {
                    Image("tap-blue-to-modify")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 132)
                    
                    Image("tap-red-to-delete")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 132)
                }
                
                Text("Tap blue to modify.\nTap red to delete.")
                    .font(.custom("Acme", size: 18))
                    .foregroundColor(Color("Newspaper"))
                    .multilineTextAlignment(.center)
                
                Button(action: { self.page += 1 }) { Text("Next").frame(width: 54) }
                    .offset(x: self.page == 1 ? 0 : 39.5)
            }
        }
    }
    
    struct Page2: View {
        @Binding var page: Int
        
        var body: some View {
            VStack {
                HStack(spacing: -42) {
                    Image("slide-blue-to-adjust")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 132)
                    
                    Image("slide-blue-to-set")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 132)
                }
                
                HStack(spacing: 25) {
                    Text("Slide right blue to adjust,\nleft blue to set.")
                        .font(.custom("Acme", size: 18))
                        .foregroundColor(Color("Newspaper"))
                        .multilineTextAlignment(.trailing)
                    Text("Tap left blue to confirm.\nTap red to return.")
                        .font(.custom("Acme", size: 18))
                        .foregroundColor(Color("Newspaper"))
                        .multilineTextAlignment(.leading)
                }
                
                HStack(spacing: 25) {
                    Button(action: { self.page -= 1 }) { Text("Previous").frame(width: 54) }
                    Button(action: { self.page += 1 }) { Text("Next").frame(width: 54) }
                }
            }
        }
    }
        
    struct Page3: View {
        @Binding var page: Int
        
        var body: some View {
            VStack {
                HStack(spacing: -42) {
                    Image("tap-icon-to-run")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 132)
                    
                    Image("tap-red-to-cancel")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 132)
                }
                
                Text("Tap icon to set sail.\nTap red to cancel.")
                    .font(.custom("Acme", size: 18))
                    .foregroundColor(Color("Newspaper"))
                    .multilineTextAlignment(.center)
                
                HStack(spacing: 25) {
                    Button(action: { self.page -= 1 }) { Text("Previous").frame(width: 54) }
                    Button(action: { self.page += 1 }) { Text("Next").frame(width: 54) }
                }
            }
        }
    }
    
    struct Page4: View {
        @Binding var page: Int
        
        var body: some View {
            VStack {
                HStack(alignment: .top, spacing: -42) {
                    Image("drag-down-to-add")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 132, alignment: .top)
                    
                    Image("drag-up-to-delete")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 132)
                }
                .frame(height: 280)
                .offset(y: 7)
                
                Text("Drag down to add.\nDrag up to delete.")
                    .font(.custom("Acme", size: 18))
                    .foregroundColor(Color("Newspaper"))
                    .multilineTextAlignment(.center)
                
                
                HStack(spacing: 25) {
                    Button(action: { self.page -= 1 }) { Text("Previous").frame(width: 54) }
                    Button(action: {
                        defaults.set(true, forKey: "hasLaunched")
                        NSApplication.shared.keyWindow?.close()
                        let appDelegate = NSApp.delegate as? AppDelegate
                        appDelegate?.popover.show(
                            relativeTo: (appDelegate?.statusBarItem.button!.bounds)!,
                            of: (appDelegate?.statusBarItem.button!)!,
                            preferredEdge: NSRectEdge.minY)
                    }) { Text("Got It").frame(width: 54) }
                }
            }
        }
    }
    
    let roman = [
        1: "i",
        2: "ii",
        3: "iii",
        4: "vii"  // Page seven
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Page1(page: self.$page)
                    .opacity(page == 1 ? 1 : 0)
                
                Page2(page: self.$page)
                    .opacity(page == 2 ? 1 : 0)
                
                Page3(page: self.$page)
                    .opacity(page == 3 ? 1 : 0)
                
                Page4(page: self.$page)
                    .opacity(page == 4 ? 1 : 0)
            }
            .animation(.easeInOut)
            
            Spacer()
            
            Text("Page \(roman[self.page]!)")
                .font(.custom("Acme", size: 12))
                .foregroundColor(Color("Newspaper").opacity(0.6))
            
            Spacer()
            
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
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 420, height: 460),
            styleMask: [.closable, .fullSizeContentView, .titled],
            backing: .buffered, defer: false)
        window.titlebarAppearsTransparent = true
        window.isMovableByWindowBackground = true
        window.backgroundColor = NSColor(named: NSColor.Name("Vintage"))  // TODO: Need to set by colour scheme
        window.title = "Cookbook"
        window.standardWindowButton(.miniaturizeButton)?.isHidden = true
        window.standardWindowButton(.zoomButton)?.isHidden = true
        window.center()
        window.contentView = NSHostingView(rootView: self)
        window.delegate = windowDelegate
        windowDelegate.isOpen = true
        window.makeKeyAndOrderFront(nil)
    }
}

struct HelpView_Previews: PreviewProvider {
    static var previews: some View {
        CookbookView()
    }
}
