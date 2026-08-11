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
            guard isViewLoaded, let image else { return }
            imageView.image = image
            rescaleAndCenterImageInScrollView(image: image)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .launchScreen
        
        imageView.image = image
        guard let image else { return }
        setupUI()
        rescaleAndCenterImageInScrollView(image: image)
        
        
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
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.maximumZoomScale = 1.25
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
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, min(hScale, vScale)))
        
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
        
        // реальные текущие размеры imageView (учитывают zoomScale)
        let imageWidth = imageView.frame.width
        let imageHeight = imageView.frame.height
        
        // Если ширина картинки меньше экрана, считаем отступ или 0
        let xOffset = imageWidth < visibleRectSize.width ? (visibleRectSize.width - imageWidth) / 2 : 0
        
        // Если высота картинки меньше экрана, считаем отступ или 0
        let yOffset = imageHeight < visibleRectSize.height ? (visibleRectSize.height - imageHeight) / 2 : 0
        
        // внутренние отступы для скроллвью
        scrollView.contentInset = UIEdgeInsets(top: yOffset, left: xOffset, bottom: yOffset, right: xOffset)
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
