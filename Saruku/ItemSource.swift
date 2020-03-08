//
//  ItemSource.swift
//  Saruku
//
//  Created by 御薬袋托托 on 2020/3/5.
//  Copyright © 2020 Minai Toto. All rights reserved.
//

import SwiftUI
import Combine

class ItemSource: ObservableObject {
    @Published var source: [AppItem]
    
    init() {
        let url = Bundle.main.url(forResource: "AppItemData", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        self.source = try! JSONDecoder().decode([AppItem].self, from: data)
    }
}
