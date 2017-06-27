import Vapor

extension Droplet {
    func setupRoutes() throws {

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
        
    }
}
