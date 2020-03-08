//
//  ContentView.swift
//  Saruku
//
//  Created by 御薬袋托托 on 2020/3/5.
//  Copyright © 2020 Minai Toto. All rights reserved.
//

import SwiftUI
import Cocoa

func openApp(_ name: String) {
    let url = NSURL(fileURLWithPath: "/Applications/" + name + ".app", isDirectory: true) as URL
    
    let path = "/bin"
    let configuration = NSWorkspace.OpenConfiguration()
    configuration.arguments = [path]
    
    NSWorkspace.shared.openApplication(at: url,
                                       configuration: configuration,
                                       completionHandler: nil)
}

struct ContentView: View {
    @ObservedObject var items = ItemSource()
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(items.source.indices, id: \.self) { index in
                VStack(spacing: 0) {
                    AppItemView(item: self.$items.source[index], isFirst: index == 0)
                    
                    if index != self.items.source.count - 1 {
                        RoundedRectangle(cornerRadius: 1)
                            .frame(width: 18, height: 2)
                            .foregroundColor(Color("Newspaper").opacity(0.4))
                            .frame(width: 60, height: 5)
                            .background(Color("Newspaper").opacity(0.2))
                            .frame(width: 60, height: 5)
                            .background(Color("Vintage")) // TODO: need to check colours
                    }
                }
            }
        }
        .frame(width: 60, height: CGFloat(items.source.count) * 65 - 5)
    }
}


//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}


struct AppItem: Codable, Identifiable {
    let id = UUID()
    
    var name: String
    var theme: String
    var duration: Int
    
    var color: Color { Color(hex: Int(self.theme, radix: 16)!) }
}


// Hex colour
extension Color {
    init(hex: Int, alpha: Double = 1) {
        let components = (
            R: Double((hex >> 16) & 0xff) / 255,
            G: Double((hex >> 08) & 0xff) / 255,
            B: Double((hex >> 00) & 0xff) / 255
        )
        self.init(
            .sRGB,
            red: components.R,
            green: components.G,
            blue: components.B,
            opacity: alpha
        )
    }
}

struct AppItemView: View {
    @Binding var item: AppItem
    @State private var timeRemaining = 0.0
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    @State private var showDelete = false
    @State private var showEdit = false
    @State private var rightEditng = false
    @State private var editing = false
    @State private var editingMoveState: CGSize = .zero
    @State private var hour = 0
    let isFirst: Bool
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Image(item.name + "Icon")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .saturation(timeRemaining > 1 ? 0 : 1)
                .frame(width: 40, height: 40)
                .onReceive(timer) { _ in
                    if self.timeRemaining > 0 { self.timeRemaining -= 0.1 }
            }
            .onTapGesture {
                self.timeRemaining = Double(self.item.duration)
                openApp(self.item.name)
            }
            .animation(Animation.linear(duration: 0.8))
            .frame(width: 60, height: 60)
            
            // Prevent click
            if self.timeRemaining != 0 {
                Color.black.opacity(0.0001)
            }
            Rectangle()
                .frame(width: CGFloat(60) * (CGFloat(self.timeRemaining) / CGFloat(item.duration)),
                       height: 60,
                       alignment: .leading)
                .foregroundColor(.clear)
                .background(ItemBackground(isFirst: isFirst, color: item.color.opacity(0.3)))
            
            ZStack {
                Circle()
                    .foregroundColor(Color.red)
                    .overlay(Circle().stroke(Color.black.opacity(0.3), lineWidth: 0.5))
                
                // Text("x")
            }
                .frame(width: 12, height: 12)
                .onHover { value in
                    self.showDelete = value
                }
                .opacity(showDelete ? 1 : 0)
                .animation(Animation.linear(duration: 0.1))
                .onTapGesture {
                    if self.timeRemaining != 0 {
                        self.timeRemaining = 0
                    }
                }
                .offset(x: 6, y: 6)
            
            EditView(hour: $hour, minute: item.duration % 3600 / 60, rightEditing: $rightEditng, editing: $editing, second: $item.duration, editingMoveState: $editingMoveState, isFirst: isFirst)
                .opacity(editing ? 1 : 0)
                .animation(Animation.linear(duration: 0.1))
            
            ZStack {
                Circle()
                    .foregroundColor(Color.yellow)
                    .overlay(Circle().stroke(Color.black.opacity(0.3), lineWidth: 0.5))
                
                // Text("x")
            }
                .frame(width: 12, height: 12)
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
                        
                        if self.editingMoveState.height < -36 {
                            self.editingMoveState.height = -36
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
                .offset(x: 42, y: 42)
        }
        .frame(width: 60, height: 60)
        .background(ItemBackground(isFirst: isFirst, color: Color("Vintage")))
    }
}

struct ItemBackground: View {
    var isFirst: Bool
    let color: Color
    
    var body: some View {
        VStack(spacing: 0) {
            if isFirst {
                Rectangle()
                    .frame(height: 10)
                    .foregroundColor(.clear)
                    .background(LinearGradient(gradient: Gradient(colors: [color.opacity(0), color]),
                                               startPoint: .top,
                                               endPoint: .bottom))
            } else {
                Rectangle()
                    .frame(height: 10)
                    .foregroundColor(color)
                    
            }
                
            Rectangle()
                .frame(height: 50)
                .foregroundColor(color)
                
        }.frame(height: 60)
    }
}
