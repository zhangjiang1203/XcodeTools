//
//  Navigator.swift
//  XcodeTools
//
//  Created by zhangjiang on 2023/7/28.
//

import Foundation
import AppKit

private let appBundleID = "com.zj.XcodeTools"

protocol Navigator {
    func navigate()
    
    var title: String { get }
    
    // 激活主App
    func launchMainAppIfNeeded(completion: @escaping () -> Void)
}


extension Navigator {
    //MARK: 激活主App 在主App中执行对应的逻辑
    func launchMainAppIfNeeded(completion: @escaping () -> Void) {
        
        let runningApps = NSWorkspace.shared.runningApplications
        if runningApps.contains(where: { $0.bundleIdentifier == appBundleID }) {
            completion()
            return
        }
        
        if #available(macOS 12, *) {
            guard let appURL = NSWorkspace.shared.urlForApplication(withBundleIdentifier: appBundleID) else {
                debugPrint("无法找到主 App 路径信息")
                return
            }
            let config = NSWorkspace.OpenConfiguration()
            config.activates = false // 后台启动，不激活窗口
            
            NSWorkspace.shared.open(appURL, configuration: config) { app, error in
                guard let _ = error else {
                    debugPrint("主App 打开失败")
                    return
                }
                completion()
            }
        } else {
            NSWorkspace.shared.launchApplication(withBundleIdentifier: appBundleID,
                                                 options: [.default],
                                                 additionalEventParamDescriptor: nil,
                                                 launchIdentifier: nil)
            completion()
        }
    }
}

