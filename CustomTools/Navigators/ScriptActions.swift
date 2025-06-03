//
//  DoPodInstall.swift
//  XcodeTools
//
//  Created by zhangjiang on 2023/7/28.
//

import Foundation


struct DoPodInstall: Navigator {
    var title: String {
        return "do pod install"
    }
    
    func navigate() {
        //执行脚本
        CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(),
                                             ExtensionGlobalNotification.podInstallNoti.globalCFName,
                                             nil,
                                             nil,
                                             true)
    }
}

struct DoPodUpdate: Navigator {
    var title: String {
        return "do pod update"
    }
    
    func navigate() {
        //执行脚本
        ScriptRunner.run("myPodUpdate")
    }
}

//git操作
struct DoGitCommit: Navigator {
    var title: String {
        return "do git commit"
    }
    
    func navigate() {
        //执行脚本
        ScriptRunner.run("gitCommitFunc")
    }
}

struct DoGitPull: Navigator {
    var title: String {
        return "do git pull"
    }
    
    func navigate() {
        //执行脚本
        ScriptRunner.run("gitPullFunc")
    }
}

struct DoGitPush: Navigator {
    var title: String {
        return "do git push"
    }
    
    func navigate() {
        //执行脚本
        ScriptRunner.run("gitPushFunc")
    }
}


struct DoJSONToModel: Navigator {
    var title: String {
        return "json to model"
    }
    
    func navigate() {
        ScriptRunner.run("jsonToModelFunc")
    }
}

struct DoOpenInFinder: Navigator {
    var title: String {
        return "Open File in Finder"
    }
    
    func navigate() {
        //执行展示的命令
        ScriptRunner.run("myOpenCurrentFileInFinder")
    }
}

struct DoDenpencyCheck: Navigator {
    /// 获取当前python文件的路径，传递给AppleScript 执行对应脚本
    let path = Bundle.main.path(forResource: "dependency", ofType: "py")
    
    var title: String{
        return "check dependency"
    }
    
    func navigate() {
        //执行展示的命令
        if let pyPath = path {
            //设置参数
            ScriptRunner.run("checkDenpencyFunc", params: [pyPath])
        }
    }
}
