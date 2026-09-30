//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Алик on 05.08.2026.
//

import UIKit
import Kingfisher

final class SingleImageViewController: UIViewController {
    
    var photo: Photo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .launchScreen
        setupUI()
        loadImage()
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
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.maximumZoomScale = 2.5
        scrollView.minimumZoomScale = 0.1
        scrollView.delegate = self
        return scrollView
    }()
    
    private lazy var sharingButton: UIButton = {
        let sharingButton = UIButton()
        let buttonAction = UIAction { [weak self] _ in
            self?.didTapShareButton()
        }
        sharingButton.addAction(buttonAction, for: .touchUpInside)
        sharingButton.setBackgroundImage(UIImage(named: "Ellipse"), for: .normal)
        sharingButton.setImage(UIImage(named: "Sharing"), for: .normal)
        
        sharingButton.translatesAutoresizingMaskIntoConstraints = false
        return sharingButton
    }()
    
    func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        
        //view.addSubview(imageView)
        view.addSubview(backButton)
        view.addSubview(sharingButton)
        
        NSLayoutConstraint.activate([
            
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 9),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            backButton.widthAnchor.constraint(equalToConstant: 44),
            backButton.heightAnchor.constraint(equalToConstant: 44),
            
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            imageView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            
            sharingButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -17),
            sharingButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        
        guard visibleRectSize.width > 0, visibleRectSize.height > 0, imageSize.width > 0, imageSize.height > 0 else { return }
        
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))
        
        scrollView.setZoomScale(scale, animated: false)
        
        scrollView.contentSize = CGSize(width: imageSize.width * scale, height: imageSize.height * scale)
        scrollView.layoutIfNeeded()
        
        centerImage()
    }
    
    private func didTapShareButton() {
        guard let imageForSharing = imageView.image else { return }
        let activityViewController = UIActivityViewController(activityItems: [imageForSharing], applicationActivities: nil)
        self.present(activityViewController, animated: true)
    }
    
    private func centerImage() {
        let visibleRectSize = scrollView.bounds.size
        let imageWidth = imageView.frame.width
        let imageHeight = imageView.frame.height
        
        scrollView.contentInset = .zero
        
        // 2. Рассчитываем сдвиг для центрирования, если картинка больше экрана
        let xOffset = imageWidth > visibleRectSize.width ? (imageWidth - visibleRectSize.width) / 2 : 0
        let yOffset = imageHeight > visibleRectSize.height ? (imageHeight - visibleRectSize.height) / 2 : 0
        
        scrollView.setContentOffset(CGPoint(x: xOffset, y: yOffset), animated: false)
    }
    
    private func loadImage() {
        guard let photo, let imageURL = URL(string: photo.fullImageURL) else { return }
        UIBlockingProgressHUD.show()
        imageView.kf.indicatorType = .activity
        setImage(with: imageURL)
    }
    
    func setImage(with url: URL) {
        imageView.image = nil
        imageView.kf.setImage(with: url, placeholder: nil) { [ weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self else { return }
            
            switch result {
            case .success(let value):
                let downloadedImage = value.image
                self.rescaleAndCenterImageInScrollView(image: downloadedImage)
            case .failure(let error):
                print("Ошибка загрузки \(error)")
                self.showError(with: url)
            }
        }
    }
    
    
    private func showError(with url: URL) {
        let alert = UIAlertController(title: "Что-то пошло не так", message: "Попробовать ещё раз?", preferredStyle: .alert)
        let actionRetry = UIAlertAction(title: "Повторить", style: .default) { [weak self] _ in
            guard let self else { return }
            self.setImage(with: url)
        }
        let actionCancel = UIAlertAction(title: "Не надо", style: .cancel, handler: nil)
        alert.addAction(actionRetry)
        alert.addAction(actionCancel)
        self.present(alert, animated: true)
    }
    
}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.centerImage()
        }
    }
}
