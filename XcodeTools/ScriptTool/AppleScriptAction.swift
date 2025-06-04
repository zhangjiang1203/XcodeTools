//
//  AppleScriptAction.swift
//  CustomTools
//
//  Created by 张江 on 2025/5/30.
//

import Cocoa
import Foundation

enum AppleScriptAction {
    @discardableResult
    static func executeAppleScript(_ script: String) -> String? {
        var error: NSDictionary?
        if let appleScript = NSAppleScript(source: script) {
            let output = appleScript.executeAndReturnError(&error)
            if let error {
                debugPrint("脚本执行失败 error:\(error.description)")
                return "脚本执行失败 error:\(error.description)"
            } else {
                debugPrint("脚本执行信息=\(output.stringValue ?? "")")
                return output.stringValue
            }
        }
        return ""
    }
}

extension AppleScriptAction {
    static func showInFinder() {
        // 获取当前文件的路径信息
        guard let currentFilePath = getCurrentFilePath(), let url = URL(string: currentFilePath) else {
            // 移除最后一个文件路径
            return
        }
        
        let filePath = url.path()
        let script = """
            set myPath to "\(filePath)"
            set finderPath to myPath
            set filePath to POSIX file myPath
        
            tell application "System Events"
                set theItem to disk item myPath
        
                if class of theItem is folder then
                    #这是一个文件夹 直接打开
                    tell application "Finder"
                        activate
                        open myPath as POSIX file
                    end tell
                else if class of theItem is file then
        
                    tell application "Finder"
                        activate
                        open finderPath as POSIX file
                        #选中指定文件
                        reveal filePath
                        activate
                    end tell
                else
                    display dialog "这是其他类型的项目"
                end if
            end tell
        """
        
        executeAppleScript(script)
    }
    
    /// 打开终端
    static func openTerminal(_ path: String, order: [String]? = nil) {
        var orders = [String]()
        orders.append("cd \(path.path())")
        
        if let order {
            orders.append(contentsOf: order)
        }
        /// 拼接命令
        let appleScriptCommand = orders.map { "\"\($0)\"" }.joined(separator: ", ")
        // 默认使用系统终端 如果安装了iterm 直接使用iterm
        var script = """
            tell application "System Events"
                tell application "Terminal"
                    if not (exists window 1) then reopen
                    activate
                    repeat with order in {\(appleScriptCommand)}
                        do script order in window 1
                    end repeat
                end tell
            end tell
        """
        /// 使用那个终端执行命令
        if isAppInstalled(bundleIdentifier: "com.googlecode.iterm2") {
            script = """
                tell application "System Events"
                    tell application "iTerm"
                        # 创建过窗口 直接打开 之前order 没有直接创建窗口
                        if (exists current window) then
                            activate
                            set newWindow to current window
                        else
                            try
                                set newWindow to (create window with default profile)
                            on error
                                tell current window
                                    create tab with default profile
                                end tell
                                set newWindow to current window
                            end try
            
                        end if
                        tell newWindow
                            tell current session
                                -- 循环执行命令
                                repeat with order in {\(appleScriptCommand)}
                                    write text order
                                end repeat
                            end tell
                        end tell
                    end tell
                end tell
            """
        }
    
        executeAppleScript(script)
    }
    
    /// 根据名称判断是否安装某个app (不太准确)
    private static func isAppInstalled(appName: String) -> Bool {
        let fileMananger = FileManager.default
        return fileMananger.fileExists(atPath: "/Applications/\(appName).app")
    }
    
    /// 根据bundleId 判断是否安装某个App
    private static func isAppInstalled(bundleIdentifier: String) -> Bool {
        if let _ = NSWorkspace.shared.urlForApplication(withBundleIdentifier: bundleIdentifier) {
            return true
        }
        return false
    }
}

// MARK: 具体执行动作

extension AppleScriptAction {
    /// pod install
    static func podInstall() {
        guard let path = getXcodeProjectDirectory() else { return }
        openTerminal(path, order: ["pod install"])
    }
    
    static func podUpdate() {
        guard let path = getXcodeProjectDirectory() else { return }
        openTerminal(path, order: ["pod update"])
    }
    
    /// 获取当前活跃的 Xcode 项目路径（上级目录）
    static func getXcodeProjectDirectory() -> String? {
        let script = """
            tell application "Xcode"
                try
                    set docPath to path of document 1
                    return docPath
                on error
                    return "没有路径信息"
                end try
            end tell
        """
        if let proPath = executeAppleScript(script), let url = URL(string: proPath) {
            // 移除最后一个文件路径
            return url.deletingLastPathComponent().path()
        }
        return nil
    }
    
    static func getCurrentFilePath() -> String? {
        let script = """
                    tell application "Xcode"
                        set activeDocument to document 1 whose name ends with (word -1 of (get name of window 1))
                        path of activeDocument
                    end tell
        """
        return executeAppleScript(script)
    }
    
    static func swiftFormatCode() {
        let script = """
            tell application "Xcode"
                set frontWindow to the first window
                set myPath to path of document of frontWindow
                do shell script "cd " & myPath & ";cd ..; /usr/local/bin/swiftformat ."
            end tell
        """
        executeAppleScript(script)
    }
    
    // 获取当前工程路径
//    static func getProjectPath() -> String {
//        let script = """
//            tell application "Xcode"
//                tell active workspace document
//                    set myPath to path
//                end tell
//            end tell
//        """
//
//        let script = """
//            tell application "Xcode"
//                try
//                    set docPath to path of document 1
//                    return docPath
//                on error
//                    return "没有路径信息"
//                end try
//            end tell
//
//                tell active workspace document
//                    set myPath to path
//                end tell
//        """
//
    ////        let script = """
    ////            set answer to the text returned of (display dialog "输入要解析模型的地址" default answer "" buttons {"确认", "取消"} default button 1 with icon note)
    ////            """
//
//        return executeAppleScript(script)
//    }
}
