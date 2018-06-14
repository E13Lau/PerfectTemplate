//
//  WebApi.swift
//  EnglishFriend
//
//  Created by 一智 on 2018/6/12.
//

import PerfectHTTP
import PerfectHTTPServer
import PerfectLib
import PerfectCSQLite3
import PerfectSQLite
import PerfectCRUD

fileprivate extension String {
    static let word = "/word"
    static let audio = "/audio"
    static let video = "/video"
}

struct WordApi {
    var routes: Routes = Routes(baseUri: "/wordapi/v1")
    init() {
        routes.add(uri: .word) { (req, res) in
            let start = req.param(name: "start") ?? "0"
            let end = req.param(name: "end") ?? "100"
            var array = [String]()
            
            do {
                let sqlite = try SQLite(dbPath)
                defer {
                    sqlite.close()
                }
                try sqlite.forEachRow(statement: "select * from baseword where id <= '\(end)' and id > '\(start)'", handleRow: { (stmt, i) in
                    array.append(stmt.columnText(position: 1))
                })
                let json = try array.jsonEncodedString()
                
                res.setHeader(.contentType, value: "application/json")
                res.appendBody(string: json)
            } catch {
                res.status = .internalServerError
                res.setBody(string: "请求处理出现错误：\(error)")
            }
            res.completed()
        }
    }
}
