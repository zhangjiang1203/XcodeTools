//
//  SourceEditorCommand.swift
//  CustomTools
//
//  Created by zhangjiang on 2023/7/31.
//

import Foundation
import XcodeKit

class SourceEditorCommand: NSObject, XCSourceEditorCommand {
    
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {
        debugPrint("开始执行22===\(invocation.commandIdentifier)")
        let identifier = Helper.getIdentifier(invocation.commandIdentifier)
        if !identifier.isEmpty, let item = ExtensionGlobalNotification(rawValue: identifier) {
            //执行对应逻辑
            debugPrint("开始执行11===\(item.rawValue)")
            item.launchMainAppIfNeeded {
                item.navigate()
            }
        }
        
        completionHandler(nil)
    }
    
}
