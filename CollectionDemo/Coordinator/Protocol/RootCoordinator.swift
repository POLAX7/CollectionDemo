//
//  RootCoordinator.swift
//  CollectionDemo
//
//  Created by David on 2022/4/22.
//

import UIKit

protocol RootCoordinator: AnyObject {
    func start(_ navigationController: UINavigationController)
    func moveToDetail(asset:Asset)
}
