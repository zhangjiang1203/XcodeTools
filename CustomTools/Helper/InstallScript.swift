//
//  InstallScript.swift
//  XcodeTools
//
//  Created by zhangjiang on 2023/7/28.
//


import Foundation
import AppKit
import Carbon

let kAppVersion = "kAppVersion"

struct InstallScript {
    /// 脚本所在的目录
    static var scriptPath: URL? {
        return try? FileManager.default.url(
            for: .applicationScriptsDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        )
    }
    
    static func fileScriptPath(_ fileName: String) -> URL? {
        print("all data \(String(describing: Bundle.main.infoDictionary))")
        //获取当前版本号，文件名用当前版本号做一个更新，每一个版本对应一个apple script文件
        if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            return scriptPath?
                .appendingPathComponent(fileName + "-" + appVersion)
                .appendingPathExtension("scpt")
        }
        return scriptPath?
            .appendingPathComponent(fileName)
            .appendingPathExtension("scpt")
        
    }
    
    /// 写入文件
    static func installScriptFile() {
        //查找对应的数据
        guard let filePath = fileScriptPath("XcodeToolScript") else {
            return
        }
        print("文件路径已存在:\(filePath)")
        //将文件 移动到 script 目录下
        if !FileManager.default.fileExists(atPath: filePath.path) {
            /// 要在主线程执行
            let panel = NSSavePanel()
            panel.title = "保存脚本文件"
            panel.message = "请保存AppleScript文件至Application Scripts目录才可使用"
            panel.nameFieldStringValue = filePath.lastPathComponent
            panel.directoryURL = scriptPath
            panel.canCreateDirectories = false
            
            if panel.runModal() == .OK {
                if let url = panel.url {
                    if let path = Bundle.main.url(forResource: "XcodeToolScript", withExtension: "scpt") {
                        do {
                            let data = try Data(contentsOf: path)
                            try data.write(to: url)
                        } catch {
                            panel.cancel(nil)
                            installScriptFile()
                        }
                    }
                }
            }
            panel.cancel(nil)
            installScriptFile()
        }
        
    }
}
