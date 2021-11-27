//
//  PhotoFullScreenVC.swift
//  searchPhotoAPI
//
//  Created by admin on 10/24/21.
//

import UIKit


class PhotoFullScreenVC: UIViewController {

        @IBOutlet weak var imageView: UIImageView!
        var textToSearch: String?
        var selectedUrlString: String?
    
  override func viewDidLoad() {
        super.viewDidLoad()
    

       
        navigationItem.title = "Photo View"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open Code", style:      .plain,
        target: self,
        action: #selector(codeEdit)
    )
    
    }
    
    @objc func codeEdit() {
        let webVC = storyboard?.instantiateViewController(identifier: "WebViewController") as! WebViewController
        webVC.textOpenSource = selectedUrlString!
        
        navigationController?.pushViewController(webVC, animated: true)
    }
    
    
//    @IBAction func nextButton(_ sender: UIButton) {

//    }


    func config(with urlString:String){
        
        guard let url = URL(string: urlString)else{
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, resp, error) in
            guard let data = data , error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                self.imageView.image = image
            }
        }
        .resume()
    }
}

