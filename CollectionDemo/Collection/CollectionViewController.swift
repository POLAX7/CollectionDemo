//
//  CollectionViewController.swift
//  CollectionDemo
//
//  Created by David on 2022/4/22.
//

import UIKit
import RxSwift
import RxCocoa

final class CollectionViewController: UIViewController {
    private var coordinator: ProjectCoordinator?
    
    var isLoading = false
    var collectionView: CollectionView?
    var loadingView: LoadingReusableView?
    
    private var viewModel: CollectionViewModel
    private let disposeBag = DisposeBag()

    init(coordinator: ProjectCoordinator, viewModel: CollectionViewModel) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let collectionView = CollectionView(self)
        self.collectionView = collectionView
        self.view = collectionView
        setupObserver()
        viewModel.reloadData()
    }

    private func setupObserver() {
        guard let collectionView = collectionView?.collectionView else { return }
        viewModel.items.bind(to: collectionView.rx.items) {
            (collectionView, row, element) in
            self.isLoading = false
            let indexPath = IndexPath(row: row, section: 0)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewItemCell.reuseIdentifier, for: indexPath) as! CollectionViewItemCell
            cell.setup(element)
            return cell
        }
        .disposed(by: disposeBag)
    }
}

extension CollectionViewController : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let index = indexPath.row
        let num = viewModel.items.value.count
        if index < num {
            let itemData = viewModel.items.value[index]
            coordinator?.moveToDetail(asset:itemData)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == (viewModel.items.value.count - 8) && !self.isLoading {
            loadMoreData()
        }
    }

    private func loadMoreData() {
        guard viewModel.hasMore else { return }
        if !self.isLoading {
            self.isLoading = true
            viewModel.loadMoreData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let noOfCellsInRow = 2   //number of column
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))

        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
        return CGSize(width: size, height: size + 20)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if self.isLoading {
            return CGSize.zero
        } else {
            return CGSize(width: collectionView.bounds.size.width, height: 55)
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let aFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "loadingresuableviewid", for: indexPath) as! LoadingReusableView
            loadingView = aFooterView
            loadingView?.backgroundColor = UIColor.clear
            return aFooterView
        }
        return UICollectionReusableView()
    }

    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.loadingView?.activityIndicator.startAnimating()
        }
    }

    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.loadingView?.activityIndicator.stopAnimating()
        }
    }
}

