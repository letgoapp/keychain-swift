import XCTest

class ServiceTests: XCTestCase {
  var obj: KeychainSwift!
  
  override func setUp() {
    super.setUp()
    
    obj = KeychainSwift()
    obj.clear()
    obj.lastQueryParameters = nil
    obj.service = nil
  }
  
  // MARK: - Add service 
  
  func testAddService() {
    let items: [String: Any] = [
      "one": "two"
    ]
    
    obj.service = "test service"
    let result = obj.addServiceWhenPresent(items)
    
    XCTAssertEqual(2, result.count)
    XCTAssertEqual("two", result["one"] as! String)
    XCTAssertEqual("test service", result["svce"] as! String)
  }
  
  func testAddService_nil() {
    let items: [String: Any] = [
      "one": "two"
    ]
    
    obj.service = nil
    let result = obj.addServiceWhenPresent(items)
    
    XCTAssertEqual(1, result.count)
    XCTAssertEqual("two", result["one"] as! String)
  }
  
  func testSet() {
    obj.service = "test service"
    obj.set("hello :)", forKey: "key 1")
    XCTAssertEqual("test service", obj.lastQueryParameters?["svce"] as! String)
  }
  
  func testGet() {
    obj.service = "test service"
    _ = obj.get("key 1")
    XCTAssertEqual("test service", obj.lastQueryParameters?["svce"] as! String)
  }
  
  func testDelete() {
    obj.service = "test service"
    obj.delete("key 1")
    XCTAssertEqual("test service", obj.lastQueryParameters?["svce"] as! String)
  }
  
  func testClear() {
    obj.service = "test service"
    obj.clear()
    XCTAssertEqual("test service", obj.lastQueryParameters?["svce"] as! String)
  }
}
