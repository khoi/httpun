import Vapor

extension Droplet {
    func setupRoutes() throws {

        get ("/") { req in
            try self.get("/index.html")
        }

        get("/ip") { req in
            var json = JSON()
            try json.set("origin", req.peerHostname)
            return json
        }

        get("/user-agent") { req in
            var json = JSON()
            try json.set("user-agent", req.headers["User-Agent"])
            return json
        }

        get("/cookies") { req in
            var json = JSON()

            let cookies = req.cookies.reduce([:]) { (acc, next) -> [String: String] in
                var dict = acc
                dict[next.name] = next.value
                return dict
            }

            try json.set("cookies", cookies)
            return json
        }
    }
}
