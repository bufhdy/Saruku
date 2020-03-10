//
//  ContentView.swift
//  Saruku
//
//  Created by 御薬袋托托 on 2020/3/5.
//  Copyright © 2020 Minai Toto. All rights reserved.
//

import SwiftUI
import Cocoa
import UserNotifications

// Core struct for items
struct AppItem: Codable, Identifiable {
    let id = UUID()
    
    var name: String
    var theme: String
    var duration: Int
    
    var color: Color { Color(hex: Int(self.theme, radix: 16)!) }
}

struct ContentView: View {
    @ObservedObject private var items = ItemSource()
    @State private var moveBarYOffset: CGFloat = 0
    @State private var removeAt: Int? = nil
    
    // Calculate height of the popover
    private func contentHeight() -> CGFloat {
        let base = CGFloat(items.source.count) * 65
        let add = moveBarYOffset <= 0 ? 9 : 23
        return base + CGFloat(add)
    }
    
    // Special situation for the first item when swiping up to delete
    private func topColour(_ index: Int) -> Color {
        return index == 0 ?
            Color("Cherry").opacity(0) :
            Color("Sorrow").opacity(0.3)
    }
    
    // Swipe down to add new item
    private func newItem() {
        let openPanel = NSOpenPanel()
        openPanel.directoryURL = URL(fileURLWithPath: "/Applications", isDirectory: true)
        openPanel.title = "Open an application"
        openPanel.showsResizeIndicator = true
        openPanel.showsHiddenFiles = false
        openPanel.canChooseDirectories = false
        openPanel.allowsMultipleSelection = false
        openPanel.allowedFileTypes = ["app"]
        
        if openPanel.runModal() == NSApplication.ModalResponse.OK {
            if let url = openPanel.url {
                let appName = url.deletingPathExtension().lastPathComponent
                
                self.items.source.append(AppItem(
                    name: appName,
                    theme: "FF2B5F", // Set to "Cherry", need to integrate
                    duration: 60))
            }
            openPanel.close()
        }
        
        // After adding new item, open the popover again
        let appDelegate = NSApp.delegate as? AppDelegate
        appDelegate?.popover.show(
            relativeTo: (appDelegate?.statusBarItem.button!.bounds)!,
            of: (appDelegate?.statusBarItem.button!)!,
            preferredEdge: NSRectEdge.minY)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(items.source.indices, id: \.self) { index in
                VStack(spacing: 0) {
                    ZStack {
                        // Single item with icon and close, edit button
                        AppItemView(items: self.$items.source,
                                    index: index,
                                    hour: self.items.source[index].duration / 3600,
                                    icon: getIcon(input: self.items.source[index].name, size: 256)!)
                        
                        // Seperator between items
                        Rectangle()
                            .foregroundColor(.clear)
                            .background(LinearGradient(
                                gradient: Gradient(colors:
                                    [self.topColour(index), Color("Cherry").opacity(0.3)]),
                                startPoint: .top,
                                endPoint: .bottom))
                            .opacity(index == self.removeAt ? 1 : 0)
                            .animation(nil)
                    }
                    
                    // Covering of item when deleting
                    if index != self.items.source.count - 1 {
                        Rectangle()
                            .foregroundColor(Color("Sorrow").opacity(0.3))
                            .background(Color("Vintage"))
                            .frame(width: 60, height: 5)
                    }
                }
            }
            
            // Add and delete bar. Do not add animation, it'll be slow
            MoveBarView()
                .offset(y: -14 + moveBarYOffset)
                .frame(height: 14 + moveBarYOffset, alignment: .top)
                .zIndex(-1)
                .gesture(DragGesture()
                    .onChanged { value in
                        self.moveBarYOffset = value.translation.height
                        self.removeAt = nil
                        
                        if self.moveBarYOffset <= 10 {
                            if self.moveBarYOffset < 0 {
                                self.removeAt = self.items.source.count - 1
                            }
                            self.moveBarYOffset = 0
                        } else { self.moveBarYOffset = 14 }
                    }
                    .onEnded { value in
                        if value.translation.height >= 14 { self.newItem() }
                        else if let removeAt = self.removeAt {
                            self.items.source.remove(at: removeAt)
                            if removeAt == 0 {
                                self.items.source.append(AppItem(
                                    name: "Saruku",
                                    theme: "FF2B5F",
                                    duration: 60))
                            }
                            self.removeAt = nil
                        }
                        
                        self.moveBarYOffset = 0
                })
        }
        .frame(width: 60, height: contentHeight())
    }
}

struct AppItemView: View {
    @Binding var items: [AppItem]
    let index: Int
    @State var hour: Int
    let icon: Data
    
    // Timer
    @State private var second = 0
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State private var showDeleteButton = false
    @State private var showEditButton = false
    
    @State private var editing = false
    @State private var editingHour = false
    @State private var hourEditorYOffset: CGFloat = 0
    
    @State private var isDragging: Bool = false {
        willSet(newValue) {
            if self.isDragging != newValue {
                if newValue {
                    NSCursor.hide()
                } else {
                    NSCursor.unhide()
                }
            }
        }
    }
   
    private func openApp(_ name: String) {
        let url = NSURL(fileURLWithPath: "/Applications/" + name + ".app", isDirectory: true) as URL
        
        let path = "/bin"
        let configuration = NSWorkspace.OpenConfiguration()
        configuration.arguments = [path]
        
        NSWorkspace.shared.openApplication(at: url,
                                           configuration: configuration,
                                           completionHandler: nil)
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Image(nsImage: NSImage(data: self.icon)!)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .saturation(second == 0 ? 1 : 0)
                .animation(Animation.linear(duration: 0.8))
                .frame(width: 42, height: 42)
                .onReceive(timer) { _ in  // Timer changed here
                    if self.second > 0 {
                        // Send notification
                        if self.second == 1 {
                            let appDelegate = NSApp.delegate as? AppDelegate
                            if !(appDelegate?.popover.isShown)! {
                                appDelegate?.notificationAction(named: self.items[self.index].name)
                            }
                        }
                        self.second -= 1
                    }
                }
                .onTapGesture {
                    self.second = self.items[self.index].duration
                    self.openApp(self.items[self.index].name)
                }
                .frame(width: 60, height: 60)
            
            // Add transparent layer to prevent click
            if self.second != 0 { Color.black.opacity(0.0001) }
            
            ItemBackground(isFirst: index == 0, color: items[index].color.opacity(0.3))
                .frame(width: CGFloat(60) * (CGFloat(self.second) / CGFloat(items[index].duration)),
                       height: 60,
                       alignment: .leading)
                .animation(.easeInOut)
            
            ZStack {
                Circle()
                    .foregroundColor(Color("Cherry"))
                    .overlay(Circle().stroke(Color.black.opacity(0.3), lineWidth: 0.5))
            }
            .frame(width: 11.5, height: 11.5)
            .onHover { value in self.showDeleteButton = value }
            .opacity(showDeleteButton ? 1 : 0)
            .animation(Animation.linear(duration: 0.1))
            .onTapGesture {
                if self.second != 0 { self.second = 0 }  // Quit timer
                else {  // Delete the item
                    self.items.remove(at: self.index)
                    if self.index == 0 && self.items.count == 0 {
                        self.items.append(AppItem(
                            name: "Saruku",
                            theme: "FF2B5F",
                            duration: 60))
                    }
                }
            }
            .offset(x: 4.25, y: 4.25)
            
            EditView(items: $items,
                     index: index,
                     hour: $hour,
                     minute: items[index].duration % 3600 / 60,
                     second: $items[index].duration,
                     editingHour: $editingHour,
                     editing: $editing)
                .opacity(editing ? 1 : 0)
                .animation(Animation.linear(duration: 0.1))
            
            ZStack {
                Circle()
                    .foregroundColor(Color("Sorrow"))
                    .overlay(Circle().stroke(Color.black.opacity(0.3), lineWidth: 0.5))
            }
            .frame(width: 11.5, height: 11.5)
            .opacity(second == 0 ? 1 : 0)
            .onHover { value in
                self.showEditButton = self.editing ?
                    self.editingHour :
                    value
            }
            .opacity(showEditButton ? 1 : 0)
            .offset(y: hourEditorYOffset)
            .animation(Animation.linear(duration: 0.1))
            .gesture(DragGesture()
                .onChanged { value in
                    self.isDragging = true
                    
                    self.showEditButton = true
                    self.editing = true
                    self.editingHour = true
                    
                    self.hourEditorYOffset = value.translation.height
                    if self.hourEditorYOffset > 0 {  // Border
                        self.hourEditorYOffset = 0
                    }
                    if self.hourEditorYOffset < -40 {
                        self.hourEditorYOffset = -40
                    }
                    
                    self.hour = Int(self.hourEditorYOffset) / -4
                }
                .onEnded { _ in
                    self.isDragging = false
                    
                    self.editingHour = false
                    self.showEditButton = false
                    
                    self.hourEditorYOffset = 0
                }
            )
            .onTapGesture {
                self.editing = true
                self.showEditButton = false
            }
            .offset(x: 44.25, y: 44.25)
        }
        .frame(width: 60, height: 60)
        .background(ItemBackground(isFirst: index == 0, color: Color("Vintage")))
    }
}

struct Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .colorScheme(.light)
    }
}
