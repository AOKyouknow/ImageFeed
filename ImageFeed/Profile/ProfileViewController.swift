//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Алик on 01.08.2026.
//

import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    
    let profileService = ProfileService.shared
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(resource: .launchScreen)
        setupUI()
        NotificationCenter.default.addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                self?.updateAvatar()
            }

        guard let currentProfile = profileService.profile else {
            print("Экран профиля открылся, но данные в ProfileService.shared не загружены")
            return
        }
        updateUI(with: currentProfile)
        updateAvatar()
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
    
    var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.text = "Екатерина Новикова"
        nameLabel.font = UIFont(name: "SFProText-Bold", size: 23)
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
    
    func updateUI(with profile: ProfileService.Profile) {
        nameLabel.text = profile.name.isEmpty
        ? "имя не указано"
        : profile.name
        loginLabel.text = profile.loginName.isEmpty
        ? "неизвестный пользователь"
        : profile.loginName
        descriptionLabel.text = (profile.bio?.isEmpty ?? true) //
        ? "Профиль не заполнен"
        : profile.bio
    }
    
    private func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        
        userPhoto.kf.setImage(with: url)
    }
}
