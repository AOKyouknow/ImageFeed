//
//  ViewController.swift
//  ImageFeed
//
//  Created by Алик on 26.07.2026.
//

import UIKit
import Kingfisher

protocol ImagesListViewControllerProtocol: AnyObject {
    var presenter: ImagesListPresenterProtocol? { get set }
    func updateTableViewAnimated(oldCount: Int, newCount: Int)
    func updateCellLikeStatus(at indexPath: IndexPath, isLiked: Bool)
    func showLikeErrorAlert()
    func navigateToSingleImage(with photo: Photo)
    func reloadTableRows(at indexPaths: [IndexPath])
}

final class ImagesListViewController: UIViewController {
    var presenter: ImagesListPresenterProtocol?
    
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
        table.estimatedRowHeight = 200
        table.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        table.register(ImagesListCell.self, forCellReuseIdentifier: ImagesListCell.reuseIdentifier)
        
        setupUI()
        
        presenter?.viewDidLoad()
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
    
    private func configCell(for cell: ImagesListCell, with photo: Photo) {
        guard let imageURL = URL(string: photo.thumbImageURL) else { return }
        
        cell.cellImageView.kf.indicatorType = .activity
        cell.cellImageView.kf.setImage(with: imageURL, placeholder: UIImage(named: "Stub")) { [weak self] result in
            guard let self = self else { return }
            if case .success = result {
                self.table.performBatchUpdates(nil, completion: nil)
            }
        }
        
        if let createdAt = photo.createdAt {
            cell.dateLabel.text = dateFormatter.string(from: createdAt)
        } else {
            cell.dateLabel.text = ""
        }
        
        cell.setIsLiked(isLiked: photo.isLiked)
    }
}

// MARK: - ImagesListViewControllerProtocol
extension ImagesListViewController: ImagesListViewControllerProtocol {
    
    func updateTableViewAnimated(oldCount: Int, newCount: Int) {
        if oldCount < newCount {
            let indexPaths = (oldCount..<newCount).map { IndexPath(row: $0, section: 0) }
            table.performBatchUpdates {
                table.insertRows(at: indexPaths, with: .automatic)
            }
        }
    }
    
    func updateCellLikeStatus(at indexPath: IndexPath, isLiked: Bool) {
        if let cell = table.cellForRow(at: indexPath) as? ImagesListCell {
            cell.setIsLiked(isLiked: isLiked)
        }
    }
    
    func showLikeErrorAlert() {
        let alert = UIAlertController(title: "Что-то пошло не так", message: "Не удалось изменить статус лайка", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default))
        present(alert, animated: true)
    }
    
    func navigateToSingleImage(with photo: Photo) {
        let singleImageViewController = SingleImageViewController()
        singleImageViewController.modalPresentationStyle = .fullScreen
        singleImageViewController.photo = photo
        present(singleImageViewController, animated: true)
    }
    
    func reloadTableRows(at indexPaths: [IndexPath]) {
        table.reloadRows(at: indexPaths, with: .none)
    }
}

// MARK: - UITableViewDelegate / DataSource
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter?.didSelectRow(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let imageViewWidth = tableView.bounds.width - 32
        return presenter?.getCellHeight(forWidth: imageViewWidth, at: indexPath.row) ?? 200
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        presenter?.willDisplayCell(at: indexPath.row)
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.photosCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        guard let imageListCell = cell as? ImagesListCell,
              let photo = presenter?.getPhoto(at: indexPath.row) else {
            return UITableViewCell()
        }
        imageListCell.delegate = self
        configCell(for: imageListCell, with: photo)
        return imageListCell
    }
}

// MARK: - ImagesListCellDelegate
extension ImagesListViewController: ImagesListCellDelegate {
    func imagesListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = table.indexPath(for: cell) else { return }
        
        UIBlockingProgressHUD.show()
        presenter?.changeLike(at: indexPath) { _ in
            UIBlockingProgressHUD.dismiss()
        }
    }
}
