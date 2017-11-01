import Vapor
import Cookies
import HTTP
import Multipart


extension Droplet {
    func setupRoutes() throws {

        let helper = Helper()

        get ("/") { req in
            try view.make("index")
        }

        get("/ip") { req in
            try helper
                .getResponseJSON(of: req, for: [.origin])
                .toResponse(prettify: true)
        }

        get("/headers") { req in
            try helper
                .getResponseJSON(of: req, for: [.headers])
                .toResponse(prettify: true)
        }

        get("/user-agent") { req in
            try helper
                .getResponseJSON(of: req, for: [.useragent])
                .toResponse(prettify: true)
        }

        get("/get") { req in
            try helper
                .getResponseJSON(of: req, for: [.headers, .origin, .args, .url])
                .toResponse(prettify: true)
        }

        post("/post") { req in
            try helper
                .getResponseJSON(of: req, for: [.headers, .origin, .args, .form, .files, .json, .data, .url])
                .toResponse(prettify: true)
        }

        patch("/patch") { req in
            try helper
                .getResponseJSON(of: req, for: [.headers, .origin, .args, .form, .files, .json, .data, .url])
                .toResponse(prettify: true)
        }

        put("/put") { req in
            try helper
                .getResponseJSON(of: req, for: [.headers, .origin, .args, .form, .files, .json, .data, .url])
                .toResponse(prettify: true)
        }

        delete("/delete") { req in
            try helper
                .getResponseJSON(of: req, for: [.headers, .origin, .args, .form, .files, .json, .data, .url])
                .toResponse(prettify: true)
        }

        get("/cookies") { req in
            try helper
                .getResponseJSON(of: req, for: [.cookies])
                .toResponse(prettify: true)
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

        all("/status", String.parameter) { req in
            guard let codeString = try? req.parameters.next(String.self),
                    let code = Int(codeString), code > 100 else {
                return try helper.getResponse(statusCode: 400)
            }
            return try helper.getResponse(statusCode: code)
        }

        all("/anything", "*") { req in
            var json = try helper
                .getResponseJSON(of: req, for: [.headers, .origin, .args, .form, .files, .json, .data, .url])
            try json.set("method", req.method.description)
            return try json.toResponse(prettify: true)
        }

        get("/deny") { req in
            ASCIIArt.flippingTheTable.makeResponse()
        }

        get("/redirect", Int.parameter) { req in
            guard let times = try? req.parameters.next(Int.self), times > 1 else {
                return helper.getRedirectResponse(path: "/get", status: .found)
            }
            return helper.getRedirectResponse(path: "/redirect/\(times - 1)", status: .found)
        }

        get("/redirect-to") { req in
            let url = req.query?["url"]?.string ?? "/get"
            let statusCode = req.query?["status_code"]?.int ?? Status.found.statusCode
            return helper.getRedirectResponse(path: url, status: Status(statusCode: statusCode))
        }
    }
}
