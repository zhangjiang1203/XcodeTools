//
//  SourceEditorExtension.swift
//  CustomTools
//
//  Created by zhangjiang on 2023/7/31.
//

import Foundation
import XcodeKit

class SourceEditorExtension: NSObject, XCSourceEditorExtension {
    
    func extensionDidFinishLaunching() {
        // If your extension needs to do any work at launch, implement this optional method.
        // 写入脚本文件
        DispatchQueue.main.async {
            InstallScript.installScriptFile()
        }
    }
        
    /// 执行的方法集合 也可以在 info.plist中定义
    var commandDefinitions: [[XCSourceEditorCommandDefinitionKey: Any]] {
        return MenuManager.navigators.map { navigator in
            return[
                XCSourceEditorCommandDefinitionKey.nameKey: navigator.title,
                XCSourceEditorCommandDefinitionKey.classNameKey: SourceEditorCommand.className(),
                XCSourceEditorCommandDefinitionKey.identifierKey: Helper.namespaceIdentifier(navigator.title)
            ]
        }
    }
    
}
