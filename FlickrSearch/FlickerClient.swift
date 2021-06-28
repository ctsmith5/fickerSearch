//
//  FlickerClient.swift
//  FlickrSearch
//
//  Created by Colin Smith on 6/26/21.
//
import Foundation


struct FlickrClient {

    static let photoURLString = "https://api.flickr.com/services/feeds/photos_public.gne?tagmode=any&format=json&nojsoncallback=1&tags="
    
    static let shared = FlickrClient()
    
    ///Function will make call to Flicker API to retrieve Image Data
    ///Parameters - Search Term : Completion of Data that will be used to convert  image
    func fetchPhotosBy(searchTerm: String, completion: @escaping ([(FlickerPhoto?)],Error?) -> Void) {
            if let url = URL(string: FlickrClient.photoURLString + searchTerm)  {
                let request = URLRequest(url: url)

               URLSession.shared.dataTask(with: request) { data, response, error in
                    if let data = data {
                        if let decodedResponse = try? JSONDecoder().decode(FlickrResponse.self, from: data) {
                            
                            let items = decodedResponse.items.compactMap({FlickerPhoto(link: URL(string: $0.media.value),
                                title: $0.title,
                                width: "240" ,
                                height:"180",
                                tags: $0.tags ) })
                            completion(items, nil)
                        }
                    }
                    if let error = error {
                        completion([nil],error)
                    }
                    print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
               }.resume()
            }
    }
    
    ///Function will simply gain the Data associated with the link as a jpg image  in the background
    func getImageFromLink(url: URL?, completion: @escaping (Data) -> Void) {
        guard let url = url else { return }
        if let data = try? Data(contentsOf: url) {
            completion(data)
        }
    }
}
