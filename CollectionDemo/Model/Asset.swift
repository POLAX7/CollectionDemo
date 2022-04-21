//
//  Asset.swift
//  CollectionDemo
//
//  Created by David on 2022/4/22.
//

import Foundation

struct Asset: Codable {
    let id: Int
    let image_url: String?
    let image_preview_url: String?
    let name: String?
    let description: String?
    let permalink: String?
}

struct Assets: Codable {
    let assets : [Asset]
}
