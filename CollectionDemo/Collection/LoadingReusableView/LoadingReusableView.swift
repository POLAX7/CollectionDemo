//
//  LoadingReusableView.swift
//  CollectionDemo
//
//  Created by David on 2022/4/22.
//

import UIKit

class LoadingReusableView: UICollectionReusableView {

   @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    override func awakeFromNib() {
        super.awakeFromNib()
        activityIndicator.color = UIColor.black
    }
}
