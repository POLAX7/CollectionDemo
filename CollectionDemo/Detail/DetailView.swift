//
//  DetailView.swift
//  CollectionDemo
//
//  Created by David on 2022/4/22.
//

import UIKit
import SnapKit
import Kingfisher
import SVGKit
import MarqueeLabel

final class DetailView: UIView {
    
    weak var handler : ButtonClickedHandler?
    var imageView : AnimatedImageView?
    var label : MarqueeLabel?
    var descriptionTextView : UITextView?
    var button : UIButton?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(_ viewModel:DetailViewModel, handler:ButtonClickedHandler) {
        self.handler = handler
        let guide = self.safeAreaLayoutGuide
        self.backgroundColor = .white
        let imageView = AnimatedImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(imageView)
        
        imageView.snp.makeConstraints { (make) -> Void in
            make.leading.equalTo(guide).offset(60)
            make.trailing.equalTo(guide).offset(-60)
            make.top.equalTo(guide).offset(60)
            make.height.equalTo(imageView.snp.width)
        }
        
        if let urlStr = viewModel.image_url, let url = URL(string: urlStr) {
            imageView.isHidden = false
            if urlStr.hasSuffix(".svg") {
                imageView.kf.setImage(with: url, options: [.processor(SVGImgProcessor())])
            } else {
                imageView.kf.setImage(with: url)
            }
        } else {
            imageView.isHidden = true
        }
        self.imageView = imageView
        
        let label = MarqueeLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 26, weight: .bold)
        label.text = viewModel.name
        label.textAlignment = .center
        label.accessibilityTraits = .header
        label.isAccessibilityElement = true
        self.addSubview(label)
        
        label.snp.makeConstraints { (make) -> Void in
            make.leading.equalTo(guide).offset(20)
            make.trailing.equalTo(guide).offset(-20)
            make.top.equalTo(guide).offset(20)
            make.height.equalTo(30)
        }
        self.label = label
        
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("permalink", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(didClicked), for: .touchUpInside)
        button.isHidden = (viewModel.permalink == nil)
        button.backgroundColor = .darkGray
        self.addSubview(button)
        
        button.snp.makeConstraints { (make) -> Void in
            make.leading.equalTo(guide).offset(40)
            make.trailing.equalTo(guide).offset(-40)
            make.bottom.equalTo(guide).offset(-20)
            make.height.equalTo(40)
        }
        self.button = button
        
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = .systemFont(ofSize: 16, weight: .medium)
        textView.text = viewModel.description
        textView.textAlignment = .left
        textView.accessibilityTraits = .header
        textView.isAccessibilityElement = true
        self.addSubview(textView)
        
        textView.snp.makeConstraints { (make) -> Void in
            make.leading.equalTo(button)
            make.trailing.equalTo(button)
            make.top.equalTo(imageView.snp.bottomMargin).offset(20)
            make.bottom.equalTo(button).offset(-60)
        }
        self.descriptionTextView = textView
    }
    
    @objc func didClicked(sender:UIButton) {
        handler?.didClicked(sender: sender)
    }
}

protocol ButtonClickedHandler: AnyObject {
    func didClicked(sender:UIButton)
}

