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

class Helper {
    func getRedirectResponse(path: String, status: Status) -> Response {
        let res = Response(status: status, headers: ["Location": path])
        return res
    }

    func getResponseJSON(of req: Request,for keys: [ResponseKeys], prettify: Bool = true) throws -> JSON {
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
            case .url:
                try json.set(key.rawValue, req.uri.makeFoundationURL().absoluteString)
            }
        }

        return json
    }

    func getResponse(for status: Status) throws -> Response {
        switch status.statusCode {
        case 0...100:
            return try getResponse(for: Status(statusCode: 400))
        case 301, 302, 303, 304, 305, 307:
            return getRedirectResponse(path: "/redirect/1", status: status)
        case 401:
            return Response(status: status, headers: [
                "WWW-Authenticate": "Basic realm=\"Fake Realm\""
                ])
        case 402:
            return Response(status: status, headers: [
                "x-more-info": "http://vimeo.com/22053820"
                ], body: "Fuck you, pay me!")
        case 406:
            let json = JSON([
                "message": "Client did not request a supported media type.",
                "accept": [
                    "image/webp",
                    "image/svg+xml",
                    "image/jpeg",
                    "image/png",
                    "image/*",
                ]
                ])
            return try Response(status: status, json: json)
        case 407:
            return Response(status: status, headers: [
                "Proxy-Authenticate": "Basic realm=\"Fake Realm\""
                ])
        case 418:
            return Response(status: status, headers: [
                "x-more-info": "http://tools.ietf.org/html/rfc2324"
                ], body: ASCIIArt.teaPot)
        default:
            return Response(status: status)
        }
    }
}
