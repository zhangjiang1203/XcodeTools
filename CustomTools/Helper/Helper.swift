//
//  Helper.swift
//  XcodeTools
//
//  Created by zhangjiang on 2023/7/28.
//

import Foundation

struct Helper {
    // 设置identifier， extension editor中 支持持字母 数字 . 的组合
    static func namespaceIdentifier(_ identifier: String) -> String {
        let bundleId = Bundle.main.bundleIdentifier ?? ""
        return "\(bundleId)---\(identifier)"
            .replacingOccurrences(of: "+", with: "plus")
            .replacingOccurrences(of: " ", with: "-")
    }
    
    static func getIdentifier(_ commandIdentifier: String) -> String {
        let commandStr = commandIdentifier
        return String(commandStr.split(separator: "---").last ?? "")
    }
}
