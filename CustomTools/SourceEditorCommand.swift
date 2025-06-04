//
//  SourceEditorCommand.swift
//  CustomTools
//
//  Created by zhangjiang on 2023/7/31.
//

import Foundation
import XcodeKit
import SwiftFormat

class SourceEditorCommand: NSObject, XCSourceEditorCommand {
    
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {
        let identifier = Helper.getIdentifier(invocation.commandIdentifier)
        if !identifier.isEmpty, let item = ExtensionGlobalNotification(rawValue: identifier) {
            //执行对应逻辑
            if item == .formatSwiftCode {
                formatSwiftCode(invocation)
            } else {
                item.launchMainAppIfNeeded {
                    item.navigate()
                }
            }
        }
        completionHandler(nil)
    }
    
    //MARK: 格式化代码
    private func formatSwiftCode(_ invocation: XCSourceEditorCommandInvocation) {
        // Grab the file source to format
        let sourceToFormat = invocation.buffer.completeBuffer
        let input = tokenize(sourceToFormat)

        // 禁用自动移除 self 的规则
        let rules = FormatRules.default.filter { $0.description != "redundantSelf" }

        // Get options
        var formatOptions = FormatOptions()
        formatOptions.indent = "    "
        formatOptions.tabWidth = invocation.buffer.tabWidth
        formatOptions.swiftVersion = "5.9"
        formatOptions.lineAfterMarks = false
        //不插入 不移除空行 不改变原有结构
        formatOptions.insertBlankLines = false
        formatOptions.removeBlankLines = false
        formatOptions.truncateBlankLines = false
        
        if formatOptions.requiresFileInfo {
           formatOptions.fileHeader = .ignore
        }

        let output: [Token]
        do {
           output = try format(input, rules: rules, options: formatOptions).tokens
        } catch {
           debugPrint("当前类型==\(error.localizedDescription)")
           return
        }
        
        if output == input {
           return
        }
        // 移除之前的buffer
        invocation.buffer.selections.removeAllObjects()
        // 更新buffer
        invocation.buffer.completeBuffer = sourceCode(for: output)
    }
}
