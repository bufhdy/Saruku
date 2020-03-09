//
//  GetIcon.swift
//  Saruku
//
//  Created by 御薬袋托托 on 2020/3/9.
//  Copyright © 2020 Minai Toto. All rights reserved.
//

import SwiftUI
import Foundation


func getIcon(input: String, size: Int) -> Data? {
    let path = (
        input.contains(".") ?
            NSWorkspace.shared.absolutePathForApplication(withBundleIdentifier: input) :
            NSWorkspace.shared.fullPath(forApplication: input)
    ) ?? input

    guard FileManager.default.fileExists(atPath: path) else {
        return nil
    }

    return NSWorkspace.shared.icon(forFile: path).resizedForFile(to: size).png()
}

extension NSBitmapImageRep {
    func png() -> Data? {
        representation(using: .png, properties: [:])
    }
}

extension Data {
    var bitmap: NSBitmapImageRep? { NSBitmapImageRep(data: self) }
}

extension NSImage {
    func png() -> Data? { tiffRepresentation?.bitmap?.png() }

    func resizedForFile(to size: Int) -> NSImage {
        let newSizeInt = size / Int(NSScreen.main?.backingScaleFactor ?? 1)
        let newSize = CGSize(width: newSizeInt, height: newSizeInt)

        let image = NSImage(size: newSize)
        image.lockFocus()
        NSGraphicsContext.current?.imageInterpolation = .high

        draw(
            in: CGRect(origin: .zero, size: newSize),
            from: .zero,
            operation: .copy,
            fraction: 1
        )

        image.unlockFocus()
        return image
    }
}

extension FileHandle: TextOutputStream {
    public func write(_ string: String) {
        write(string.data(using: .utf8)!)
    }
}
