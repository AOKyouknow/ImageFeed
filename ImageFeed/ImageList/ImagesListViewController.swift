//
//  ViewController.swift
//  ImageFeed
//
//  Created by Алик on 26.07.2026.
//

import UIKit
import Kingfisher

final class ImagesListViewController: UIViewController {
    private let imageListService = ImageListService()
    private var photos: [Photo] = []
    
    private let table: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        
        return table
    }()
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        
        table.estimatedRowHeight = 200 // убирает дёрганье скролла
        table.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
                
        table.register(
            ImagesListCell.self,
            forCellReuseIdentifier: ImagesListCell.reuseIdentifier
        )
        
        setupUI()
        imageListService.fetchPhotosNextPage()
        NotificationCenter.default.addObserver(
            forName: ImageListService.didChangeNotification,
            object: nil,
            queue: .main) { [weak self] _ in
                guard let self else { return }
                self.updateTableViewAnimated()
        }
    }
    
    func configCell(for cell: ImagesListCell, with photo: Photo, imageURL: URL) {
        cell.cellImageView.kf.indicatorType = .activity
        cell.cellImageView.kf.setImage(with: imageURL, placeholder: UIImage(named: "Stub")) { [ weak self ] result in
            guard let self else { return }
            switch result {
            case .success:
                self.table.performBatchUpdates(nil, completion: nil)
            case .failure(let error):
                print("Kingfisher ошибка загрузки: \(error)")
            }
        }
        
        if let createdAt = photo.createdAt {
            cell.dateLabel.text = dateFormatter.string(from: createdAt)
        } else {
            cell.dateLabel.text = ""
        }
        
        let likeImage = photo.isLiked ? UIImage(named: "Active") : UIImage(named: "No Active")
        cell.likeButton.setImage(likeImage, for: .normal)
        
    }
    
    func setupUI() {
        table.backgroundColor = .launchScreen
        table.separatorStyle = .none
        view.addSubview(table)
        
        NSLayoutConstraint.activate([
            table.topAnchor.constraint(equalTo: view.topAnchor),
            table.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            table.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            table.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let singleImageViewController = SingleImageViewController()
        singleImageViewController.modalPresentationStyle = .fullScreen
        
        singleImageViewController.photo = photos[indexPath.row]
        
        self.present(singleImageViewController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let photo = photos[indexPath.row]
        
//        guard let image = UIImage(named: photos[indexPath.row].thumbImageURL) else {
//            return 0
//        }
        
        let imageViewWidth = tableView.bounds.width - 32 // 16+16 - отступы в ImageListCell
        
        let imageViewHeight = imageViewWidth * (photo.size.height / photo.size.width)
        
        let cellHeight = imageViewHeight + 8 // 4 сверху + 4 снизу
        
        return cellHeight
    }
    
    
    func updateTableViewAnimated() {
        let oldCount = table.numberOfRows(inSection: 0)
        photos = imageListService.photos
        let newCount = photos.count
        
        if oldCount < newCount {
            let indexPaths = (oldCount..<newCount).map {
                IndexPath(row: $0, section: 0)
            }
            table.performBatchUpdates {
                table.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
    }
    
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        let photo = photos[indexPath.row]
        guard let thumbnailURL = URL(string: photo.thumbImageURL) else {
            return imageListCell
        }
        
        configCell(for: imageListCell, with: photo, imageURL: thumbnailURL)
        return imageListCell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //метод вызывается прямо перед тем, как ячейка таблицы будет показана на экране
        guard indexPath.row + 1 == photos.count else { return }
        imageListService.fetchPhotosNextPage()
    }
}
