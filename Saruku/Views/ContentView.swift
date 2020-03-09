//
//  ContentView.swift
//  Saruku
//
//  Created by 御薬袋托托 on 2020/3/5.
//  Copyright © 2020 Minai Toto. All rights reserved.
//

import SwiftUI
import Cocoa

struct ContentView: View {
    @ObservedObject var items = ItemSource()
    @State var addBarState: CGFloat = 0
    @State var removeAt: Int? = nil
    
    func contentHeight() -> CGFloat {
        let base = CGFloat(items.source.count) * 65
        let add = addBarState <= 0 ? 9 : 23
        return base + CGFloat(add)
    }
    
    func removeBlockOpacity(_ index: Int) -> Double {
        if index == self.removeAt {
            return 0.3
        }
        return 0
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(items.source.indices, id: \.self) { index in
                VStack(spacing: 0) {
                    ZStack {
                        AppItemView(items: self.$items.source, index: index)
                        
                        Color("Sorrow")
                            .opacity(self.removeBlockOpacity(index))
                    }
                    
                    if index != self.items.source.count - 1 {
                        RoundedRectangle(cornerRadius: 1)
                            .frame(width: 15, height: 2)
                            .foregroundColor(Color("Sorrow").opacity(0.5))
                            .frame(width: 60, height: 5)
                            .background(Color("Sorrow").opacity(0.3))
                            .frame(width: 60, height: 5)
                            .background(Color("Vintage"))
                    }
                }
            }
            
            AddView()
                .offset(y: -14 + addBarState)
                .zIndex(-1)
                .frame(height: 14 + addBarState, alignment: .top)
                .gesture(DragGesture()
                    .onChanged { value in
                        self.addBarState = value.translation.height
                        self.removeAt = nil
                        
                        if self.addBarState <= 10 {
                            if self.addBarState < 0 {
                                self.removeAt = self.items.source.count - 1
                            }
                            self.addBarState = 0
                        }
                        if self.addBarState > 10 {
                            self.addBarState = 14
                        }
                    }
                    .onEnded { value in
                        if value.translation.height >= 14 {
                            self.items.source.append(self.items.source[0])
                        }
                        if let removeAt = self.removeAt {
                            self.items.source.remove(at: removeAt)
                        }
                        
                        self.removeAt = nil
                        self.addBarState = 0
                    })
        }
        .frame(width: 60, height: contentHeight())
    }
}

struct AppItem: Codable, Identifiable {
    let id = UUID()
    
    var name: String
    var theme: String
    var duration: Int
    
    var color: Color { Color(hex: Int(self.theme, radix: 16)!) }
}



struct AppItemView: View {
    @Binding var items: [AppItem]
    @State private var timeRemaining = 0
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var showDelete = false
    @State private var showEdit = false
    @State private var rightEditng = false
    @State private var editing = false
    @State private var editingMoveState: CGSize = .zero
    @State private var hour = 0
    let index: Int
    var Icon: Data? = nil
    
    func openApp(_ name: String) {
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
            Image(nsImage: NSImage(data: self.Icon!)!)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .saturation(timeRemaining > 1 ? 0 : 1)
                .frame(width: 42, height: 42)
                .onReceive(timer) { _ in
                    if self.timeRemaining > 0 { self.timeRemaining -= 1 }
            }
            .onTapGesture {
                self.timeRemaining = self.items[self.index].duration
                self.openApp(self.items[self.index].name)
            }
            .animation(Animation.linear(duration: 0.8))
            .frame(width: 60, height: 60)
            
            // Prevent click
            if self.timeRemaining != 0 {
                Color.black.opacity(0.0001)
            }
            Rectangle()
                .frame(width: CGFloat(60) * (CGFloat(self.timeRemaining) / CGFloat(items[index].duration)),
                       height: 60,
                       alignment: .leading)
                .foregroundColor(.clear)
                .background(ItemBackground(isFirst: index == 0, color: items[index].color.opacity(0.3)))
            
            ZStack {
                Circle()
                    .foregroundColor(Color("Cherry"))
                    .overlay(Circle().stroke(Color.black.opacity(0.3), lineWidth: 0.5))
            }
                .frame(width: 11.5, height: 11.5)
                .onHover { value in
                    self.showDelete = value
                }
                .opacity(showDelete ? 1 : 0)
                .animation(Animation.linear(duration: 0.1))
                .onTapGesture {
                    if self.timeRemaining != 0 {
                        self.timeRemaining = 0
                    } else {
                        self.items.remove(at: self.index)
                    }
                }
                .offset(x: 4.25, y: 4.25)
            
            EditView(hour: $hour, minute: items[index].duration % 3600 / 60, rightEditing: $rightEditng, editing: $editing, second: $items[index].duration, editingMoveState: $editingMoveState, isFirst: index == 0)
                .opacity(editing ? 1 : 0)
                .animation(Animation.linear(duration: 0.1))
            
            ZStack {
                Circle()
                    .foregroundColor(Color("Sorrow"))
                    .overlay(Circle().stroke(Color.black.opacity(0.3), lineWidth: 0.5))
                
                // Text("x")
            }
            .frame(width: 11.5, height: 11.5)
                .opacity(timeRemaining == 0 ? 1 : 0)
                .onHover { value in
                    self.showEdit = self.editing ? self.rightEditng : value
                }
                .opacity(showEdit ? 1 : 0)
                .animation(Animation.linear(duration: 0.1))
                .offset(y: editingMoveState.height)
                .gesture(DragGesture()
                    .onChanged { value in
                        self.showEdit = true
                        self.editing = true
                        self.rightEditng = true
                        self.editingMoveState = value.translation
                        if self.editingMoveState.height > 0 {
                            self.editingMoveState.height = 0
                        }
                        
                        if self.editingMoveState.height < -40 {
                            self.editingMoveState.height = -40
                        }
                        self.hour = Int(self.editingMoveState.height) / -4
                    }
                    .onEnded { _ in
                        self.rightEditng = false
                        self.editingMoveState = .zero
                        self.showEdit = false
                    }
                )
                .onTapGesture {
                    self.showEdit = false
                    self.editing.toggle()
                }
                .offset(x: 44.25, y: 44.25)
        }
        .frame(width: 60, height: 60)
        .background(ItemBackground(isFirst: index == 0, color: Color("Vintage")))
    }
    
    init(items: Binding<[AppItem]>, index: Int) {
        self._items = items
        self.index = index
        
        guard let icon = getIcon(input: self.items[index].name, size: 128)
        else { return }

        self.Icon = icon
    }
}

struct Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .colorScheme(.light)
    }
}
