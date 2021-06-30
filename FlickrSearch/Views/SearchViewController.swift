//
//  ViewController.swift
//  FlickrSearch
//
//  Created by Colin Smith on 6/26/21.
//
import CoreLocation
import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var flickerSearchBar: UISearchBar!
    @IBOutlet weak var photoTableView: UITableView!
    
    var locationManager: CLLocationManager?
    
    var searchText: String = "" {
        didSet {
            sendSearchTerm(searchText: self.searchText)
        }
    }
    var photos: [FlickerPhoto] = []
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        flickerSearchBar.delegate = self
        photoTableView.delegate = self
        photoTableView.dataSource = self
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
        
    }

    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        locationManager?.startUpdatingLocation()
        
    }
    
    
    fileprivate func sendSearchTerm(searchText: String) {
        if searchText.isEmpty {
            self.photos = []
            DispatchQueue.main.async {
                self.photoTableView.reloadData()
            }
        } else {
            FlickrClient.shared.fetchPhotosBy(searchTerm: searchText) { photoData, error  in
                //Data Returns
                let returnedPhotos = photoData.compactMap({$0})
                self.photos = returnedPhotos
                DispatchQueue.main.async {
                    self.photoTableView.reloadData()
                }
            }
        }
    }
}


extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = PhotoViewModel(photo: photos[indexPath.row])
        guard let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "PhotoTableViewCell", for: indexPath) as? PhotoTableViewCell else { return UITableViewCell() }
        tableViewCell.viewModel = viewModel
        return tableViewCell

    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        guard let detailView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "ImageDetailView") as? DetailPhotoViewController,
        let root = UIApplication.shared.windows.first?.rootViewController as? SearchViewController else { return }
        let cell = tableView.cellForRow(at: indexPath) as! PhotoTableViewCell
        detailView.photoViewModel = cell.viewModel
        root.present(detailView, animated: true, completion: nil)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        sendSearchTerm(searchText: searchText)
    }
    
}


extension SearchViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager?.stopUpdatingLocation()
        guard let location = locations.last else { return }
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            guard let locality = placemarks?.compactMap({$0.locality}).first,
                  let state = placemarks?.compactMap({$0.administrativeArea}).first else { return }
            self.flickerSearchBar.text = "\(locality), \(state)"
        }
    }
    
}
