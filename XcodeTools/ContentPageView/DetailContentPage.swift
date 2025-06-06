//
//  DetailContentPage.swift
//  XcodeTools
//
//  Created by 张江 on 2024/3/1.
//

import Foundation
import SwiftUI

struct DetailContentPage: View {
    
    @State private var trimmedTo1: CGFloat = 1.0
    @State private var trimmedTo2: CGFloat = 2.0
    
    @State private var isHidden: Bool = false
    
    var body: some View {
        VStack{
            //设置名称和apiToken
            
            GeometryReader{ proxy in
                let min = min(proxy.size.width, proxy.size.height)
                ZStack{
                    Color.clear
                    MyCircle(trimmedTo1: trimmedTo1, trimmedTo2: trimmedTo2)
                        .fill(Color.red)
                        .padding()
                        .animation(.easeInOut(duration: 3), value: trimmedTo1)
                        .animation(.easeInOut(duration: 6), value: trimmedTo2)
                        .frame(width: min, height:min)
                    
                    MyCircle(trimmedTo1: trimmedTo1, trimmedTo2: trimmedTo2)
                        .fill(Color.red)
                        .opacity(0.5)
                        .padding()
                        .animation(.easeInOut(duration: 3), value: trimmedTo1)
                        .animation(.easeInOut(duration: 6), value: trimmedTo2)
                        .frame(width: min/2, height:min/2)
                        .rotationEffect(Angle(degrees: 90))
                }
            }
            
            //设置按钮
            Button{
                trimmedTo1 = isHidden ? 1.0 : 0.0
                trimmedTo2 = isHidden ? 2.0 : 0.0
                isHidden.toggle()
                // 执行完整流程
                fetchCrumb { crumb, cookieStorage in
                    if let crumb = crumb {
                        triggerBuild(crumb: crumb, cookieStorage: cookieStorage)
                    }
                }
            } label: {
                Text("Animation")
                    .padding()
                    .background(Color.white)
                    .foregroundStyle(.blue)
                    .clipShape(Capsule())
            }
            .buttonStyle(PlainButtonStyle())
            .padding()
        }
    }
    let username = "zhangjiang"
    let apiToken = "11226ccc10bb67621adabafb6d123fd839"
    // Jenkins 配置
    let jenkinsBaseURL = "http://10.209.192.28:8080"
    let jobName = "JACO-iOS"

    // 第一步：获取 crumb 和 cookie
    func fetchCrumb(completion: @escaping (String?, HTTPCookieStorage) -> Void) {
        let crumbURL = URL(string: "\(jenkinsBaseURL)/crumbIssuer/api/json")!
        var request = URLRequest(url: crumbURL)
        
        let loginString = "\(username):\(apiToken)"
        let base64Login = Data(loginString.utf8).base64EncodedString()
        request.setValue("Basic \(base64Login)", forHTTPHeaderField: "Authorization")
        
        let config = URLSessionConfiguration.default
        config.httpCookieStorage = HTTPCookieStorage.shared
        let session = URLSession(configuration: config)

        session.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("获取 crumb 失败: \(error?.localizedDescription ?? "未知错误")")
                completion(nil, HTTPCookieStorage.shared)
                return
            }
            
            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let crumb = json["crumb"] as? String {
                print("当前==crumb:\(crumb)")
                completion(crumb, HTTPCookieStorage.shared)
            } else {
                print("解析 crumb 失败")
                completion(nil, HTTPCookieStorage.shared)
            }
        }.resume()
    }

    // 第二步：带 crumb 发起构建
    func triggerBuild(crumb: String, cookieStorage: HTTPCookieStorage) {
        let buildURL = URL(string: "\(jenkinsBaseURL)/job/\(jobName)/buildWithParameters")!
        var request = URLRequest(url: buildURL)
        request.httpMethod = "POST"

        let loginString = "\(username):\(apiToken)"
        let base64Login = Data(loginString.utf8).base64EncodedString()
        request.setValue("Basic \(base64Login)", forHTTPHeaderField: "Authorization")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue(crumb, forHTTPHeaderField: "Jenkins-Crumb")

        // 请求参数
        let parameters = [
            "Branch": "origin/dev/share_screen",
            "OTA": "开发临时测试包12345",
            "Version": "3.5.0",
            "Name": "test",
            "iOSIPA": "ad-hoc",
            "syncToArab": "false"
        ]

        let body = parameters
            .map { "\($0)=\($1.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")" }
            .joined(separator: "&")

        request.httpBody = body.data(using: .utf8)

        let config = URLSessionConfiguration.default
        config.httpCookieStorage = cookieStorage
        let session = URLSession(configuration: config)
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("构建请求失败: \(error)")
            } else if let httpResponse = response as? HTTPURLResponse {
                print("状态码: \(httpResponse.statusCode)")
                if let data = data {
                    print("响应: \(String(data: data, encoding: .utf8) ?? "")")
                }
            }
        }.resume()
    }
}


extension DetailContentPage {
    struct MyCircle: Shape {
        
        var trimmedTo1: CGFloat
        var trimmedTo2: CGFloat
        
        var animatableData: AnimatablePair<CGFloat, CGFloat> {
            get{ AnimatablePair(trimmedTo1, trimmedTo2) }
            set{
                trimmedTo1 = newValue.first
                trimmedTo2 = newValue.second
            }
        }
        
        func path(in rect: CGRect) -> Path {
            var path = Path()
            
            //设置圆
            let center = CGPoint(x: rect.midX, y: rect.midY)
            let radius = rect.width / 2.0
            let start = Angle(radians: .pi * trimmedTo1 * 2)
            let end = Angle(radians: .pi * trimmedTo2 * 3)
            
            path.addArc(center: center, radius: radius, startAngle: start, endAngle: end, clockwise: false)
            
            return path
                .trimmedPath(from: 0.0, to: trimmedTo1)
                .trimmedPath(from: trimmedTo1, to: trimmedTo2)
                .strokedPath(.init(lineWidth: 6, lineCap: .round))
        }
    }
}
