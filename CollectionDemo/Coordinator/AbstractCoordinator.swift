//
//  AbstractCoordinator.swift
//  CollectionDemo
//
//  Created by David on 2022/4/22.
//

import Foundation

protocol AbstractCoordinator {
    func addChildCoordinator(_ coordinator: AbstractCoordinator)
    func removeAllChildCoordinatorsWith<T>(type: T.Type)
    func removeAllChildCoordinators()
}

