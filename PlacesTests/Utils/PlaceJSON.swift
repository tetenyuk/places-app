//
//  PlaceJSON.swift
//  PlacesTests
//

import Foundation

enum PlaceJSON {
    /// Original payload from assignment json
    static let locations = """
    {
      "locations": [
        { "name": "Amsterdam", "lat": 52.3547498, "long": 4.8339215 },
        { "name": "Mumbai", "lat": 19.0823998, "long": 72.8111468 },
        { "name": "Copenhagen", "lat": 55.6713442, "long": 12.523785 },
        { "lat": 40.4380638, "long": -3.7495758 }
      ]
    }
    """

    static let empty = #"{ "locations": [] }"#

    /// Unknown root key
    static let unexpectedShape = #"{ "places": [] }"#

    static let notJSON = "<html>rate limited</html>"

    static let outOfRangeCoordinates = """
    {
      "locations": [
        { "name": "Valid", "lat": 52.0, "long": 4.0 },
        { "name": "Latitude too high", "lat": 91.0, "long": 4.0 },
        { "name": "Longitude too low", "lat": 52.0, "long": -181.0 }
      ]
    }
    """

    static func data(_ json: String) -> Data {
        Data(json.utf8)
    }
}
