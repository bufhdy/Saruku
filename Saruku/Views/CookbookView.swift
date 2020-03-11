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
                
                Text("cookbookPage1Line".localised())
                    .font(.custom("Acme", size: 18))
                    .foregroundColor(Color("Newspaper"))
                    .multilineTextAlignment(.center)
                
                Button(action: { self.page += 1 }) { Text("nextButton".localised()).frame(width: 54) }
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
                    Text("cookbookPage2Line1".localised())
                        .font(.custom("Acme", size: 18))
                        .foregroundColor(Color("Newspaper"))
                        .multilineTextAlignment(.trailing)
                    Text("cookbookPage2Line2".localised())
                        .font(.custom("Acme", size: 18))
                        .foregroundColor(Color("Newspaper"))
                        .multilineTextAlignment(.leading)
                }
                
                HStack(spacing: 25) {
                    Button(action: { self.page -= 1 }) { Text("previousButton".localised()).frame(width: 54) }
                    Button(action: { self.page += 1 }) { Text("nextButton".localised()).frame(width: 54) }
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
                
                Text("cookbookPage3Line".localised())
                    .font(.custom("Acme", size: 18))
                    .foregroundColor(Color("Newspaper"))
                    .multilineTextAlignment(.center)
                
                HStack(spacing: 25) {
                    Button(action: { self.page -= 1 }) { Text("previousButton".localised()).frame(width: 54) }
                    Button(action: { self.page += 1 }) { Text("nextButton".localised()).frame(width: 54) }
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
                
                Text("cookbookPage4Line".localised())
                    .font(.custom("Acme", size: 18))
                    .foregroundColor(Color("Newspaper"))
                    .multilineTextAlignment(.center)
                
                
                HStack(spacing: 25) {
                    Button(action: { self.page -= 1 }) { Text("previousButton".localised()).frame(width: 54) }
                    Button(action: {
                        defaults.set(true, forKey: "hasLaunched")
                        NSApplication.shared.keyWindow?.close()
                        let appDelegate = NSApp.delegate as? AppDelegate
                        appDelegate?.popover.show(
                            relativeTo: (appDelegate?.statusBarItem.button!.bounds)!,
                            of: (appDelegate?.statusBarItem.button!)!,
                            preferredEdge: NSRectEdge.minY)
                    }) { Text("okButton".localised()).frame(width: 54) }
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
            
            Text("Page \(roman[self.page]!)")  // Localisation needed
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
            contentRect: NSRect(x: 0, y: 0, width: 420, height: 460),
            styleMask: [.closable, .fullSizeContentView, .titled],
            backing: .buffered, defer: false)
        window.titlebarAppearsTransparent = true
        window.isMovableByWindowBackground = true
        window.backgroundColor = colour  // TODO: Need to set title colour by scheme
        window.title = "cookbookTitle".localised()
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
