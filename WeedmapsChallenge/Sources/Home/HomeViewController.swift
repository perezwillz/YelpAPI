//
//  Copyright © 2018 Weedmaps, LLC. All rights reserved.
//

import UIKit
import Alamofire

class HomeViewController: UIViewController {

    // MARK: Properties
    
    @IBOutlet private var collectionView: UICollectionView!
    
    private var searchController = UISearchController(searchResultsController: nil)
    private var searchResults = [Business]()
    private var searchRequest: DataRequest?
    
    private let cellID = String.businessCellID
    private let locationManager = LocationManager()
    private let yelpManager = YelpManager()
    private var searchTerm = ""
    private var page = 1
    private var lat = 0.0
    private var lon = 0.0
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: .businessCellID, bundle: nil), forCellWithReuseIdentifier: cellID)
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        
        NotificationCenter.default.addObserver(self, selector: #selector(historySelected), name: .historySelected, object: nil)
    }
    
    func newSearch(_ searchTerm: String) {
        self.searchTerm = searchTerm
        guard let (lat, lon) = locationManager.location else {
            let alertController = UIAlertController(title: .locationAlertTitle, message: .noLocation, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            present(alertController, animated: true)
            return
        }
        self.lat = lat
        self.lon = lon
        page = 1
        
        // cancel old dataTask
        searchRequest?.cancel()
        // create new dataTask
        // self.searchDataTask = dataTask
        searchRequest = yelpManager.search(term: searchTerm, latitude: "\(lat)", longitude: "\(lon)", page: page) { businesses, error in
            
            if error != nil {
                NSLog(Errors.badURL.rawValue)
            }
            guard let businesses = businesses else { return }
            self.searchResults = businesses
            self.collectionView.reloadData()
        }
    }
    
    @objc func historySelected(_ notification: Notification) {
        guard let searchTerm = notification.object as? String else { return }
        newSearch(searchTerm)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == .showWebViewController {
            guard let destination = segue.destination as? HomeDetailViewController,
                let url = sender as? URL else { return }
            destination.urlToOpen = url
        } else if segue.identifier == .showHistory {
            guard let destination = segue.destination as? HistoryTableViewController else { return }
            destination.history = yelpManager.searchTermHistory
        }
    }
}

// MARK: UISearchResultsUpdating

extension HomeViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
         
        guard let term = searchController.searchBar.text, !term.isEmpty, term != searchTerm else { return }
        searchTerm = term
        newSearch(searchTerm)
    }
}

// MARK: UICollectionViewDelegate

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let business = searchResults[indexPath.row]
        guard let url = URL(string: business.url) else { return }
        let alert = UIAlertController(title: .openIn, message: nil, preferredStyle: .actionSheet)
        let safariAction = UIAlertAction(title: .safari, style: .default) { _ in
            UIApplication.shared.open(url)
        }
        let webViewAction = UIAlertAction(title: .inApp, style: .default) { _ in
            self.performSegue(withIdentifier: .showWebViewController, sender: url)
        }
        alert.addAction(safariAction)
        alert.addAction(webViewAction)
        alert.addAction(UIAlertAction(title: .cancel, style: .cancel))
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath)
        }
        present(alert, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == searchResults.count - 1 {
            page += 1
            yelpManager.search(term: searchTerm, latitude: "\(lat)", longitude: "\(lon)", page: page, isNewTerm: false) { businesses, error in
                guard let businesses = businesses else { return }
                self.searchResults.append(contentsOf: businesses)
                self.collectionView.reloadData()
            }
        }
    }
}

// MARK: UICollectionViewDataSource

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as? BusinessCell else { return UICollectionViewCell() }
        let business = searchResults[indexPath.row]
        cell.nameLabel.text = business.name
        yelpManager.getImage(for: business) { image in
            cell.imageView.image = image
        }
        return cell
    }
}
