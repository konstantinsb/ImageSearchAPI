//
//  SearchData.swift
//  searchPhotoAPI
//
//  Created by admin on 10/24/21.
//

import Foundation

struct ApiResponse:Codable {
    
    
    let total:Int
    let total_pages:Int
    let results:[ Result]
}


struct Result:Codable{
    let id:String
    let urls:URLS
}
struct URLS:Codable {
    let thumb : String
    let regular:String
}
