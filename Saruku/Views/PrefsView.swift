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
        willSet { LaunchAtLogin.isEnabled = !value }
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
    }
    
    init() {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
        
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 400, height: 300),
            styleMask: [.closable, .miniaturizable, .fullSizeContentView, .titled],
            backing: .buffered, defer: false)
        window.titlebarAppearsTransparent = true
        window.title = "Saruku " + version
        window.backgroundColor = NSColor(named: "Vintage")
        window.standardWindowButton(.zoomButton)?.isHidden = true
        window.center()
        window.contentView = NSHostingView(rootView: self)
        window.delegate = windowDelegate
        windowDelegate.windowIsOpen = true
        window.makeKeyAndOrderFront(nil)
    }
}

struct GeneralView: View {
    @State var language = 0
    @State var shortcutTitle: String = ""
    
    var body: some View {
        Form {
            Section {
                Picker(selection: $language,
                       label: Text("Language:")
                            .font(.custom("Acme", size: 15))
                            .foregroundColor(Color("Newspaper")),
                       content: {
                        Text("English").tag(0)
                        Text("正體中文").tag(1)
                        Text("日本語").tag(2)
                })
            }
            
            Section {
                HStack {
                    Button(action: {}) {
                        Text("Set ⌥⌘Z Shortcut")
                    }
                    Button(action: {}) {
                        Text("Clear")
                    }.disabled(true)
                }
            }
        }
        .padding()
    }
}

struct CustomView: View {
    @State var theme = 0
    
    var body: some View {
        Form {
            Section {
                Picker(selection: $theme,
                       label: Text("Theme:")
                            .font(.custom("Acme", size: 15))
                            .foregroundColor(Color("Newspaper")),
                       content: {
                        ColoursBar(name: "Blossom", colours: [Color("Vintage"), Color("Newspaper"), Color("Cherry"), Color("Sorrow")]).tag(0)
                        Text("Nightmare").tag(1)
                })
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
                .foregroundColor(colours[1])
            
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
