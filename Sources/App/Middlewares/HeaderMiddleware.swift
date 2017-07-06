//
//  HeaderMiddleware.swift
//  httpun
//
//  Created by Khoi Lai on 7/6/17.
//
//

import Vapor

final class HeaderMiddleware: Middleware {
    func respond(to request: Request, chainingTo next: Responder) throws -> Response {
        let response = try next.respond(to: request)
        response.headers["Access-Control-Allow-Origin"] = "*"
        response.headers["Access-Control-Allow-Credentials"] = "true"
        return response
    }
}
