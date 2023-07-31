//
//  DoPodInstall.swift
//  XcodeTools
//
//  Created by zhangjiang on 2023/7/28.
//

import Foundation

class DoPodInstall: Navigator {
    var title: String {
        return "do pod install"
    }
    
    func navigate() {
        //执行脚本
        ScriptRunner.run("myPodInstall")
    }
}
