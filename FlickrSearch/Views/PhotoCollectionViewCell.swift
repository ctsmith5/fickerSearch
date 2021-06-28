//
//  PhotoCollectionViewCell.swift
//  FlickrSearch
//
//  Created by Colin Smith on 6/26/21.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var photoCellActivityView: UIActivityIndicatorView!
    var viewModel: PhotoViewModel? {
        didSet {
            photoCellActivityView.startAnimating()
            guard let viewModel = viewModel else { return }
            viewModel.fetchPhotoDataFrom { image in
                DispatchQueue.main.async {
                    self.photoImageView.image = image
                    self.photoCellActivityView.stopAnimating()
                    self.photoCellActivityView.isHidden = true
                }
            }
        }
    }
}
