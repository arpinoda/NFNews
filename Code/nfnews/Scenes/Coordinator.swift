//
//  Coordinator.swift
//  scratch
//
//  Created by Work on 2/15/21.
//

import Foundation

protocol CoordinatorDelegate {
    func didFinish(from coordinator: Coordinator)
}

fileprivate struct Lang {
    static func startPreconditionFailed() -> String {
        return "This method needs to be overriden by concrete subclass."
    }
    
    static func endPreconditionFailed() -> String {
        return "This method needs to be overriden by concrete subclass."
    }
    
    static func removeChildError(for coordinator: Coordinator) -> String {
        return "Couldn't remove coordinator: \(coordinator). It's not a child coordinator."
    }
}

class Coordinator {

    private(set) var childCoordinators: [Coordinator] = []

    func start() {
        preconditionFailure(Lang.startPreconditionFailed())
    }

    func finish() {
        preconditionFailure(Lang.endPreconditionFailed())
    }

    func addChildCoordinator(_ coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }

    func removeChildCoordinator(_ coordinator: Coordinator) {
        if let index = childCoordinators.firstIndex(of: coordinator) {
            childCoordinators.remove(at: index)
        } else {
            print(Lang.removeChildError(for: coordinator))
        }
    }

    func removeAllChildCoordinatorsWith<T>(type: T.Type) {
        childCoordinators = childCoordinators.filter { $0 is T  == false }
    }

    func removeAllChildCoordinators() {
        childCoordinators.removeAll()
    }

}

extension Coordinator: Equatable {
    
    static func == (lhs: Coordinator, rhs: Coordinator) -> Bool {
        return lhs === rhs
    }
    
}
