//
//  ProjectCoordinator.swift
//  CollectionDemo
//
//  Created by David on 2022/4/22.
//

import UIKit

class ProjectCoordinator: AbstractCoordinator, RootCoordinator {
    private(set) var childCoordinators: [AbstractCoordinator] = []
    weak var navigationController: UINavigationController?
    private var factory: Factory
    
    init(factory: Factory) {
        self.factory = factory
    }
    
    func addChildCoordinator(_ coordinator: AbstractCoordinator) {
        childCoordinators.append(coordinator)
    }
    
    func removeAllChildCoordinatorsWith<T>(type: T.Type) {
        childCoordinators = childCoordinators.filter { $0 is T  == false }
    }
    
    func removeAllChildCoordinators() {
        childCoordinators.removeAll()
    }
    
    func start(_ navigationController: UINavigationController) {
        let vc = factory.makeCollectionViewController(coordinator: self)
        self.navigationController = navigationController
        navigationController.pushViewController(vc, animated: true)
    }
        

    func moveToDetail(asset:Asset) {
        let detaiViewModel = factory.makeDetailViewModel(asset: asset, self)
        let vc = DetailViewController(factory: factory, viewModel: detaiViewModel, coordinator: self)
        navigationController?.pushViewController(vc, animated: true)
    }
}
