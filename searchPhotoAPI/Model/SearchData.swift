//
//  SearchData.swift
//  searchPhotoAPI
//
//  Created by admin on 10/24/21.
//

import Foundation
struct APIResponse: Codable {
    let images_results: [Image]
}
struct Image: Codable {
    let thumbnail: String
}
