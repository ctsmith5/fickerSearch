//
//  DetailPhotoViewController.swift
//  FlickrSearch
//
//  Created by Colin Smith on 6/27/21.
//

import UIKit

class DetailPhotoViewController: UIViewController {
    
    @IBOutlet weak var tagsLabel: UILabel!
    @IBOutlet weak var linkLabel: UILabel!
    @IBOutlet weak var photoTitleLabel: UILabel!
    @IBOutlet weak var detailImage: UIImageView!
    var photoViewModel: PhotoViewModel?
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        photoViewModel?.fetchPhotoDataFrom(completion: { image in
            DispatchQueue.main.async {
                self.detailImage.image = image
                self.linkLabel.text = self.photoViewModel?.photo.link?.absoluteString
                self.photoTitleLabel.text = self.photoViewModel?.photo.title
                self.tagsLabel.text = "Tags: \(self.photoViewModel?.photo.tags ?? "")"
            }
        })
    }
}
