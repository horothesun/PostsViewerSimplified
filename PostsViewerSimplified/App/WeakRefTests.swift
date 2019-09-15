import XCTest
import PostsViewerSimplified

final class WeakRefTests: XCTestCase {

    func test_weakRefHoldsReferenceToObject() {
        let anObject = MockObject()
        let weakRef = WeakRef(anObject)
        XCTAssertEqual(ObjectIdentifier(weakRef.object!), ObjectIdentifier(anObject))
    }

    func test_weakRefHoldsWeakReferenceToObject() {
        var anObject: MockObject? = MockObject() // anObject retain count = 1
        let weakRef = WeakRef(anObject!)
        anObject = nil // anObject retain count = 0 (memory should be freed now)
        XCTAssertNil(weakRef.object, "Object reference should be nil after the object has been freed")
    }
}

private final class MockObject { }
