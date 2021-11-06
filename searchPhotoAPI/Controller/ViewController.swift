/* You need to create an app that will search images on Google by the query text.
 The API that must return the result is described here:
 https://serpapi.com/images-results
 The page must look like the page of the NavigationController where a search field must be placed
 on the top of the page where users can write the text for the query. The result images must be
 shown below the search field as a collection view.
 A tap on the preview image must open an image in the full screen view with buttons “Next” and
 “Prev” that allow users to view previous and next images from the search result. Also, please add
 a button to open the original source page. Clicking on that button must open a website on Web
 View Controller inside the app. Users can close that Web View to return to images.
 It will be good if the images are cached on a device.*/

import UIKit

class ViewController: UIViewController {
   
    @IBOutlet weak var collectionView: UICollectionView!

    var results:[Result] = []
    
    let searchBar = UISearchBar()
    var ds = searchData()
    var textToSearch: String?
    var selectedUrlString: String?
    var totalPage: Int = 1
    var pageNumber = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Search Photo" 
        searchBar.delegate = self
        view.addSubview(searchBar)
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        ds.delegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(true)
    
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchBar.frame = CGRect(x: 10, y: view.safeAreaInsets.top, width: view.frame.size.width-20, height: 50)
        collectionView?.frame = CGRect(x: 0, y: view.safeAreaInsets.top+55, width: view.frame.size.width, height: view.frame.size.height-55)
    }
    
}
// MARK: - ImageSearchDataDelegate

extension ViewController: ImageSearchDataDelegate {
        func imageSearchResponce(results: [Result], totalPage: Int) {
            self.results = results
            self.totalPage = totalPage
            collectionView.reloadData()
    }
    
    
}

// MARK: - UICollectionViewDelegate and UICollectionViewDataSource

extension ViewController:UICollectionViewDelegate,UICollectionViewDataSource{
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return results.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let imageUrlString = results[indexPath.item].urls.thumb
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as! ImageCollectionViewCell
            cell.config(with: imageUrlString)
            return cell
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let imgUrl = results[indexPath.item].urls.regular
            let vc = storyboard?.instantiateViewController(identifier: "PhotoFullScreenVC") as! PhotoFullScreenVC
            vc.config(with: imgUrl)
            self.navigationController?.pushViewController(vc, animated: true)
        }
 }
// MARK: - UISearchBarDelegate

extension ViewController: UISearchBarDelegate {
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            searchBar.resignFirstResponder()
            if let text = searchBar.text{
                results = []
                collectionView?.reloadData()
                ds.fetchPhotos(query: text, pageNumber: pageNumber)
        }
    }
}

