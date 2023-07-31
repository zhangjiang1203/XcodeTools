//
//  OpenDialog.swift
//  XcodeTools
//
//  Created by zhangjiang on 2023/7/28.
//

import Foundation

class OpenDialog: Navigator {
    var title: String {
        return "open Dialog"
    }
    
    func navigate() {
        ScriptRunner.run("openDialog")
    }
}
