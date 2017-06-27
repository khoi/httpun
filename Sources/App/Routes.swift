import Vapor

extension Droplet {
    func setupRoutes() throws {

        get ("/") { req in
            try self.get("/index.html")
        }

        get("/ip") { req in
            try JSON(node: [
                "origin": req.peerHostname
                ])
        }

        get("/user-agent") { req in
            try JSON(node: [
                "user-agent": req.headers["User-Agent"]
                ])
        }

        get("/cookies") { req in
            try JSON(node: [
                "cookies": req.pun_cookies
                ])
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
