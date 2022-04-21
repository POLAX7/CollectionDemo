//
//  DependencyFactory.swift
//  CollectionDemo
//
//  Created by David on 2022/4/22.
//

import Foundation

protocol Factory {
    var networkManager: HTTPManagerProtocol { get }
    func makeCollectionViewController(coordinator: ProjectCoordinator) -> CollectionViewController
    func makeCollectionViewModel(coordinator: RootCoordinator) -> CollectionViewModel
    func makeDetailView() -> DetailView
    func makeDetailViewModel(asset:Asset, _ coordinator: RootCoordinator) -> DetailViewModel
}

// replace the DependencyContainer for tests
class DependencyFactory: Factory {
    func makeCollectionViewController(coordinator: ProjectCoordinator) -> CollectionViewController {
        let viewModel = makeCollectionViewModel(coordinator: coordinator)
        let collectionViewController = CollectionViewController(coordinator: coordinator, viewModel: viewModel)
        return collectionViewController
    }
    
    var networkManager: HTTPManagerProtocol = HTTPManager()
    
    func makeCollectionCoordinator() -> ProjectCoordinator {
        let coordinator = ProjectCoordinator(factory: self)
        return coordinator
    }
    
    func makeCollectionViewModel(coordinator: RootCoordinator) -> CollectionViewModel {
        let viewModel = CollectionViewModel(coordinator: coordinator, networkManager: networkManager)
        return viewModel
    }
}

extension DependencyFactory {
    func makeDetailView() -> DetailView {
        let view = DetailView()
        return view
    }
    
    func makeDetailViewModel(asset:Asset, _ coordinator: RootCoordinator) -> DetailViewModel {
        let viewModel = DetailViewModel(asset, coordinator: coordinator, networkManager: networkManager)
        return viewModel
    }
}

