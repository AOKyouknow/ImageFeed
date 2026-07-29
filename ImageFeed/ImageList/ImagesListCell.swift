//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Алик on 29.07.2026.
//

import Foundation
import UIKit

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    
    
    
    // Основная картинка
    let cellImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // Кнопка лайка
    let likeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "No Active"), for: .normal)
        button.setImage(UIImage(named: "Active"), for: .selected)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // Лейбл даты
    let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    
    // Инициализатор ячейки
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    private func setupUI() {
        // прозрачный фон
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(cellImageView)
        cellImageView.addSubview(dateLabel)
        cellImageView.addSubview(likeButton)
        
        
        
        NSLayoutConstraint.activate([
            cellImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            cellImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            cellImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cellImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            likeButton.topAnchor.constraint(equalTo: cellImageView.topAnchor),
            likeButton.trailingAnchor.constraint(equalTo: cellImageView.trailingAnchor),
            likeButton.widthAnchor.constraint(equalToConstant: 44),
            likeButton.heightAnchor.constraint(equalToConstant: 44),
            
            dateLabel.leadingAnchor.constraint(equalTo: cellImageView.leadingAnchor, constant: 8),
            dateLabel.bottomAnchor.constraint(equalTo: cellImageView.bottomAnchor, constant: -8),
            dateLabel.trailingAnchor.constraint(equalTo: cellImageView.trailingAnchor, constant: -8)
        ])
    }
    
}
