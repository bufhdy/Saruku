//
//  GlobalKeybindPreferences.swift
//  Saruku
//
//  Created by 御薬袋托托 on 2020/3/8.
//  Copyright © 2020 Minai Toto. All rights reserved.
//

import Foundation

struct GlobalKeybindPreferences: Codable, CustomStringConvertible {
    let function: Bool
    let control: Bool
    let command: Bool
    let shift: Bool
    let option: Bool
    let capsLock: Bool
    let carbonFlags: UInt32
    let characters: String?
    let keyCode: UInt32

    var description: String {
        var stringBuilder = ""
        if self.function {
            stringBuilder += "Fn"
        }
        if self.control {
            stringBuilder += "⌃"
        }
        if self.option {
            stringBuilder += "⌥"
        }
        if self.command {
            stringBuilder += "⌘"
        }
        if self.shift {
            stringBuilder += "⇧"
        }
        if self.capsLock {
            stringBuilder += "⇪"
        }
        if let characters = self.characters {
            stringBuilder += characters.uppercased()
        }
        return "\(stringBuilder)"
    }
}
