//
//  PrefsView.swift
//  Saruku
//
//  Created by 御薬袋托托 on 2020/3/8.
//  Copyright © 2020 Minai Toto. All rights reserved.
//

import SwiftUI
import HotKey
import Carbon
import LaunchAtLogin

struct ToggleModel {
    var value: Bool {
        willSet {
            LaunchAtLogin.isEnabled = !value
            print("\(LaunchAtLogin.isEnabled)")
        }
    }
}

struct PrefsView: View {
    var window: NSWindow!
    @State var prefsWindowDelegate = WindowsDelegate()
    
    @State var launchAtLogin: Bool = false
    @State var launchAtLoginModel = ToggleModel(value: LaunchAtLogin.isEnabled)
    
    var body: some View {
        VStack(spacing: 0) {
            TabView {
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
        window.delegate = prefsWindowDelegate
        prefsWindowDelegate.windowIsOpen = true
        window.makeKeyAndOrderFront(nil)
    }
}

struct GeneralView: View {
    @State var language = 0
    @State var shortcutTitle: String = "" // "Option+Command+Z"
    
//    func register() {
//        self.unregister()
//    }
//    
//    func unregister() {
//        let appDelegate = NSApplication.shared.delegate as! AppDelegate
//        // appDelegate.hotKey = nil
//        self.shortcutTitle = ""
//        
//        Storage.remove("globalKeybind.json", from: .documents)
//    }
    
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
                Text("Hello, General!")
                HStack {
                    Button(action: {}) {
                        Text("Set Shortcut")
                    }
                    Button(action: {}) {
                        Text("Clear")
                    }.disabled(true)
                }
            }
        }
        .padding()
    }
    
//    init() {
//        if Storage.fileExists("globalKeybind.json", in: .documents) {
//            // let globalKeybinds = Storage.retrieve("globalKeybind.json", from: .documents, as: GlobalKeybindPreferences.self)
//        }
//    }
}

struct CustomView: View {
    @State var theme = 0
    @State var shortcut: String = "" // "Option+Command+Z"
    
    var body: some View {
        Form {
            Section {
                Picker(selection: $theme,
                       label: Text("Theme:")
                            .font(.custom("Acme", size: 15))
                            .foregroundColor(Color("Newspaper")),
                       content: {
                        ColourBar(name: "Blossom", colours: [Color("Vintage"), Color("Newspaper"), Color("Cherry"), Color("Sorrow")]).tag(0)
                        Text("Nightmare").tag(1)
                })
            }
        }
        .padding()
    }
}

struct ColourBar: View {
    let name: String
    let colours: [Color]
    
    var body: some View {
        HStack(spacing: 8) {
            Text(name)
                .font(.custom("Acme", size: 15))
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

