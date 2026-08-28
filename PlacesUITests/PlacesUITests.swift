//
//  PlacesUITests.swift
//  PlacesUITests
//

import XCTest

final class PlacesUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    private func launchApp() -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments.append("-uiTesting")
        app.launch()
        return app
    }

    @MainActor
    private func firstRow(in app: XCUIApplication) -> XCUIElement {
        app.buttons.matching(identifier: "placeRow").firstMatch
    }

    @MainActor
    func testRowsAnnounceTheirNameAndCoordinates() {
        let app = launchApp()
        let row = firstRow(in: app)

        XCTAssertTrue(row.waitForExistence(timeout: 5))
        XCTAssertTrue(row.label.contains("Amsterdam"))
        XCTAssertTrue(row.label.contains("latitude"))
    }

    @MainActor
    func testTheEntryWithoutANameStillHasALabel() {
        let app = launchApp()
        let rows = app.buttons.matching(identifier: "placeRow")

        XCTAssertTrue(rows.firstMatch.waitForExistence(timeout: 5))
        XCTAssertEqual(rows.count, 4)
        XCTAssertTrue(rows.element(boundBy: 3).label.contains("Unnamed place"))
    }

    @MainActor
    func testTappingAPlaceWithoutWikipediaInstalledExplainsWhy() {
        let app = launchApp()
        let row = firstRow(in: app)
        XCTAssertTrue(row.waitForExistence(timeout: 5))

        row.tap()

        XCTAssertTrue(app.alerts.firstMatch.waitForExistence(timeout: 5))
    }

    @MainActor
    func testCustomPlaceStaysDisabledUntilBothFieldsAreValid() {
        let app = launchApp()
        XCTAssertTrue(app.buttons["addCustomPlace"].waitForExistence(timeout: 5))
        app.buttons["addCustomPlace"].tap()

        let latitude = app.textFields["latitudeField"]
        let longitude = app.textFields["longitudeField"]
        let open = app.buttons["openInWikipedia"]
        XCTAssertTrue(latitude.waitForExistence(timeout: 5))
        XCTAssertFalse(open.isEnabled)

        latitude.tap()
        latitude.typeText("200")
        XCTAssertFalse(open.isEnabled)

        latitude.typeText(String(repeating: XCUIKeyboardKey.delete.rawValue, count: 3))
        latitude.typeText("52.35")
        longitude.tap()
        longitude.typeText("4.83")

        XCTAssertTrue(open.isEnabled)
    }
}
