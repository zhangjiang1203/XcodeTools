//
//  Color+Extension.swift
//  XcodeTools
//
//  Created by 张江 on 2025/6/4.
//


import SwiftUI
#if os(macOS)
import AppKit
#else
import UIKit
#endif

public extension Color {
    
    /// 十六进制便利写法
    init(hex: String, opacity: Double = 1) {
        var hexColor = hex
        if hexColor.starts(with: "#") {
            hexColor = hexColor.replacingOccurrences(of: "#", with: "")
        }
        
        var red: Int64 = 0, green: Int64 = 0, blue: Int64 = 0
        Scanner(string: hexColor[0..<2]).scanHexInt64(&red)
        Scanner(string: hexColor[2..<4]).scanHexInt64(&green)
        Scanner(string: hexColor[4..<6]).scanHexInt64(&blue)
        
        self.init(red: Double(red) / 255.0, green: Double(green) / 255.0, blue: Double(blue) / 255.0, opacity: opacity)
    }
}
