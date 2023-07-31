//
//  Helper.swift
//  XcodeTools
//
//  Created by zhangjiang on 2023/7/28.
//

import Foundation

struct Helper {
    static func namespaceIdentifier(_ identifier: String) -> String {
        let bundleId = Bundle.main.bundleIdentifier ?? ""
        return "\(bundleId).\(identifier)"
            .replacingOccurrences(of: "+", with: "plus")
            .replacingOccurrences(of: " ", with: "-")
    }
}
