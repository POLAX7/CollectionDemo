//
//  DetailViewModel.swift
//  CollectionDemo
//
//  Created by David on 2022/4/22.
//

import Foundation

class DetailViewModel {
    private var networkManager: HTTPManagerProtocol?
    private var id: Int
    private(set) var image_url: String?
    private(set) var image_preview_url: String?
    private(set) var name: String?
    private(set) var description: String?
    private(set) var permalink: String?
    
    init(_ asset:Asset, coordinator: RootCoordinator?, networkManager: HTTPManagerProtocol) {
        self.networkManager = networkManager
        self.id = asset.id
        self.image_url = asset.image_url
        self.image_preview_url = asset.image_preview_url
        self.name = asset.name
        self.description = asset.description
        self.permalink = asset.permalink
    }
}
