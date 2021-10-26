//
//  ViewController.swift
//  searchPhotoAPI
//
//  Created by admin on 10/24/21.
//

import UIKit

class ViewController: UIViewController {
   
    @IBOutlet weak var collectionView: UICollectionView!

    var result:[Result] = []
    
    let searchBar = UISearchBar()
    
    let alert = UIAlertController(title: "Error", message: "Check Your Internet Connection", preferredStyle: .alert)
    let alertAction = UIAlertAction(title: "Error", style: .default, handler: nil)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alert.addAction(alertAction)
        searchBar.delegate = self
        view.addSubview(searchBar)
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
        collectionView.dataSource = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(true)
    
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchBar.frame = CGRect(x: 10, y: view.safeAreaInsets.top, width: view.frame.size.width-20, height: 50)
        collectionView?.frame = CGRect(x: 0, y: view.safeAreaInsets.top+55, width: view.frame.size.width, height: view.frame.size.height-55)
    }
    
    func fetchData(Query:String){
           let urlString = "https://api.unsplash.com/search/photos?page=1&per_page=30&query=\(Query)&client_id=WuBEAXzCr0cnJ1hAgugDx1R5ITlvME5YaxgLc-wrUFE"
           
           guard let url = URL(string: urlString) else { return }
           let task = URLSession.shared
           
           task.dataTask(with: url) { [self] (data, resp, error) in
               if let data = data{
                   do{
                       let jsonResult = try JSONDecoder().decode(ApiResponse.self, from: data)
                       
                       DispatchQueue.main.async {
                           self.result = jsonResult.results
                           self.collectionView?.reloadData()
                       }
                     }
                   catch{
                       print(error.localizedDescription)
                       
                   }
                }
               else{
                   DispatchQueue.main.async {
                       
                       self.present(alert, animated: true, completion: nil)
                       self.collectionView?.isHidden = true
                       
                   }
               }
           }.resume()
    }
}
// MARK: - UICollectionViewDataSource

extension ViewController:UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return result.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let imageUrlString = result[indexPath.row].urls.thumb
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as! ImageCollectionViewCell
        cell.config(with: imageUrlString)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
 
         let imgUrl = result[indexPath.row].urls.regular
        
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
            result = []
            collectionView?.reloadData()
            fetchData(Query: text)
        }
    }
}

