//
//  Request+httpun.swift
//  httpun
//
//  Created by Khoi Lai on 6/27/17.
//
//

import Vapor

extension Request {
    var pun_cookies: [String: String] {
        return self.cookies.reduce([:]) { (acc, next) -> [String: String] in
            var dict = acc
            dict[next.name] = next.value
            return dict
        }
    }

}
