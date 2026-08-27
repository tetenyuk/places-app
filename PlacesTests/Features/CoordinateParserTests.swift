//
//  CoordinateParserTests.swift
//  PlacesTests
//

import Testing
@testable import Places

@Suite("CoordinateParser")
struct CoordinateParserTests {
    @Test("reads plain decimals")
    func plainDecimals() {
        #expect(CoordinateParser.latitude(from: "52.3547498") == 52.3547498)
        #expect(CoordinateParser.longitude(from: "-3.7495758") == -3.7495758)
    }

    @Test("accepts a comma as the decimal separator")
    func comma() {
        #expect(CoordinateParser.latitude(from: "52,3547498") == 52.3547498)
    }

    @Test("ignores surrounding whitespace")
    func whitespace() {
        #expect(CoordinateParser.latitude(from: "  52.35  ") == 52.35)
    }

    @Test("accepts the extremes of each range")
    func boundaries() {
        #expect(CoordinateParser.latitude(from: "90") == 90)
        #expect(CoordinateParser.latitude(from: "-90") == -90)
        #expect(CoordinateParser.longitude(from: "180") == 180)
        #expect(CoordinateParser.longitude(from: "-180") == -180)
    }

    @Test("rejects values past the extremes")
    func outOfRange() {
        #expect(CoordinateParser.latitude(from: "90.1") == nil)
        #expect(CoordinateParser.latitude(from: "-90.1") == nil)
        #expect(CoordinateParser.longitude(from: "180.1") == nil)
        #expect(CoordinateParser.longitude(from: "-180.1") == nil)
    }

    @Test("rejects anything that is not a number", arguments: ["", "   ", "abc", "52.3.5", "52°", "-", "nan", "inf"])
    func notANumber(text: String) {
        #expect(CoordinateParser.latitude(from: text) == nil)
    }

    @Test("a latitude out of range can still be a valid longitude")
    func rangesDiffer() {
        #expect(CoordinateParser.latitude(from: "120") == nil)
        #expect(CoordinateParser.longitude(from: "120") == 120)
    }
}
