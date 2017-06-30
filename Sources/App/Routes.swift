import Vapor
import Cookies
import HTTP

extension Droplet {
    func setupRoutes() throws {

        get ("/") { req in
            try self.get("/index.html")
        }

        get("/ip") { req in
            try JSON(node: [
                ResponseKeys.origin.rawValue: req.peerHostname
                ]).pretifyResponse()
        }

        get("/headers") { req in

            try JSON(node: [
                ResponseKeys.headers.rawValue: req.pun_headers
                ]).pretifyResponse()
        }

        get("/user-agent") { req in
            try JSON(node: [
                ResponseKeys.useragent.rawValue: req.headers[HeaderKey.userAgent]
                ]).pretifyResponse()
        }

        get("/get") { req in
            var json = JSON()
            try json.set(ResponseKeys.headers.rawValue, req.pun_headers)
            try json.set(ResponseKeys.origin.rawValue, req.peerHostname)
            try json.set(ResponseKeys.args.rawValue, req.pun_args)
            return try json.pretifyResponse()
        }

        get("/cookies") { req in
            try JSON(node: [
                "cookies": req.pun_cookies
                ]).pretifyResponse()
        }

        get("/cookies/set") { req in
            let res = Response(redirect: "/cookies")
            req.query?.object?.forEach{ (key, val) in
                res.cookies[key] = val.string
            }
            return res
        }

        get("/cookies/delete") { req in
            let res = Response(redirect: "/cookies")
            
            req.query?.object?.forEach { (key, val) in
                res.cookies.insert(
                    Cookie(name: key,
                           value: "",
                           expires: Date(timeIntervalSince1970: 0),
                           maxAge: 0)
                )
            }

            return res
        }

    }
}
