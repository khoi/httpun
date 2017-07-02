//
//  PunHelper.swift
//  httpun
//
//  Created by Khoi Lai on 7/2/17.
//
//
import Foundation
import Vapor
import HTTP

class PunHelper {
    func getResponseDict(of req: Request,for keys: [ResponseKeys], prettify: Bool = true) throws -> Response {
        var json = JSON()

        try keys.forEach { (key) in
            switch key {
            case .headers:
                try json.set(key.rawValue, req.pun_headers)
            case .origin:
                try json.set(key.rawValue, req.peerHostname)
            case .args:
                try json.set(key.rawValue, req.pun_args)
            case .form:
                try json.set(key.rawValue, req.pun_postForms)
            case .files:
                try json.set(key.rawValue, req.pun_postFiles)
            case .json:
                try json.set(key.rawValue, req.json)
            case .data:
                try json.set(key.rawValue, req.body.bytes?.makeString())
            case .useragent:
                try json.set(key.rawValue, req.headers[HeaderKey.userAgent])
            case .cookies:
                try json.set(key.rawValue, req.pun_cookies)
            }
        }

        return try json.toResponse(prettify: prettify)
    }
}
