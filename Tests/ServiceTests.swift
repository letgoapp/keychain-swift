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
  
  // MARK: - Set
  
  func testSet_addServiceParameter() {
    obj.service = "test service"
    obj.set("hello :)", forKey: "key 1")
    XCTAssertEqual("test service", obj.lastQueryParameters?["svce"] as! String)
  }
  
  func testSet_andGet() {
    obj.service = "test service"
    obj.set("hello :)", forKey: "key 1")
    XCTAssertEqual("hello :)", obj.get("key 1")!)
  }
  
  func testSet_andGet_twoServices() {
    obj.service = "service 1"
    obj.set("hello from service 1", forKey: "key 1")
    
    obj.service = "service 2"
    obj.set("hello from service 2", forKey: "key 1")
    
    obj.service = "service 1"
    XCTAssertEqual("hello from service 1", obj.get("key 1")!)
    
    obj.service = "service 2"
    XCTAssertEqual("hello from service 2", obj.get("key 1")!)
  }
  
  func testSet_andGet_itemWithServiceAndWithEmptyService() {
    obj.service = "service 1"
    obj.set("hello from service 1", forKey: "key 1")
    
    obj.service = nil
    obj.set("hello from empty", forKey: "key 1")
    
    obj.service = "service 1"
    XCTAssertNil(obj.get("key 1"))
    
    obj.service = nil
    XCTAssertEqual("hello from empty", obj.get("key 1")!)
  }
  
  // MARK: - Get

  func testGet_addServiceParameter() {
    obj.service = "test service"
    _ = obj.get("key 1")
    XCTAssertEqual("test service", obj.lastQueryParameters?["svce"] as! String)
  }
  
  func testGet_returnsNilForUnknownService() {
    obj.service = "test service"
    obj.set("hello :)", forKey: "key 1")
    obj.service = "unknown"
    XCTAssertNil(obj.get("key 1"))
  }
  
  func testGet_returnsServiceForEmptyService() {
    obj.service = "test service"
    obj.set("hello :)", forKey: "key 1")
    obj.service = nil
    XCTAssertEqual("hello :)", obj.get("key 1")!)
  }
  
  func testGet_returnsFirstServiceForEmptyServiceWhenMultipleServicesAreSupplied() {
    obj.service = "service 1"
    obj.set("hello from service 1", forKey: "key 1")
    
    obj.service = "service 2"
    obj.set("hello from service 2", forKey: "key 1")
    
    obj.service = nil
    XCTAssertEqual("hello from service 1", obj.get("key 1")!)
  }
  
  // MARK: - Delete

  func testDelete_addServiceParameter() {
    obj.service = "test service"
    obj.delete("key 1")
    XCTAssertEqual("test service", obj.lastQueryParameters?["svce"] as! String)
  }
  
  func testDelete() {
    obj.service = "test service"
    obj.set("hello :)", forKey: "key 1")
    obj.delete("key 1")
    
    XCTAssertNil(obj.get("key 1"))
  }
  
  func testDelete_onlyKeyFromSpecifiedService() {
    obj.service = "service 1"
    obj.set("hello from service 1", forKey: "key 1")
    
    obj.service = "service 2"
    obj.set("hello from service 2", forKey: "key 1")
    
    obj.service = "service 1"
    obj.delete("key 1")
    
    obj.service = "service 1"
    XCTAssertNil(obj.get("key 1"))
    
    obj.service = "service 2"
    XCTAssertEqual("hello from service 2", obj.get("key 1")!)
  }
  
  func testDelete_allItemsWithKeyWhenServiceIsEmpty() {
    obj.service = "service 1"
    obj.set("hello from service 1", forKey: "key 1")
    
    obj.service = "service 2"
    obj.set("hello from service 2", forKey: "key 1")
    
    obj.service = nil
    obj.delete("key 1")
    
    obj.service = "service 1"
    XCTAssertNil(obj.get("key 1"))
    
    obj.service = "service 2"
    XCTAssertNil(obj.get("key 2"))
  }
  
  // MARK: - Clear

  func testClear_addServiceParameter() {
    obj.service = "test service"
    obj.clear()
    XCTAssertEqual("test service", obj.lastQueryParameters?["svce"] as! String)
  }
  
  func testClear_clearKeysWithAllServices() {
    obj.service = "service 1"
    obj.set("hello from service 1", forKey: "key 1")
    
    obj.service = "service 2"
    obj.set("hello from service 2", forKey: "key 1")
    
    obj.service = "service 1"
    obj.clear()
    
    XCTAssertNil(obj.get("key 1"))
    XCTAssertNil(obj.get("key 2"))
  }
}
