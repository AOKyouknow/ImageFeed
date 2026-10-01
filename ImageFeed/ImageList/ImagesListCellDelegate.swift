//
//  ImageListCellDelegate.swift
//  ImageFeed
//
//  Created by Алик on 27.09.2026.
//

import Foundation

protocol ImagesListCellDelegate: AnyObject {
    func imagesListCellDidTapLike(_ cell: ImagesListCell)
}
