//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Алик on 05.08.2026.
//

import UIKit

class SingleImageViewController: UIViewController {
    
    var image: UIImage? {
        didSet { // вот для чего наблюдатель - добавить условие до присвоения!
            guard isViewLoaded else { return }
            imageView.image = image
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .launchScreen
        
        imageView.image = image
        
        setupUI()
    }
    
    private lazy var backButton: UIButton = {
      let backButton = UIButton()
        backButton.tintColor = .white
        let buttonAction = UIAction { [weak self] _ in
            self?.dismiss(animated: true, completion: nil)
        }
        backButton.addAction(buttonAction, for: .touchUpInside)
        backButton.setImage(UIImage(named: "Backward"), for: .normal)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        return backButton
    }()
    
    private var imageView: UIImageView = {
        let image = UIImageView()
        //image.image = UIImage(named: "0")
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    func setupUI() {
        
        view.addSubview(imageView)
        view.addSubview(backButton)

        NSLayoutConstraint.activate([
        
            imageView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
        
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 9),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            backButton.widthAnchor.constraint(equalToConstant: 44),
            backButton.heightAnchor.constraint(equalToConstant: 44)
        
        ])
        
        
    }
    
}
