//
//  JSON_httpun.swift
//  httpun
//
//  Created by Khoi Lai on 6/27/17.
//
//

import JSON
import HTTP

extension JSON {
    public func pretifyResponse() throws -> Response {
        return Response(status: .ok, body: Body(try self.serialize(prettyPrint: true)))
    }
}
