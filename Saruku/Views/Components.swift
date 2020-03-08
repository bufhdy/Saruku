//
//  Components.swift
//  Saruku
//
//  Created by 御薬袋托托 on 2020/3/8.
//  Copyright © 2020 Minai Toto. All rights reserved.
//

import SwiftUI

struct ItemBackground: View {
    let isFirst: Bool
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

struct SlideBgView: View {
    let isFirst: Bool

    var body: some View {
        VStack(spacing: 0) {
            if isFirst {
                Rectangle()
                    .frame(height: 10)
                    .foregroundColor(.clear)
                    .background(LinearGradient(gradient: Gradient(colors: [Color("Sorrow").opacity(0), Color("Sorrow").opacity(0.3)]),
                                               startPoint: .top,
                                               endPoint: .bottom))
            } else {
                Rectangle()
                    .frame(height: 10)
                    .foregroundColor(Color("Sorrow").opacity(0.3))
            }

            Rectangle()
                .frame(height: 50)
                .foregroundColor(.clear)
                .background(LinearGradient(gradient: Gradient(colors: [Color("Sorrow").opacity(0.3), Color("Sorrow").opacity(0)]),
                                           startPoint: .top,
                                           endPoint: .bottom))

        }.frame(width: 20, height: 60)
    }
}
