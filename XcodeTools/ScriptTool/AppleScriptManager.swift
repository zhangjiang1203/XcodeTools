//
//  AppleScriptManager.swift
//  XcodeTools
//
//  Created by 张江 on 2025/6/3.
//

import Foundation
/**
 使用方案
 由于在Extension中无法直接使用AppleScript执行任务，在Extension中通过唤醒主App，让主App来执行对应的任务
 
 Extension中
 
 设置Xcode编辑菜单 -> 点击菜单唤醒主App -> 执行对应的AppleScript事件
 
 上述中的逻辑是通过通知的形式来进行的，主App和Extension中通过CFNotiificationCenter 跨进程通讯，将Extension执行的事件分发到主App，主App根据notification 再进行下发
 */

class AppleScriptManager {
    static let `default` = AppleScriptManager()
    
    private init() {
        //注册事件
        ExtensionGlobalNotification.allCases.forEach { item in
            //添加跨进程通知
            CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                            nil,
                                            ExtensionNotificationConst.extensionGlobalNotificationCallBack,
                                            item.globalCFString(),
                                            nil,
                                            .deliverImmediately)
            //注册本地通知，
            NotificationCenter.default.addObserver(forName: item.name, object: nil, queue: .main) {[weak self] noti in
                debugPrint("开始执行事件 \(noti.name.rawValue)")
                guard let self = self else { return }
                self.notificationEventHandOut(noti: noti)
            }
        }
    }
}

//MARK: 各个Extension事件执行的代码
extension AppleScriptManager {
    func notificationEventHandOut(noti: Notification) {
        if let item = ExtensionGlobalNotification(rawValue: noti.name.rawValue) {
            switch item {
            case .podInstallNoti:
                AppleScriptAction.podInstall()
            case .podUpdateNoti:
                AppleScriptAction.podUpdate()
            case .openInFinderNoti:
                AppleScriptAction.showInFinder()
            case .doArchiveNoti:
                debugPrint("开始打包")
            case .cleanDerivedData:
                debugPrint("开始清理")
            }
        }
    }
    
    
}
