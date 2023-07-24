import Foundation

@propertyWrapper

final class Observable<Value> {
    private var didChange: ((Value) -> Void)? = nil
    
    var wrappedValue: Value {
        didSet {
            didChange?(wrappedValue)
        }
    }
    
    var projectedValue: Observable {
        return self
    }
    init(wrappedValue: Value) {
        self.wrappedValue = wrappedValue
    }
    
    func bind(action: @escaping (Value) -> Void ) {
        self.didChange = action
    }
}
