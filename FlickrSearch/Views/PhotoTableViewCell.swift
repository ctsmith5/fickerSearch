//
//  PhotoTableViewCell.swift
//  FlickrSearch
//
//  Created by Colin Smith on 6/28/21.
//

import UIKit

class PhotoTableViewCell: UITableViewCell {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var widthLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    
    var viewModel: PhotoViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
        activityIndicator.startAnimating()
        photoImageView.isHidden = true
        DispatchQueue.global(qos: .userInteractive).async {
            self.viewModel?.fetchPhotoDataFrom(completion: { image in
                DispatchQueue.main.async {
                    self.photoImageView.image = image
                    self.photoImageView.isHidden = false
                    self.activityIndicator.stopAnimating()
                }
            })
        }
        DispatchQueue.main.async {
            self.titleLabel.text = self.viewModel?.photo.title
            self.widthLabel.text = "W: \(self.photoImageView.image?.size.width ?? 0.0)"
            self.heightLabel.text = "H: \(self.photoImageView.image?.size.height ?? 0.0)"
        }
    }

}
