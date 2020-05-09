//STATIC -> type property
//Summary: usings static, can access properties/methods directly, without creating instances

import Foundation

struct MyStructure {

    //Properties
    let instanceProperty = "instance property"
    static let typeProperty = "type property"
    
    //Methods
    func instanceMethod() {
        print("instance method")
    }
    static func typeMethod() {
        print("type method")
    }
}

//INSTANCE
let myStructure = MyStructure()
//Property (let/func)
print(myStructure.instanceProperty)
//Method
myStructure.instanceMethod()

//TYPE (static let/func)
//Property
print(MyStructure.typeProperty)
//Method
MyStructure.typeMethod()
