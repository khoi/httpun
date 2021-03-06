//
//  JSON+httpun.swift
//  httpun
//
//  Created by Khoi Lai on 6/27/17.
//
//

import JSON
import HTTP

extension JSON {
    public func toResponse(prettify: Bool) throws -> Response {
        return Response(status: .ok,
                        headers: ["Content-Type": "application/json; charset=utf-8"],
                        body: Body(try serialize(prettyPrint: prettify)))
    }
}
