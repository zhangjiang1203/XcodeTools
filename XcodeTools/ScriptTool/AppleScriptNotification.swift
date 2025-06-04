//
//  AppleScriptNotification.swift
//  XcodeTools
//
//  Created by 张江 on 2025/6/3.
//

import Foundation

struct ExtensionNotificationConst {
    
    static let extensionGlobalNotificationCallBack: CFNotificationCallback = { (center, observer, name, object, userInfo) in
        //根据通知类型，对符合的Notification进行转发
        debugPrint("收到通知111====\(String(describing: name?.rawValue))")
        guard let nameStr = name?.rawValue as? String else { return }
        let itemName = nameStr.replacingOccurrences(of: "global.", with: "")
        guard let item = ExtensionGlobalNotification(rawValue: itemName) else {
            debugPrint("收到通知222====\(itemName)对应枚举不存在")
            return
        }
        
        //发送通知
        NotificationCenter.default.post(name: item.name, object: nil)
    }
    
}


// 跨进程通知
enum ExtensionGlobalNotification: String , CaseIterable{
    
    /// pod install
    case podInstallNoti = "com.zj.pro.podInstall"
    case podUpdateNoti = "com.zj.pro.podUpdate"
    case openInFinderNoti = "com.zj.pro.openInFinder"
    case doArchiveNoti = "com.zj.pro.doArchive"
    case cleanDerivedData = "com.zj.pro.cleanDerivedData"
    case formatSwiftCode = "com.zj.pro.formatSwiftCode"
    
    // 枚举标题， 菜单栏上展示的标题
    var menuTitle: String {
        switch self {
        case .podInstallNoti:
            return "pod install"
        case .podUpdateNoti:
            return "pod update"
        case .openInFinderNoti:
            return "open in Finder"
        case .doArchiveNoti:
            return "Archive with jenkins"
        case .cleanDerivedData:
            return "clean derived data"
        case .formatSwiftCode:
            return "format swift code"
        }
    }
    
    
    // 通知名称
    var name: Notification.Name {
        return Notification.Name(self.rawValue)
    }
        
    //MARK: 跨进程使用的通知
    var globalCFName: CFNotificationName {
        return CFNotificationName(("global." + self.rawValue) as CFString)
    }
    
    func globalCFString() -> CFString {
        return (("global." + self.rawValue) as CFString)
    }
}

extension ExtensionGlobalNotification: Navigator {
    //执行具体逻辑
    var title: String {
        return self.menuTitle
    }
    
    //发送通知
    //执行脚本
    func navigate() {
        launchMainAppIfNeeded {
            CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(),
                                                 self.globalCFName,
                                                 nil,
                                                 nil,
                                                 true)
        }
    }
}
