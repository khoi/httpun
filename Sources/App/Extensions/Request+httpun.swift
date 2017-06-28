//
//  Request+httpun.swift
//  httpun
//
//  Created by Khoi Lai on 6/27/17.
//
//

import Vapor
import HTTP

extension Request {
    var pun_cookies: JSON {
        var json = JSON()
        cookies.forEach { (c) in
            try? json.set(c.name, c.value)
        }
        return json
    }

    var pun_queries: JSON {
        return query?.converted(to: JSON.self) ?? JSON()
    }

    var pun_headers: JSON {
        var json = JSON()
        headers.forEach { (headerKey, value) in
            try? json.set(headerKey.key, value)
        }
        return json
       
    }
}

