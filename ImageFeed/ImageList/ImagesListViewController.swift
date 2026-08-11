//
//  ViewController.swift
//  ImageFeed
//
//  Created by Алик on 26.07.2026.
//

import UIKit

class ImagesListViewController: UIViewController {
            
    private let photosName: [String] = Array(0..<20).map{ "\($0)" }
    
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
        
        table.rowHeight = 200
        table.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
                
        table.register(
            ImagesListCell.self,
            forCellReuseIdentifier: ImagesListCell.reuseIdentifier
        )
        
        setupUI()
        
    }
    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        
        let imageName = photosName[indexPath.row]
        guard let image = UIImage(named: imageName) else {
            print("Ошибка!")
            return
        }
        cell.cellImageView.image = image
        
        let currentDateString = dateFormatter.string(from: Date())
        cell.dateLabel.text = currentDateString
        
        
        let isLiked = indexPath.row % 2 == 0
        let likeImage = isLiked ? UIImage(named: "Active") : UIImage(named: "No Active")
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
        
        let imageName = photosName[indexPath.row]
        singleImageViewController.image = UIImage(named: imageName)
        
        self.present(singleImageViewController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let image = UIImage(named: photosName[indexPath.row]) else {
            return 0
        }
        
        let imageViewWidth = tableView.bounds.width - 32
        
        
        let imageWidth = image.size.width
        let imageHeight = image.size.height
        
        let imageViewHeight = imageViewWidth * (imageHeight / imageWidth)
        
        let cellHeight = imageViewHeight + 8
        
        return cellHeight
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photosName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        configCell(for: imageListCell, with: indexPath)
        return imageListCell
    }
    
    
}
