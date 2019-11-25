//
//  LinkedList.swift
//  MRTScheduleJakarta
//
//  Created by Alfian Losari on 11/24/19.
//  Copyright © 2019 Alfian Losari. All rights reserved.
//

import Foundation

class Node<T: Equatable> {
    
    var prevNode: Node<T>?
    var nextNode: Node<T>?
    
    var isHead: Bool {
        prevNode == nil
    }
    
    var isTail: Bool {
        nextNode == nil
    }
    
    var item: T
    init(item: T) {
        self.item = item
    }
}

class LinkedList<T: Equatable> {
    
    var node: Node<T>
    init(node: Node<T>) {
        self.node = node
    }
    
    func add(_ node: Node<T>) {
        guard self.node.isHead else { return }
        var currentNode = self.node
        while currentNode.nextNode != nil {
            currentNode = currentNode.nextNode!
        }
        currentNode.nextNode = node
        node.prevNode = currentNode
    }
    
    func node(for item: T) -> Node<T>? {
        var currentNode = self.node
        while currentNode.nextNode != nil {
            if currentNode.item == item {
                return currentNode
            }
            currentNode = currentNode.nextNode!
        }
        if currentNode.item == item {
            return currentNode
        }
        return nil
    }
    
}
