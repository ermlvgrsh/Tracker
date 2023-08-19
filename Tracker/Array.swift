import Foundation


extension Array {
    func partioned(by condition: (Element) -> Bool) -> ([Element], [Element]) {
        var trueElements = [Element]()
        var falseElements = [Element]()
        
        for element in self {
            if condition(element) {
                trueElements.append(element)
            } else {
                falseElements.append(element)
            }
        }
        return (trueElements, falseElements)
    }
}
