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
        //执行脚本语言
        if let navigator = MenuManager.find(invocation.commandIdentifier) {
            DispatchQueue.main.async {
                navigator.navigate()
            }
        }
        
        completionHandler(nil)
    }
    
}
