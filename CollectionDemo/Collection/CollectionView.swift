//
//  CollectionView.swift
//  CollectionDemo
//
//  Created by David on 2022/4/22.
//

import UIKit
import SnapKit

final class CollectionView: UIView {
    var collectionView : UICollectionView?
    weak var delegate : UICollectionViewDelegate?
    weak var dataSource : UICollectionViewDataSource?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init(_ delegate : UICollectionViewDelegate?) {
        super.init(frame: .zero)
        self.delegate = delegate
        setup()
    }
    
    private func setup() {
        self.backgroundColor = .white
        
        let layout = UICollectionViewFlowLayout()
        let margin: CGFloat = 10
        layout.minimumLineSpacing = margin
        layout.minimumInteritemSpacing = margin
        layout.sectionInset = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        let itemCellNib = UINib(nibName: "CollectionViewItemCell", bundle: nil)
        collectionView.register(itemCellNib, forCellWithReuseIdentifier: "collectionviewitemcellid")
        
        let loadingReusableNib = UINib(nibName: "LoadingReusableView", bundle: nil)
        collectionView.register(loadingReusableNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "loadingresuableviewid")
        collectionView.delegate = delegate
        self.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { [weak self] (make) -> Void in
            guard let self = self else { return }
            make.leading.equalTo(self)
            make.trailing.equalTo(self)
            make.top.equalTo(self)
            make.bottom.equalTo(self)
        }
        self.collectionView = collectionView
    }
}

