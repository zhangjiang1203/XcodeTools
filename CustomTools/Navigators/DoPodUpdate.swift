//
//  DoPodUpdate.swift
//  XcodeTools
//
//  Created by zhangjiang on 2023/7/28.
//

import Foundation

class DoPodUpdate: Navigator {
    var title: String {
        return "do pod update"
    }
    
    func navigate() {
        //执行脚本
        ScriptRunner.run("myPodUpdate")
    }
}
