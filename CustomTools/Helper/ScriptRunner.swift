//
//  ScriptRunner.swift
//  XcodeTools
//
//  Created by zhangjiang on 2023/7/28.
//

import Foundation
import AppKit
import Carbon

struct ScriptRunner {
    /// 脚本描述
    static func eventDescriptior(_ functionName: String) -> NSAppleEventDescriptor {
        var psn = ProcessSerialNumber(highLongOfPSN: 0, lowLongOfPSN: UInt32(kCurrentProcess))
        let target = NSAppleEventDescriptor(
            descriptorType: typeProcessSerialNumber,
            bytes: &psn,
            length: MemoryLayout<ProcessSerialNumber>.size
        )
        
        let event = NSAppleEventDescriptor(
            eventClass: UInt32(kASAppleScriptSuite),
            eventID: UInt32(kASSubroutineEvent),
            targetDescriptor: target,
            returnID: Int16(kAutoGenerateReturnID),
            transactionID: Int32(kAnyTransactionID)
        )
        
        let function = NSAppleEventDescriptor(string: functionName)
        event.setParam(function, forKeyword: AEKeyword(keyASSubroutineName))
        
        return event
    }
    
    /// 执行脚本
    static func run(_ funcation: String)  {
        guard let filePath = InstallScript.fileScriptPath("XcodeToolScript") else {
            print("文件不存在")
            return
        }
        
        guard FileManager.default.fileExists(atPath: filePath.path) else {
            print("文件不存在")
            return
        }
        
        /// 找到脚本文件
        guard let script = try? NSUserAppleScriptTask(url: filePath) else {
            print("解析脚本文件出错")
            return
        }
        
        let event = eventDescriptior(funcation)
        script.execute(withAppleEvent: event) { script, error in
            if let error = error {
                print("脚本执行失败===\(error),script:\(String(describing: script))")
            }
        }
    }
    
}
