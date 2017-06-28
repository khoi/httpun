import Vapor

extension Droplet {
    func setupRoutes() throws {

        get ("/") { req in
            try self.get("/index.html")
        }

        get("/ip") { req in
            try JSON(node: [
                "origin": req.peerHostname
                ]).pretifyResponse()
        }

        get("/headers") { req in
            try JSON(node: [
                "headers": req.pun_headers
                ]).pretifyResponse()
        }

        get("/user-agent") { req in
            try JSON(node: [
                "user-agent": req.headers["User-Agent"]
                ]).pretifyResponse()
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

    }
}
