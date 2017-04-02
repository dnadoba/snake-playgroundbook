import Foundation


/// A Type which can be used as an element of a `LinkedList`.
/// Only add this `LinkedListElement` once to a `LinkedList`. 
/// Before you can add the same `LinkedListElement` to the same or another `LinkedList` you must remove it from the previous `LinkedList`.
protocol LinkedListElement: class {
    
    /// the previous element in the list if any. Never mutate this value yourself.
    weak var previousElement: Self? { get set }
    /// the next element in the list if any. Never mutate this value yourself.
    var nextElement: Self? { get set }
}


/// A `LinkedList` manages a list of `LinkedListElement`.
/// Use a linked list over an `Array` when you need insertion time of O(1)
class LinkedList<Element: LinkedListElement>: Sequence {
    private(set) var tail: Element?
    private(set) weak var head: Element?
    private(set) var count = 0
    
    /// appends an element to the end of the list
    ///
    /// - Parameter element: element to add at the end of the list
    func appendLast(_ element: Element) {
        count += 1
        if let lastElement = head {
            lastElement.nextElement = element
            element.previousElement = lastElement
        } else {
            tail = element
        }
        head = element
    }
    /// appends an element to the start of the list
    ///
    /// - Parameter element: element to add at the start of the list
    func appendFirst(_ element: Element) {
        count += 1
        if let firstElement = tail {
            firstElement.previousElement = element
            element.nextElement = firstElement
        } else {
            head = element
        }
        tail = element
    }
    
    /// removes the first element of the list and returns it if any.
    ///
    /// - Returns: first element of the list if any, otherwise nil
    func removeFirst() -> Element? {
        let firstElement = tail
        tail = firstElement?.nextElement
        if tail == nil {
            head = nil
        }
        if firstElement != nil {
            count -= 1
        }
        firstElement?.nextElement = nil
        return firstElement
    }
    
    /// creates an iterator which iterates from the first to the last element in the list
    ///
    /// - Returns: linked list iterator
    func makeIterator() -> AnyIterator<Element> {
        var nextElement = tail
        return AnyIterator { () -> Element? in
            let currentNode = nextElement
            nextElement = currentNode?.nextElement
            return currentNode
        }
    }
    /// creates an iterator which iterates from the last to the first element in the list
    ///
    /// - Returns: revesed linked list iterator
    func makeReversedIterator() -> AnyIterator<Element> {
        var nextElement = head
        return AnyIterator { () -> Element? in
            let currentNode = nextElement
            nextElement = currentNode?.previousElement
            return currentNode
        }
    }
}
