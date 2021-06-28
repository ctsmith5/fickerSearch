//
//  PhotoViewModel.swift
//  FlickrSearch
//
//  Created by Colin Smith on 6/26/21.
//

import Foundation
import UIKit

class PhotoViewModel {
  
    var photo: FlickerPhoto
    
    init(photo: FlickerPhoto) {
        self.photo = photo
    }
    
    func fetchPhotoDataFrom(completion: @escaping (UIImage) -> Void) {
        FlickrClient.shared.getImageFromLink(url: self.photo.link) { data in
            //Data is returned by going to the link.
            guard let image = UIImage(data: data) else { return }
            completion(image)
        }
    }
}
