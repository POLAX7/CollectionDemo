//
//  CollectionViewModel.swift
//  CollectionDemo
//
//  Created by David on 2022/4/22.
//

import Foundation
import RxSwift
import RxCocoa

final class CollectionViewModel {
    private var networkManager: HTTPManagerProtocol?
    private(set) var items : BehaviorRelay<[Asset]> = BehaviorRelay(value: [])
    private var pageNum : Int = 0
    private(set) var hasMore = true
    let disposeBag = DisposeBag()
    
    init(coordinator: RootCoordinator?, networkManager: HTTPManagerProtocol) {
        self.networkManager = networkManager
    }
    
    func reloadData() {
        pageNum = 0
        hasMore = true
        fetchData(pageNum)
    }
    
    func loadMoreData() {
        if(hasMore) {
            pageNum += 1
            fetchData(pageNum)
        }
    }
    
    private func fetchData(_ page:Int) {
        networkManager?.getAssets(page: page)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] assets in
                let newAssets = assets.assets
                let count = newAssets.count
                if count < 20 {
                    self?.hasMore = false
                }
                switch page{
                case 0:
                    self?.items.accept(newAssets)
                default:
                    let totalAssets = (self?.items.value ?? []) + newAssets
                    self?.items.accept(totalAssets)
                }
            }, onError: { error in
                switch error {
                case ApiError.conflict:
                    print("Conflict error")
                case ApiError.forbidden:
                    print("Forbidden error")
                case ApiError.notFound:
                    print("Not found error")
                default:
                    print("Unknown error:", error)
                }
            })
            .disposed(by: disposeBag)
        
    }
}

