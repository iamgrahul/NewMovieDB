import XCTest
@testable import NewMovieDB

class MockJailbreakChecker: JailbreakChecker {
    var simulatedResult: Bool
    init(result: Bool) {
        self.simulatedResult = result
    }

    func isJailbroken() -> Bool {
        return simulatedResult
    }
}

final class AppUtilityTests: XCTestCase {
    
    func test_getJailbrokenStatus_returnsTrueWhenJailbroken() {
        let mockChecker = MockJailbreakChecker(result: true)
        let result = AppUtility.getJailbrokenStatus(using: mockChecker)
        XCTAssertTrue(result)
    }

    func test_getJailbrokenStatus_returnsFalseWhenNotJailbroken() {
        let mockChecker = MockJailbreakChecker(result: false)
        let result = AppUtility.getJailbrokenStatus(using: mockChecker)
        XCTAssertFalse(result)
    }
}
