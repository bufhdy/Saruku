//
//  EditView.swift
//  Saruku
//
//  Created by 御薬袋托托 on 2020/3/6.
//  Copyright © 2020 Minai Toto. All rights reserved.
//

import SwiftUI

struct EditView: View {
    @Binding var hour: Int
    @State var minute: Int
    @Binding var rightEditing: Bool
    @Binding var editing: Bool
    @Binding var second: Int
    @Binding var editingMoveState: CGSize
    @State var submittingMoveState: CGSize = .zero
    let isFirst: Bool
    
    func toSecond() -> Int { return hour * 3600 + minute * 60 }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            ZStack {
                Circle()
                    .foregroundColor(Color("Cherry"))
                    .overlay(Circle().stroke(Color.black.opacity(0.3), lineWidth: 0.5))
            }
            .frame(width: 12, height: 12)
            .onTapGesture {
                self.editing = false
            }
            .offset(x: 4, y: 4)
            .animation(Animation.linear(duration: 0.1))
            .opacity(submittingMoveState == .zero ? 1 : 0)
            
            
            SlideBgView(isFirst: isFirst)
                .animation(Animation.linear(duration: 0.1))
                .opacity(submittingMoveState != .zero ? 1 : 0)
                
        
            SlideBgView(isFirst: isFirst)
                .offset(x: 40)
                .animation(Animation.linear(duration: 0.1))
                .opacity(rightEditing ? 1 : 0)
                
            
            ZStack {
                Circle()
                    .foregroundColor(self.hour != 0 || self.minute != 0 ? Color("Sorrow") : Color("Newspaper").opacity(0.6))
                    .overlay(Circle().stroke(Color.black.opacity(0.3), lineWidth: 0.5))
                    .animation(.linear)
            }
            .frame(width: 12, height: 12)
            .offset(y: submittingMoveState.height)
            .gesture(DragGesture()
                .onChanged { value in
                    self.submittingMoveState = value.translation
                    if self.submittingMoveState.height > 0 {
                        self.submittingMoveState.height = 0
                    }
                    
                    if self.submittingMoveState.height < -40 {
                        self.submittingMoveState.height = -40
                    }
                    self.minute = Int(Double(self.submittingMoveState.height) * 59.0 / -40.0)
                }
                .onEnded { _ in
                    self.submittingMoveState = .zero
                    if self.hour != 0 || self.minute != 0 {
                        self.editing = false
                    }
                }
            )
            .onTapGesture {
                if self.hour != 0 || self.minute != 0 {
                    self.second = self.toSecond()
                    self.editing = false
                }
            }
            .offset(x: 4, y: 44)
            
            HStack(spacing: 0) {
                Spacer()
                
                VStack(spacing: 0) {
                    Stepper(value: $hour, in: 0...9) { Text("") }
                        .frame(width: 13, height: 21, alignment: .trailing)
                        .clipShape(Rectangle())
                    
                    Spacer().frame(height: 3)
                    
                    Text("\(hour)")
                        .font(.custom("Acme", size: 12))
                        .foregroundColor(Color("Sorrow"))
                        .frame(width: 20)
                        .animation(nil)
                    Text("H")
                        .font(.custom("Acme", size: 12))
                        .foregroundColor(Color("Newspaper"))
                }.frame(width: 20)
                
                VStack(spacing: 0) {
                    Stepper(value: $minute, in: 0...60) { Text("").foregroundColor(Color("Newspaper")) }
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
                .opacity(rightEditing ? 0 : 1)
                .animation(.linear)
            }
            .frame(width: 60, height: 60)
        }
        .background(ItemBackground(isFirst: isFirst, color: Color("Vintage")))
        .animation(Animation.linear(duration: 0.1))
    }
}
