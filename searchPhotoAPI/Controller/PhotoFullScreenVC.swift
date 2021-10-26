//
//  PhotoFullScreenVC.swift
//  searchPhotoAPI
//
//  Created by admin on 10/24/21.
//

import UIKit


class PhotoFullScreenVC: UIViewController {

  override func viewDidLoad() {
        super.viewDidLoad()
        addSubView()
    }
    
    let imageView:UIImageView = {
         let imageView = UIImageView()
        return imageView
        
    }()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.frame = CGRect(x: 0, y: 20, width: view.frame.size.width - imageView.frame.origin.x, height: view.frame.size.height-20)
    }
    
    func addSubView(){
        imageView.contentMode = .scaleAspectFit
        
        view.addSubview(imageView)
    }
    func config(with urlString:String){
        
        guard let url = URL(string: urlString)else{
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, resp, error) in
            guard let data = data , error == nil else {
                return
            }
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                self.imageView.image = image
            }
        }
        task.resume()
    }
}
