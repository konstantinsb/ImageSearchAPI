//
//  ViewController.swift
//  searchPhotoAPI
//
//  Created by admin on 10/24/21.
//

import UIKit

struct APIResponse: Codable {
    let images_results: [Image]
}
struct Image: Codable {
    let thumbnail: String
}

class ViewController: UIViewController, UICollectionViewDataSource, UISearchBarDelegate {
   
    var images_results: [Image] = []
    
    private var collectionView: UICollectionView?
    
    let searchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        view.addSubview(searchBar)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: view.frame.size.width/2, height: view.frame.size.width/2)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
        collectionView.dataSource = self
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        self.collectionView = collectionView
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchBar.frame = CGRect(x: 10, y: view.safeAreaInsets.top, width: view.frame.size.width-20, height: 50)
        collectionView?.frame = CGRect(x: 0, y: view.safeAreaInsets.top+55, width: view.frame.size.width, height: view.frame.size.height-55)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let text = searchBar.text{
            images_results = []
            collectionView?.reloadData()
            fetchPhoto(query: text)
        }
        
        
    }
    func fetchPhoto(query: String) {
        let urlString = "https://serpapi.com/search.json?&tbm=isch&ijn=0&api_key=e1b2aa717aea8d46f62754b32d03ed4dc0f7fe11d82fdfcd8774ca2dfc223920&q=\(query)"
        guard let url = URL(string: urlString) else {return}
        URLSession.shared.dataTask(with: url) {[weak self] data, _, error in
            guard let data = data, error == nil else { return}
            do {
                let jsonResult = try JSONDecoder().decode(APIResponse.self, from: data)
                DispatchQueue.main.async {
                    self?.images_results = jsonResult.images_results
                    self?.collectionView?.reloadData()
                }
                
            }catch {
                print(error)
            }
        }
        .resume()
    }
    
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
}

