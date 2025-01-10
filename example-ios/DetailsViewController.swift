//
//  DetailsViewController.swift
//  example-ios
//
//  Created by Рафаэль Голубев on 10.01.2025.
//

import UIKit

class DetailsViewController: UIViewController {
    
    override func loadView() {
        super.loadView()
        
        title = "Описание"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemOrange
        setupUI()
    }
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemRed
        
        return view
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .label
        label.text = "Hello, world"
        
        return label
    }()
}

private extension DetailsViewController {
    func setupUI() {
        view.addSubview(contentView) { superview, contentView in
            view.topAnchor.constraint(equalTo: contentView.topAnchor)
            view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        }
        
        contentView.addSubview(label) { superview, label in
            label.centerYAnchor.constraint(equalTo: superview.centerYAnchor)
            label.leadingAnchor.constraint(equalTo: superview.leadingAnchor)
            label.trailingAnchor.constraint(equalTo: superview.trailingAnchor)
            label.heightAnchor.constraint(equalToConstant: 50)
        }
    }
}

#Preview {
    UINavigationController(rootViewController:
        DetailsViewController()
    )
}
