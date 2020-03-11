//
//  PrefsView.swift
//  Saruku
//
//  Created by 御薬袋托托 on 2020/3/8.
//  Copyright © 2020 Minai Toto. All rights reserved.
//

import SwiftUI
import LaunchAtLogin

// A wrapper for SwiftUI default Toggle(), it will do some extra work when toggling
struct LaunchAtLoginToggle {
    var value: Bool = LaunchAtLogin.isEnabled {
        didSet { LaunchAtLogin.isEnabled = value }
    }
}

struct PrefsView: View {
    var window: NSWindow!
    @State var windowDelegate = WindowsDelegate()
    @State var launchAtLoginModel = LaunchAtLoginToggle()
    
    @State var tabIndex: Int = 0
    
    @State var showsCookbookAtLaunch = defaults.bool(forKey: "showsCookbookAtLaunch")
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        let showsCookbookAtLaunchBinding = Binding<Bool>(get: {
            return self.showsCookbookAtLaunch
        }, set: {
            self.showsCookbookAtLaunch = $0
            defaults.set(self.showsCookbookAtLaunch, forKey: "showsCookbookAtLaunch")
        })
        
        return VStack(spacing: 0) {
            TabView(selection: $tabIndex) {
                GeneralView()
                    .tabItem({ Text("generalTab".localised()) })
                    .tag(0)
                CustomView()
                    .tabItem({ Text("cusTab".localised()) })
                    .tag(1)
                Text("ioTab".localised())
                    .tabItem({ Text("ioTab".localised()) })
                    .tag(2)
            }
            .padding([.horizontal, .top])
            
            VStack(alignment: .leading, spacing: 2) {
                Toggle(isOn: $launchAtLoginModel.value) {
                    Text("launchAtLoginInst".localised())
                        .font(.custom("Acme", size: 15))
                        .foregroundColor(Color("Newspaper"))
                }
                
                Toggle(isOn: showsCookbookAtLaunchBinding) {
                    Text("openAtLaunchInst".localised())
                        .font(.custom("Acme", size: 15))
                        .foregroundColor(Color("Newspaper"))
                }
            }
            .padding()
            // TODO: Add restart button?
            
            Rectangle()
                .foregroundColor(.clear)
                .background(LinearGradient(
                    gradient: Gradient(colors: [Color("Cherry").opacity(0), Color("Cherry").opacity(0.6)]),
                    startPoint: .top,
                    endPoint: .bottom))
                .frame(height: 22)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("Vintage"))
        .modifier(SchemeColoured())
    }
    
    init() {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
        
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
            contentRect: NSRect(x: 0, y: 0, width: 400, height: 320),
            styleMask: [.closable, .miniaturizable, .fullSizeContentView, .titled],
            backing: .buffered, defer: false)
        window.titlebarAppearsTransparent = true
        window.title = "appName".localised() + " " + version  // TODO: Need to set title colour by scheme
        window.backgroundColor = colour
        window.standardWindowButton(.zoomButton)?.isHidden = true
        window.center()
        window.contentView = NSHostingView(rootView: self)
        window.delegate = windowDelegate
        windowDelegate.isOpen = true
        window.makeKeyAndOrderFront(nil)
    }
}

struct GeneralView: View {
    @State var language = defaults.integer(forKey: "defaultLang")
    let originalLang = defaults.integer(forKey: "defaultLang")
    
    @State var hour = defaults.integer(forKey: "defaultHour") {
        didSet { defaults.set(self.hour, forKey: "defaultHour") }
    }
    
    @State var minute = defaults.integer(forKey: "defaultMinute") {
        didSet { defaults.set(self.minute, forKey: "defaultMinute") }
    }

    @State private var needsRestart = false
    
    var body: some View {
        let languageBinding = Binding<Int>(get: {
            return self.language
        }, set: {
            self.language = $0
            self.needsRestart = self.originalLang != $0
            defaults.set(self.language, forKey: "defaultLang")
        })
        
        return Form {
            Section {
                Picker(selection: languageBinding,
                    label: Text("langLabel".localised())
                        .font(.custom("Acme", size: 15))
                        .foregroundColor(Color("Newspaper")),
                    content: {
                        Text("langSystem".localised()).tag(0)
                        Text("English").tag(1)
                        Text("正體中文").tag(2)
                        Text("日本語").tag(3)
                    })
                
                HStack {
                    Spacer()
                    
                    Text("langRestartInst".localised())
                       .font(.custom("Acme", size: 12))
                       .foregroundColor(Color("Newspaper").opacity(0.6))
                       .opacity(needsRestart ? 1 : 0)
                       .animation(.easeInOut)
                }
                
                ZStack(alignment: .leading) {
                    Text("coolDownLangLabel".localised())
                        .font(.custom("Acme", size: 15))
                        .foregroundColor(Color("Newspaper"))
                        .offset(x: -72)  // Localisation needed
                    
                    HStack {
                        VStack(spacing: 3) {
                            Button(action: {
                                if self.hour < 10 {
                                    self.hour += 1
                                }
                            }) { Text("hUp".localised()).frame(width: 36) }
                            
                            Button(action: {
                                if self.hour > 0 {
                                    self.hour -= 1
                                    if self.hour == 0 && self.minute == 0 {
                                        self.minute = 1
                                    }
                                }
                            }) { Text("hDown".localised()).frame(width: 36) }
                        }
                        
                        VStack(spacing: 3) {
                            Button(action: {
                                if self.minute < 59 {
                                    self.minute += 1
                                } else {
                                    if self.hour < 10 {
                                        self.hour += 1
                                        self.minute = 0
                                    }
                                }
                            }) { Text("minUp".localised()).frame(width: 36) }
                            
                            Button(action: {
                                if self.minute > 0 {
                                    if self.minute != 1 || self.hour != 0 {
                                        self.minute -= 1
                                    }
                                } else {
                                   if self.hour > 0 {
                                       self.hour -= 1
                                       self.minute = 59
                                   }
                                }
                            }) { Text("minDown".localised()).frame(width: 36) }
                        }
                        
                        Spacer()
                        
                        Text((self.hour == 0 ? "" : "\(self.hour)h ") + "\(self.minute)min")  // Localisation needed
                            .font(.custom("Acme", size: 12))
                            .foregroundColor(Color("Newspaper").opacity(0.6))
                    }
                }.animation(nil)
                
                
            }
            
            // TODO: Add global shortcut
//            Section {
//                HStack {
//                    Button(action: {}) {
//                        Text("Set ⌥⌘Z Shortcut")
//                    }
//                    Button(action: {}) {
//                        Text("Clear")
//                    }.disabled(true)
//                }
//            }
        }
        .padding()
        .onAppear {
            if defaults.integer(forKey: "defaultMinute") == 0 {
                defaults.set(1, forKey: "defaultMinute")
            }
        }
    }
}

struct CustomView: View {
    @State var theme = defaults.integer(forKey: "defaultTheme")
    let originalTheme = defaults.integer(forKey: "defaultTheme")
    @State var needsRestart = false
    
    var body: some View {
        let themeBinding = Binding<Int>(get: {
            return self.theme
        }, set: {
            self.theme = $0
            self.needsRestart = self.originalTheme != $0
            defaults.set(self.theme, forKey: "defaultTheme")
        })
        
        
        
        return Form {
            Section {
                Picker(selection: themeBinding,
                       label: Text("themeLabel".localised())
                            .font(.custom("Acme", size: 15))
                            .foregroundColor(Color("Newspaper")),
                       content: {
                            ColoursBar(name: "themeAuto".localised(),
                                       colours: [Color("Cherry"),
                                                 Color("Newspaper"),
                                                 Color("Sorrow"),
                                                 Color("Vintage")]).tag(0)
                            ColoursBar(name: "themeBlossom".localised(),
                                       colours: [Color(hex: 0xFF2B5F),
                                                 Color(hex: 0x1A1B15),
                                                 Color(hex: 0x2570B9),
                                                 Color(hex: 0xF9F3DF)]).tag(1)
                            ColoursBar(name: "themeCyber".localised(),
                                       colours: [Color(hex: 0xE2270C),
                                                 Color(hex: 0xF8FBDC),
                                                 Color(hex: 0xDD682D),
                                                 Color(hex: 0x4B3111)]).tag(2)
                })
                
                HStack {
                    Spacer()
                    
                    Text("themeRestartInst".localised())
                       .font(.custom("Acme", size: 12))
                       .foregroundColor(Color("Newspaper").opacity(0.6))
                       .opacity(needsRestart ? 1 : 0)
                       .animation(.easeInOut)
                }
            }
        }
        .padding()
    }
}

struct ColoursBar: View {
    let name: String
    let colours: [Color]
    
    var body: some View {
        HStack(spacing: 8) {
            Text(name)
                .foregroundColor(Color("Newspaper"))
            
            Spacer()
            
            Circle()
                .foregroundColor(colours[0])
                .overlay(Circle().stroke(Color.black.opacity(0.3), lineWidth: 0.5))
                .frame(width: 11.5, height: 11.5)
            
            Circle()
                .foregroundColor(colours[1])
                .overlay(Circle().stroke(Color.black.opacity(0.3), lineWidth: 0.5))
                .frame(width: 11.5, height: 11.5)
            
            Circle()
                .foregroundColor(colours[2])
                .overlay(Circle().stroke(Color.black.opacity(0.3), lineWidth: 0.5))
                .frame(width: 11.5, height: 11.5)
            
            Circle()
                .foregroundColor(colours[3])
                .overlay(Circle().stroke(Color.black.opacity(0.3), lineWidth: 0.5))
                .frame(width: 11.5, height: 11.5)
        }
    }
}


struct PrefsView_Previews: PreviewProvider {
    static var previews: some View {
        PrefsView()
            .colorScheme(.light)
    }
}
