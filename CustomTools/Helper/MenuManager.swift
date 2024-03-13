//
//  MenuManager.swift
//  XcodeTools
//
//  Created by zhangjiang on 2023/7/28.
//

import Foundation

struct MenuManager {
    /// 构建静态数组
    static let navigators: [Navigator] = [
        DoPodInstall(),
        DoPodUpdate(),
        DoGitCommit(),
        DoGitPull(),
        DoGitPush(),
        DoJSONToModel(),
        DoDenpencyCheck(),
        DoOpenInFinder()
    ]
    
    static func find(_ commandIdentifier: String) -> Navigator? {
        for navigator in navigators {
            if Helper.namespaceIdentifier(navigator.title) == commandIdentifier {
                return navigator
            }
        }
        return nil
    }
}
