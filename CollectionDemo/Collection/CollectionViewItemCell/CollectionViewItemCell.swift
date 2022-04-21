//
//  CollectionViewItemCell.swift
//  CollectionDemo
//
//  Created by David on 2022/4/22.
//

import UIKit
import Kingfisher
import SVGKit
import MarqueeLabel

class CollectionViewItemCell: UICollectionViewCell {
    
    static let reuseIdentifier = "collectionviewitemcellid"
    
    @IBOutlet weak var imageView: AnimatedImageView!
    @IBOutlet weak var label: MarqueeLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setup(_ item:Asset) {
        if let nameStr = item.name {
            label.text = nameStr
        }
        if let urlStr = item.image_preview_url, let url = URL(string: urlStr) {
            imageView.isHidden = false
            if urlStr.hasSuffix(".svg") {
                imageView.kf.setImage(with: url, options: [.processor(SVGImgProcessor())])
            } else {
                imageView.kf.setImage(with: url)
            }
        } else {
            imageView.isHidden = true
        }
    }
}

public struct SVGImgProcessor : ImageProcessor {
    public var identifier: String = "com.democollection.webpprocessor"
    public func process(item: ImageProcessItem, options: KingfisherParsedOptionsInfo) -> KFCrossPlatformImage? {
        switch item {
        case .image(let image):
            return image
        case .data(let data):
            let imsvg = SVGKImage(data: data)
            return imsvg?.uiImage
        }
    }
}

