//
//  SearchData.swift
//  searchPhotoAPI
//
//  Created by admin on 10/24/21.
//

import Foundation

protocol ImageSearchDataDelegate {
    func imageSearchResponce (results: [Result], totalPage: Int)
}

struct ApiResponse:Codable {
  
    let total:Int
    let total_pages:Int
    let results:[ Result]
}

struct Result:Codable{
    let id:String
    let urls:URLS
    let links: LINKS
}

struct URLS:Codable {
    let thumb : String
    let regular:String
}

struct LINKS: Codable{
    let html: String
}

struct searchData {
    var delegate: ImageSearchDataDelegate?
    
    func fetchPhotos(query: String, pageNumber: Int = 1){
            
            let accessKey = "YTz7fZ8Qxx6rPBTCKkADzJ8NcetfzYZOekS_REIbeiQ"
            
            let urlString = "https://api.unsplash.com/search/photos?page=\(pageNumber)&per_page=30&query=\(query)&client_id=\(accessKey)"
            
            guard let url = URL(string: urlString) else {
                return
            }
            
            URLSession.shared.dataTask(with: url) {  (data, response, err) in
                
                guard let data = data, err == nil else{
                    print("error")
                    return
                }
                
                do {
                    let jsonResults = try JSONDecoder().decode(ApiResponse.self, from: data)

                    DispatchQueue.main.async {
                        delegate?.imageSearchResponce(results: jsonResults.results, totalPage: jsonResults.total_pages)
                    }
                } catch {
                    print(error)
                }
                
            }.resume()
    }
}


