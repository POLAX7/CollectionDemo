//
//  DetailViewController.swift
//  CollectionDemo
//
//  Created by David on 2022/4/22.
//

import UIKit
import SafariServices

class DetailViewController: UIViewController {
    weak var coordinator: RootCoordinator?
    private var factory: Factory?
    private var viewModel: DetailViewModel?
    private var detailView: DetailView?
    
    init(factory: Factory, viewModel:DetailViewModel, coordinator: RootCoordinator) {
        self.factory = factory
        self.coordinator = coordinator
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        if let detailView = factory?.makeDetailView(), let model = viewModel {
            self.detailView = detailView
            self.view = detailView
            detailView.setup(model, handler: self)
        }
    }
}

extension DetailViewController : ButtonClickedHandler, SFSafariViewControllerDelegate {
    func didClicked(sender: UIButton) {
        if let urlStr = viewModel?.permalink, let url = URL(string: urlStr) {
            let safariVC = SFSafariViewController(url: url)
            safariVC.dismissButtonStyle = .close
            safariVC.delegate = self
            self.navigationController?.present(safariVC, animated: true, completion: nil)
        }
    }
}

