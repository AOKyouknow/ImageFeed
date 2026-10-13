//
//  ProfilePresenter.swift
//  ImageFeed
//
//  Created by Алик on 13.10.2026.
//

import Foundation

protocol ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
        func viewDidLoad()
    func didTapLogoutButton()
    func logOut()
}

class ProfilePresenter: ProfilePresenterProtocol {
    weak var view: ProfileViewControllerProtocol?
    let profileService = ProfileService.shared
    
    func viewDidLoad() {
            guard let currentProfile = profileService.profile else {
                print("Экран профиля открылся, но данные в ProfileService.shared не загружены")
                return
            }
        // Передаем данные профиля на обработку
        updateUI(with: currentProfile)
        updateAvatar()
        
        NotificationCenter.default.addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                self?.updateAvatar()
            }
        }
    
    private func updateUI(with profile: ProfileService.Profile) {
            let nameText = profile.name.isEmpty ? "имя не указано" : profile.name
            let loginText = profile.loginName.isEmpty ? "неизвестный пользователь" : profile.loginName
            let bioText = (profile.bio?.isEmpty ?? true) ? "Профиль не заполнен" : (profile.bio ?? "")
            
            view?.updateProfileDetails(name: nameText, login: loginText, bio: bioText)
        }
    
    func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        
        view?.setAvatar(with: url)
    }
    
    func didTapLogoutButton() {
        view?.showLogoutAlert()
    }
    
    func logOut() {
        ProfileLogoutService.shared.logout()
    }
    
    deinit {
            NotificationCenter.default.removeObserver(self)
        }
}
