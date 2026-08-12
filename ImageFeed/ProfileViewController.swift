//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Алик on 01.08.2026.
//

import UIKit

final class ProfileViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(resource: .launchScreen)
        setupUI()
    }
    
    let userPhoto: UIImageView = {
        let photo = UIImageView()
        photo.image = UIImage(resource: .photo)
        photo.translatesAutoresizingMaskIntoConstraints = false
        return photo
    }()
    
    let exitIcon: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(named: "Exit")
        icon.translatesAutoresizingMaskIntoConstraints = false
        return icon
    }()
    
    let nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.text = "Екатерина Новикова"
        nameLabel.font = UIFont(name: "SF Pro-Bold", size: 23)
        nameLabel.textColor = UIColor(named: "YP White")
        return nameLabel
    }()
    
    let loginLabel: UILabel = {
        let loginLabel = UILabel()
        loginLabel.text = "@ekaterina_nov"
        loginLabel.font = UIFont(name: "SF Pro", size: 13)
        loginLabel.textColor = UIColor(named: "YP Gray (iOS)")
        return loginLabel
    }()
    
    let descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.text = "Hello, world!"
        descriptionLabel.font = UIFont(name: "SF Pro", size: 13)
        descriptionLabel.textColor = UIColor(named: "YP White")
        return descriptionLabel
    }()
    
    func setupUI() {
        let photosStackView = UIStackView(arrangedSubviews: [userPhoto, exitIcon])
        photosStackView.translatesAutoresizingMaskIntoConstraints = false
        photosStackView.axis = .horizontal
        photosStackView.distribution = .equalSpacing
        photosStackView.alignment = .center
                
        let verticalStackView = UIStackView(arrangedSubviews: [nameLabel, loginLabel, descriptionLabel])
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 8
        verticalStackView.distribution = .fill
        verticalStackView.alignment = .leading
                
        userPhoto.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        userPhoto.setContentCompressionResistancePriority(.required, for: .horizontal)
        exitIcon.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        exitIcon.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        [photosStackView, verticalStackView].forEach {
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            photosStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 76),
            photosStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            photosStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            verticalStackView.topAnchor.constraint(equalTo: photosStackView.bottomAnchor, constant: 8),
            verticalStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            verticalStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
}
