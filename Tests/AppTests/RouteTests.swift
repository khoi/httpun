import XCTest
import Foundation
import Testing
import HTTP

@testable import Vapor
@testable import App

class RouteTests: TestCase {
    let drop = try! Droplet.testable()

    func testIndex() throws {
        try drop
            .testResponse(to: .get, at: "/")
            .assertStatus(is: .ok)
    }

    func testUserAgent() throws {
        try drop
            .testResponse(to: .get, at: "user-agent", headers: ["User-Agent": "test"])
            .assertStatus(is: .ok)
            .assertJSON("user-agent", equals: "test")
    }

    func testIp() throws {
        try drop
            .testResponse(to: .get, at: "ip", headers: ["X-Forwarded-For": "5.6.7.8"])
            .assertStatus(is: .ok)
            .assertJSON("origin", equals: "5.6.7.8")
    }

    func testCookies() throws {
        try drop
            .testResponse(to: .get, at: "cookies")
            .assertStatus(is: .ok)
            .assertJSON("cookies", equals: [String:String]())

        // Should returns an empty dict if no cookies are set
        try drop
            .testResponse(to: .get, at: "cookies")
            .assertStatus(is: .ok)
            .assertJSON("cookies", equals: [String:String]())

        try drop
            .testResponse(to: .get, at: "cookies", headers: ["Cookie": "test1=value1;test2=value2;test3="])
            .assertStatus(is: .ok)
            .assertJSON("cookies", passes: { (json) -> (Bool) in
                json["test1"] == "value1" &&
                json["test2"] == "value2" &&
                json["test3"] == ""
            })
    }

    func testSetCookies() throws{

        let request = Request.makeTest(method: .get, path: "cookies/set", query: "k1=v1&k2=v2")

        try drop
            .testResponse(to: request)
            .assertStatus(is: .seeOther)
            .assertHeader("Set-Cookie", contains: "k1=v1")
            .assertHeader("Set-Cookie", contains: "k2=v2")
    }

    func testDeleteCookies() throws{

        let request = Request.makeTest(method: .get, path: "cookies/delete", query: "k1=&k2=")

        try drop
            .testResponse(to: request)
            .assertStatus(is: .seeOther)
            .assertHeader("Set-Cookie", contains: "k2=; Expires=Thu, 01 Jan 1970 00:00:00 GMT; Max-Age=0; Path=/")
            .assertHeader("Set-Cookie", contains: "k1=; Expires=Thu, 01 Jan 1970 00:00:00 GMT; Max-Age=0; Path=/")
    }

    func testHeaders() throws {
        try drop
            .testResponse(to: .get, at: "headers", headers: ["k1": "v1", "k2": "v2"])
            .assertStatus(is: .ok)
            .assertJSON("headers", passes: { (json) -> (Bool) in
                json["k1"] == "v1" && json["k2"] == "v2"
            })
    }

    func testGet() throws {
        let request = Request.makeTest(method: .get, headers: ["User-Agent": "httpun"], path: "get", query: "k1=v1&k2=v2")
        try drop.testResponse(to: request)
                .assertStatus(is: .ok)
                .assertJSON("headers", equals: ["User-Agent": "httpun"])
                .assertJSON("args", equals: ["k1": "v1", "k2": "v2"])
    }

    func testPostJSON() throws {
        let json = try JSON(node: [
            "string": "stringValue",
            "integer": 123,
            "double": 123.456,
        ])

      
        let request = Request.makeTest(method: .post,
                                       headers: ["Content-Type": "application/json"],
                                       body: try Body(json),
                                       path: "post",
                                       query: "k1=v1&k2=v2"
                                       )


        
        try drop.testResponse(to: request)
                .assertStatus(is: .ok)
                .assertJSON("headers", equals: ["Content-Type": "application/json"])
                .assertJSON("args", equals: ["k1": "v1", "k2": "v2"])
                .assertJSON("json") { (json) -> (Bool) in
                    json["string"]?.string == "stringValue" &&
                    json["integer"]?.int == 123 &&
                    json["double"]?.double == 123.456
                }

    }

    func testPostRaw() throws{
        let request = Request.makeTest(method: .post,
                                       headers: ["User-Agent": "httpun"],
                                       body: Body("Raw Body String"),
                                       path: "post",
                                       query: "k1=v1&k2=v2")

        try drop.testResponse(to: request)
                .assertStatus(is: .ok)
                .assertJSON("headers", equals: ["User-Agent": "httpun"])
                .assertJSON("args", equals: ["k1": "v1", "k2": "v2"])
                .assertJSON("data", passes: { (json) -> (Bool) in
                    json.string == "Raw Body String"
                })
    }

    func testPatchJSON() throws {
        let json = try JSON(node: [
            "string": "stringValue",
            "integer": 123,
            "double": 123.456,
            ])


        let request = Request.makeTest(method: .patch,
                                       headers: ["Content-Type": "application/json"],
                                       body: try Body(json),
                                       path: "patch",
                                       query: "k1=v1&k2=v2"
        )



        try drop.testResponse(to: request)
            .assertStatus(is: .ok)
            .assertJSON("headers", equals: ["Content-Type": "application/json"])
            .assertJSON("args", equals: ["k1": "v1", "k2": "v2"])
            .assertJSON("json") { (json) -> (Bool) in
                json["string"]?.string == "stringValue" &&
                    json["integer"]?.int == 123 &&
                    json["double"]?.double == 123.456
        }

    }

    func testPatchRaw() throws{
        let request = Request.makeTest(method: .patch,
                                       headers: ["User-Agent": "httpun"],
                                       body: Body("Raw Body String"),
                                       path: "patch",
                                       query: "k1=v1&k2=v2")

        try drop.testResponse(to: request)
            .assertStatus(is: .ok)
            .assertJSON("headers", equals: ["User-Agent": "httpun"])
            .assertJSON("args", equals: ["k1": "v1", "k2": "v2"])
            .assertJSON("data", passes: { (json) -> (Bool) in
                json.string == "Raw Body String"
            })
    }

    func testPutJSON() throws {
        let json = try JSON(node: [
            "string": "stringValue",
            "integer": 123,
            "double": 123.456,
            ])


        let request = Request.makeTest(method: .put,
                                       headers: ["Content-Type": "application/json"],
                                       body: try Body(json),
                                       path: "put",
                                       query: "k1=v1&k2=v2"
        )



        try drop.testResponse(to: request)
            .assertStatus(is: .ok)
            .assertJSON("headers", equals: ["Content-Type": "application/json"])
            .assertJSON("args", equals: ["k1": "v1", "k2": "v2"])
            .assertJSON("json") { (json) -> (Bool) in
                json["string"]?.string == "stringValue" &&
                    json["integer"]?.int == 123 &&
                    json["double"]?.double == 123.456
        }

    }

    func testPutRaw() throws{
        let request = Request.makeTest(method: .put,
                                       headers: ["User-Agent": "httpun"],
                                       body: Body("Raw Body String"),
                                       path: "put",
                                       query: "k1=v1&k2=v2")

        try drop.testResponse(to: request)
            .assertStatus(is: .ok)
            .assertJSON("headers", equals: ["User-Agent": "httpun"])
            .assertJSON("args", equals: ["k1": "v1", "k2": "v2"])
            .assertJSON("data", passes: { (json) -> (Bool) in
                json.string == "Raw Body String"
            })
    }

    func testDeleteJSON() throws {
        let json = try JSON(node: [
            "string": "stringValue",
            "integer": 123,
            "double": 123.456,
            ])


        let request = Request.makeTest(method: .delete,
                                       headers: ["Content-Type": "application/json"],
                                       body: try Body(json),
                                       path: "delete",
                                       query: "k1=v1&k2=v2"
        )



        try drop.testResponse(to: request)
            .assertStatus(is: .ok)
            .assertJSON("headers", equals: ["Content-Type": "application/json"])
            .assertJSON("args", equals: ["k1": "v1", "k2": "v2"])
            .assertJSON("json") { (json) -> (Bool) in
                json["string"]?.string == "stringValue" &&
                    json["integer"]?.int == 123 &&
                    json["double"]?.double == 123.456
        }

    }

    func testDeleteRaw() throws{
        let request = Request.makeTest(method: .delete,
                                       headers: ["User-Agent": "httpun"],
                                       body: Body("Raw Body String"),
                                       path: "delete",
                                       query: "k1=v1&k2=v2")

        try drop.testResponse(to: request)
            .assertStatus(is: .ok)
            .assertJSON("headers", equals: ["User-Agent": "httpun"])
            .assertJSON("args", equals: ["k1": "v1", "k2": "v2"])
            .assertJSON("data", passes: { (json) -> (Bool) in
                json.string == "Raw Body String"
            })
    }

    func testDeny() throws {
        try drop.testResponse(to: .get, at: "deny")
            .assertStatus(is: .ok)
            .assertHeader(.contentType, contains: "text/plain; charset=utf-8")
    }

    func testRobotsTxt() throws {
        try drop.testResponse(to: .get, at: "robots.txt")
            .assertStatus(is: .ok)
    }

    func testAnythingWithBody() throws {
        let methods: [HTTP.Method] = [.post, .put, .patch]

        methods.forEach { (m) in
            let request = Request.makeTest(method: m,
                                           headers: ["User-Agent": "httpun"],
                                           body: Body("Raw Body String"),
                                           path: "anything",
                                           query: "k1=v1&k2=v2")

            try! drop.testResponse(to: request)
                .assertStatus(is: .ok)
                .assertJSON("headers", equals: ["User-Agent": "httpun"])
                .assertJSON("args", equals: ["k1": "v1", "k2": "v2"])
                .assertJSON("data", passes: { (json) -> (Bool) in
                    json.string == "Raw Body String"
                })
                .assertJSON("method", equals: m.description)
        }
    }

    func testAnythingNoBody() throws {
        let methods: [HTTP.Method] = [.get, .options, .trace]

        methods.forEach { (m) in
            let getRequest = Request.makeTest(method: m,
                                              headers: ["User-Agent": "httpun"],
                                              path: "anything",
                                              query: "k1=v1&k2=v2")

            try! drop.testResponse(to: getRequest)
                .assertStatus(is: .ok)
                .assertJSON("headers", equals: ["User-Agent": "httpun"])
                .assertJSON("args", equals: ["k1": "v1", "k2": "v2"])
                .assertJSON("method", equals: m.description)
        }

    }

    func testRedirect() throws {
        let request = Request.makeTest(method: .get, path: "redirect/5")

        try drop.testResponse(to: request)
                .assertStatus(is: Status(statusCode: 302))
                .assertHeader("Location", contains: "/redirect/4")

        let redirectMeReq = Request.makeTest(method: .get, path: "redirect/1")

        try drop.testResponse(to: redirectMeReq)
            .assertStatus(is: Status(statusCode: 302))
            .assertHeader("Location", contains: "/get")

    }

    func testRedirectTo() throws {
        let request = Request.makeTest(method: .get, path: "redirect-to", query: nil)

        try drop.testResponse(to: request)
            .assertStatus(is: Status(statusCode: 302))
            .assertHeader("Location", contains: "get", "Redirect to get if no url param defined")

        let req2 = Request.makeTest(method: .get,
                                                 path: "redirect-to",
                                                 query: "url=http%3A%2F%2Fhttpun.org%2Fget%3Fk1%3Dv1%26k2%3Dv2&status_code=307")

        try drop.testResponse(to: req2)
            .assertStatus(is: Status(statusCode: 307))
            .assertHeader("Location", contains: "http://httpun.org/get?k1=v1&k2=v2")

    }

    func testStatus() throws {
        //Reject status codes < 100
        try drop.testResponse(to: .get, at: "/status/1")
            .assertStatus(is: Status(statusCode: 400))
        try drop.testResponse(to: .get, at: "/status/99")
            .assertStatus(is: Status(statusCode: 400))


        // Success status codes
        try drop.testResponse(to: .get, at: "/status/201")
            .assertStatus(is: Status(statusCode: 201))

        // Redirects
        let redirectCodes = [301, 302, 303, 304, 305, 307]
        try redirectCodes.forEach { (code) in
            try drop.testResponse(to: .get, at: "/status/\(code)")
                .assertStatus(is: Status(statusCode: code))
                .assertHeader("Location", contains: "/redirect/1")
        }

        // Specials
        try drop.testResponse(to: .get, at: "/status/401")
            .assertStatus(is: Status(statusCode: 401))
            .assertHeader("WWW-Authenticate", contains: "Basic realm=")

        try drop.testResponse(to: .get, at: "/status/407")
            .assertStatus(is: Status(statusCode: 407))
            .assertHeader("Proxy-Authenticate", contains: "Basic realm=")
    }
}

// MARK: Manifest
extension RouteTests {
    /// This is a requirement for XCTest on Linux
    /// to function properly.
    /// See ./Tests/LinuxMain.swift for examples
    static let allTests = [
        ("testIndex", testIndex),
        ("testUserAgent", testUserAgent),
        ("testIp", testIp),
        ("testCookies", testCookies),
        ("testSetCookies", testSetCookies),
        ("testHeaders", testHeaders),
        ("testGet", testGet),
        ("testDeleteCookies", testDeleteCookies),
        ("testPostJSON", testPostJSON),
        ("testPostRaw", testPostRaw),
        ("testPatchJSON", testPatchJSON),
        ("testPatchRaw", testPatchRaw),
        ("testPutJSON", testPutJSON),
        ("testPutRaw", testPutRaw),
        ("testDeleteJSON", testDeleteJSON),
        ("testDeleteRaw", testDeleteRaw),
        ("testDeny", testDeny),
        ("testRobotsTxt", testRobotsTxt),
        ("testAnythingWithBody", testAnythingWithBody),
        ("testAnythingNoBody", testAnythingNoBody),
        ("testRedirect", testRedirect),
        ("testRedirectTo", testRedirectTo),
        ("testStatus", testStatus),
    ]
}
