import XCTest
@testable import LangSwitcher

final class AccessibilityServiceTests: XCTestCase {
    
    func testEmptySelectionMarker_UTF16() {
        // Chromium stores custom clipboard data strings as UTF-16
        let json = #"{"version":1,"isFromEmptySelection":true,"multicursorText":null}"#
        let data = Data([0x01, 0x00]) + json.data(using: .utf16LittleEndian)!
        XCTAssertTrue(AccessibilityService.containsEmptySelectionMarker(data))
    }
    
    func testEmptySelectionMarker_UTF8() {
        let json = #"{"version":1,"isFromEmptySelection":true}"#
        XCTAssertTrue(AccessibilityService.containsEmptySelectionMarker(json.data(using: .utf8)!))
    }
    
    func testEmptySelectionMarker_FalseWhenSelectionWasReal() {
        let json = #"{"version":1,"isFromEmptySelection":false}"#
        XCTAssertFalse(AccessibilityService.containsEmptySelectionMarker(json.data(using: .utf16LittleEndian)!))
        XCTAssertFalse(AccessibilityService.containsEmptySelectionMarker(json.data(using: .utf8)!))
    }
    
    func testEmptySelectionMarker_FalseForPlainText() {
        XCTAssertFalse(AccessibilityService.containsEmptySelectionMarker("ghbdtn".data(using: .utf8)!))
        XCTAssertFalse(AccessibilityService.containsEmptySelectionMarker(Data()))
    }
    
    func testNormalizedForComparison_NBSPAndCRLF() {
        XCTAssertEqual(
            AccessibilityService.normalizedForComparison("ghbdtn\u{00A0}"),
            AccessibilityService.normalizedForComparison("ghbdtn ")
        )
        XCTAssertEqual(
            AccessibilityService.normalizedForComparison("a\r\nb"),
            AccessibilityService.normalizedForComparison("a\nb")
        )
    }
}
