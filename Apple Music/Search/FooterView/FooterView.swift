//
//  FooterView.swift
//  Apple Music
//
//  Created by Vlad Lytvynets on 02.07.2021.
//

import UIKit

class FooterView: UIView {
    
    private var mylabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        return label
    }()
    
    
    private var loader: UIActivityIndicatorView = {
       let loader = UIActivityIndicatorView()
        loader.translatesAutoresizingMaskIntoConstraints = false
        loader.hidesWhenStopped = true
        return loader
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupElements()
    }
    
    
    private func setupElements(){
        addSubview(mylabel)
        addSubview(loader)
        loader.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        loader.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        loader.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        mylabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        mylabel.topAnchor.constraint(equalTo: loader.bottomAnchor, constant: 8).isActive = true
    }
    
    
    func showLoader(){
        loader.startAnimating()
        mylabel.text = "LOADING"
    }
    
    
    func hideLoader() {
        loader.stopAnimating()
        mylabel.text = ""
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
