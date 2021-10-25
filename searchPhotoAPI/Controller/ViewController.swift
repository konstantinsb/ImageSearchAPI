//
//  ViewController.swift
//  searchPhotoAPI
//
//  Created by admin on 10/24/21.
//

import UIKit

class ViewController: UIViewController {
   
    @IBOutlet weak var collectionView: UICollectionView!

    
    var images_results: [Image] = []

    let searchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        view.addSubview(searchBar)
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
        collectionView.dataSource = self
        searchBar.delegate = self
        
    }
    

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchBar.frame = CGRect(x: 10, y: view.safeAreaInsets.top, width: view.frame.size.width-20, height: 50)
        collectionView?.frame = CGRect(x: 0, y: view.safeAreaInsets.top+55, width: view.frame.size.width, height: view.frame.size.height-55)
    }
    
    func fetchPhoto(query: String) {
        let urlString = "https://serpapi.com/search.json?&tbm=isch&ijn=0&api_key=e1b2aa717aea8d46f62754b32d03ed4dc0f7fe11d82fdfcd8774ca2dfc223920&q=\(query)"
        guard let url = URL(string: urlString) else {return}
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return}
            do {
                let jsonResult = try JSONDecoder().decode(APIResponse.self, from: data)
                DispatchQueue.main.async {
                    self.images_results = jsonResult.images_results
                    self.collectionView?.reloadData()
                }
                
            }catch {
                print(error)
            }
        }
        .resume()
    }

}
// MARK: - UICollectionViewDataSource

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images_results.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let imageURLString = images_results[indexPath.item].thumbnail
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as? ImageCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: imageURLString)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainStoryBoard.instantiateViewController(withIdentifier: "PhotoFullScreenVC") as! PhotoFullScreenVC

        vc.imageReceived = UIImage(named: images_results[indexPath.item].thumbnail)!
        navigationController?.pushViewController(vc, animated: true)
        
        
    }
       
}
// MARK: - UISearchBarDelegate
extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let text = searchBar.text{
            images_results = []
            collectionView?.reloadData()
            fetchPhoto(query: text)
        }
    }
}

