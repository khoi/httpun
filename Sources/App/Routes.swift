import Vapor
import Cookies
import HTTP
import Multipart

extension Droplet {
    func setupRoutes() throws {

        let helper = PunHelper()

        get ("/") { req in
            try self.get("/index.html")
        }

        get("/ip") { req in
            try helper.getResponseDict(of: req, for: [.origin])
        }

        get("/headers") { req in
            try helper.getResponseDict(of: req, for: [.headers])
        }

        get("/user-agent") { req in
            try helper.getResponseDict(of: req, for: [.useragent])
        }

        get("/get") { req in
            try helper.getResponseDict(of: req, for: [.headers, .origin, .args])
        }

        post("/post") { req in
            try helper.getResponseDict(of: req, for: [.headers, .origin, .args, .form, .files, .json, .data])
        }

        patch("/patch") { req in
            try helper.getResponseDict(of: req, for: [.headers, .origin, .args, .form, .files, .json, .data])
        }

        put("/put") { req in
            try helper.getResponseDict(of: req, for: [.headers, .origin, .args, .form, .files, .json, .data])
        }

        delete("/delete") { req in
            try helper.getResponseDict(of: req, for: [.headers, .origin, .args, .form, .files, .json, .data])
        }

        get("/cookies") { req in
            try helper.getResponseDict(of: req, for: [.cookies])
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
