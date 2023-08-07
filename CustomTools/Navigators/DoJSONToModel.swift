//
//  DoJSONToModel.swift
//  XcodeTools
//
//  Created by zhangjiang on 2023/7/28.
//

import Foundation

class DoJSONToModel: Navigator {
    var title: String {
        return "json to model"
    }
    
    func navigate() {
        ScriptRunner.run("jsonToModelFunc")
    }
}
