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
    
    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $tabIndex) {
                GeneralView()
                    .tabItem({ Text("General") })
                    .tag(0)
                CustomView()
                    .tabItem({ Text("Customisations") })
                    .tag(1)
                Text("Import & Export")
                    .tabItem({ Text("Import & Export") })
                    .tag(2)
            }
            .padding([.horizontal, .top])
            
            Toggle(isOn: $launchAtLoginModel.value) {
                Text("Launch Saruku at login")
                    .font(.custom("Acme", size: 15))
                    .foregroundColor(Color("Newspaper"))
            }
            .padding(.vertical)
            
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
        
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 400, height: 320),
            styleMask: [.closable, .miniaturizable, .fullSizeContentView, .titled],
            backing: .buffered, defer: false)
        window.titlebarAppearsTransparent = true
        window.title = "Saruku " + version
        window.backgroundColor = NSColor(named: NSColor.Name("Vintage"))  // TODO: Need to set by colour scheme
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
    
    @State var minute = defaults.integer(forKey: "defaultMinute") {  // Bug: default zero will crash
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
                    label: Text("Language: ")
                        .font(.custom("Acme", size: 15))
                        .foregroundColor(Color("Newspaper")),
                    content: {
                        Text("English").tag(0)
                        Text("正體中文").tag(1)
                        Text("日本語").tag(2)
                    })
                
                HStack {
                    Spacer()
                    
                    Text("Language will change after restart.")
                       .font(.custom("Acme", size: 12))
                       .foregroundColor(Color("Newspaper").opacity(0.6))
                       .opacity(needsRestart ? 1 : 0)
                       .animation(.easeInOut)
                }
                
                ZStack(alignment: .leading) {
                    Text("Default\ncooldown: ")
                        .font(.custom("Acme", size: 15))
                        .foregroundColor(Color("Newspaper"))
                        .offset(x: -72)
                    
                    HStack {
                        VStack(spacing: 3) {
                            Button(action: {
                                if self.hour < 10 {
                                    self.hour += 1
                                }
                            }) { Text("h↑").frame(width: 36) }
                            
                            Button(action: {
                                if self.hour > 0 {
                                    self.hour -= 1
                                    if self.hour == 0 && self.minute == 0 {
                                        self.minute = 1
                                    }
                                }
                            }) { Text("h↓").frame(width: 36) }
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
                            }) { Text("min↑").frame(width: 36) }
                            
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
                            }) { Text("min↓").frame(width: 36) }
                        }
                        
                        Spacer()
                        
                        Text((self.hour == 0 ? "" : "\(self.hour)h ") + "\(self.minute)min")
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
                       label: Text("Theme: ")
                            .font(.custom("Acme", size: 15))
                            .foregroundColor(Color("Newspaper")),
                       content: {
                            ColoursBar(name: "Auto",
                                       colours: [Color("Cherry"),
                                                 Color("Newspaper"),
                                                 Color("Sorrow"),
                                                 Color("Vintage")]).tag(0)
                            ColoursBar(name: "Blossom",
                                       colours: [Color(hex: 0xFF2B5F),
                                                 Color(hex: 0x1A1B15),
                                                 Color(hex: 0x2570B9),
                                                 Color(hex: 0xF9F3DF)]).tag(1)
                            ColoursBar(name: "Cyber-Nightmare",
                                       colours: [Color(hex: 0xE2270C),
                                                 Color(hex: 0xF8FBDC),
                                                 Color(hex: 0xDD682D),
                                                 Color(hex: 0x4B3111)]).tag(2)
                })
                
                HStack {
                    Spacer()
                    
                    Text("Theme will be applied after restart.")
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
