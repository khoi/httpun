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
    var pun_cookies: [String: String] {
        return cookies.reduce([:]) { (acc, next) -> [String: String] in
            var dict = acc
            dict[next.name] = next.value
            return dict
        }
    }

    var pun_headers: [String: String] {
        return headers.reduce([:]) { (acc, next) -> [String: String] in
            var dict = acc
            dict[next.key.key] = next.value
            return dict
        }
    }
}

