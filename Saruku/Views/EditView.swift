//
//  EditView.swift
//  Saruku
//
//  Created by 御薬袋托托 on 2020/3/6.
//  Copyright © 2020 Minai Toto. All rights reserved.
//

import SwiftUI

struct EditView: View {
    @Binding var items: [AppItem]
    let index: Int
    
    @Binding var hour: Int
    @State var minute: Int
    @Binding var second: Int
    
    @Binding var editingHour: Bool
    @Binding var editing: Bool
    
    @State private var minuteEditorYOffset: CGFloat = 0
    
    private func setSecond() {
        self.second = hour * 3600 + minute * 60
        self.items[self.index].duration = self.second
        self.editing = false
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            ZStack {
                Circle()
                    .foregroundColor(Color("Cherry"))
                    .overlay(Circle().stroke(Color.black.opacity(0.3), lineWidth: 0.5))
            }
            .frame(width: 11.5, height: 11.5)
            .onTapGesture {  // Close without saving changes, back to original hour and minute
                self.hour = self.items[self.index].duration / 3600
                self.minute = self.items[self.index].duration % 3600 / 60
                
                self.editing = false
            }
            .offset(x: 4.25, y: 4.25)
            .opacity(minuteEditorYOffset == 0 ? 1 : 0)
            .animation(Animation.linear(duration: 0.1))
            
            SliderBackgroundView(isFirst: index == 0)  // For minute editor
                .animation(Animation.linear(duration: 0.1))
                .opacity(minuteEditorYOffset != 0 ? 1 : 0)
        
            SliderBackgroundView(isFirst: index == 0)  // For hour editor
                .offset(x: 40)
                .animation(Animation.linear(duration: 0.1))
                .opacity(editingHour ? 1 : 0)
            
            ZStack {
                Circle()
                    .foregroundColor(self.hour != 0 || self.minute != 0 ?
                        Color("Sorrow") :
                        Color("Newspaper").opacity(0.6))  // TODO: Need to be set gray scale
                    .overlay(Circle().stroke(Color.black.opacity(0.3), lineWidth: 0.5))
            }
            .frame(width: 11.5, height: 11.5)
            .offset(y: minuteEditorYOffset)
            .gesture(DragGesture()
                .onChanged { value in
                    self.minuteEditorYOffset = value.translation.height
                    if self.minuteEditorYOffset > 0 {
                        self.minuteEditorYOffset = 0
                    }
                    if self.minuteEditorYOffset < -40 {
                        self.minuteEditorYOffset = -40
                    }
                    
                    self.minute = Int(Double(self.minuteEditorYOffset) * 59.0 / -40.0)
                }
                .onEnded { _ in
                    self.minuteEditorYOffset = 0
                    
                    if self.hour != 0 || self.minute != 0 { self.setSecond() }
                }
            )
            .onTapGesture {
                if self.hour != 0 || self.minute != 0 { self.setSecond() }
            }
            .offset(x: 4.25, y: 44.25)
            
            HStack(spacing: 0) {
                Spacer()
                
                VStack(spacing: 0) {
                    Stepper(onIncrement: {
                        if self.hour < 10 {
                            self.hour += 1
                        }
                    }, onDecrement: {
                        if self.hour > 0 {
                            self.hour -= 1
                        }
                    }) { Text("") }  // TODO: Better stepper and change the colour
                        .frame(width: 13, height: 21, alignment: .trailing)
                        .clipShape(Rectangle())
                    
                    Spacer().frame(height: 3)
                    
                    Text("\(hour)")
                        .font(.custom("Acme", size: 12))
                        .foregroundColor(Color("Sorrow"))
                        .frame(width: 20)
                        .animation(nil)  // Disable animation to avoid seeing frame changes
                    Text("H")
                        .font(.custom("Acme", size: 12))
                        .foregroundColor(Color("Newspaper"))
                }.frame(width: 20)
                
                VStack(spacing: 0) {
                    Stepper(onIncrement: {
                        if self.minute < 59 {
                            self.minute += 1
                        } else {
                            if self.hour < 10 {
                                self.hour += 1
                                self.minute = 0
                            }
                        }
                    }, onDecrement: {
                        if self.minute > 0 {
                            self.minute -= 1
                        } else {
                            if self.hour > 0 {
                                self.hour -= 1
                                self.minute = 59
                            }
                        }
                    })  { Text("").foregroundColor(Color("Newspaper")) }
                        .frame(width: 13, height: 21, alignment: .trailing)
                        .clipShape(Rectangle())
                    
                    Spacer().frame(height: 3)
                    
                    Text("\(minute)")
                        .font(.custom("Acme", size: 12))
                        .foregroundColor(Color("Sorrow"))
                        .frame(width: 20)
                        .animation(nil)
                    Text("M")
                        .font(.custom("Acme", size: 12))
                        .foregroundColor(Color("Newspaper"))
                }
                .frame(width: 20)
                .opacity(editingHour ? 0 : 1)
                .animation(.linear)
            }
            .frame(width: 60, height: 60)
        }
        .background(ItemBackground(isFirst: index == 0, color: Color("Vintage")))
        .animation(Animation.linear(duration: 0.1))
    }
}
