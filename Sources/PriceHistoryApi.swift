//
//  PriceHistoryApi.swift
//  EnglishFriend
//
//  Created by 一智 on 2018/6/12.
//

import PerfectHTTP
import PerfectHTTPServer
import PerfectLib

struct PriceHistoryApi {
    var routes: Routes = Routes(baseUri: "/phapi/v1")
    init() {
        routes.add(uri: "keyword") { (req, res) in
            do {
                let json = try ["version": 1, "keyword": "abc"].jsonEncodedString()
                res.appendBody(string: json)
                res.setHeader(.contentType, value: "application/json")
            } catch {
                res.status = .internalServerError
                res.setBody(string: "请求处理出现错误：\(error)")
            }
            res.completed()
        }
    }
}

