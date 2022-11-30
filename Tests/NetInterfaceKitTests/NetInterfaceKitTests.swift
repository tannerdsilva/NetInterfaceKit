import XCTest
@testable import NetInterfaceKit

final class NetInterfaceKitTests: XCTestCase {
	override class func setUp() {
		NetInterfaceKit.logger.logLevel = .trace
	}
    func testInterfaceList() throws {
    	let interfaces = try NetInterfaceKit.allInterfaces()
    	var foundLoopback = false
    	for curInterface in interfaces {
    		if (curInterface.name == "lo") {
    			foundLoopback = true
    		}
    	}
    	XCTAssertTrue(foundLoopback == true)
    }
}
