//
//  SearchData.swift
//  searchPhotoAPI
//
//  Created by admin on 10/24/21.
//

import Foundation

protocol ImageSearchDataDelegate {
    func imageSearchResponce (results: [Result])
}

struct ApiResponse: Codable {
    let images_results : [Result]
}

struct Result: Codable {
    let position: Int
    let thumbnail: String
    let link: String
    let original: String
}

struct searchData {
    var delegate: ImageSearchDataDelegate?
    
    func fetchPhotos(query: String, pageNumber: Int = 1){
            
            let accessKey = "e1b2aa717aea8d46f62754b32d03ed4dc0f7fe11d82fdfcd8774ca2dfc223920"
            
            let urlString = "https://serpapi.com/search.json?q=\(query)&tbm=isch&ijn=0&api_key=\(accessKey)"
            
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
                        delegate?.imageSearchResponce(results: jsonResults.images_results)
                    }
                } catch {
                    print(error)
                }
                
            }.resume()
    }
}


