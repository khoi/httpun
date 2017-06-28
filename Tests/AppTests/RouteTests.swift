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
                .assertJSON("queries", equals: ["k1": "v1", "k2": "v2"])

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
    ]
}
