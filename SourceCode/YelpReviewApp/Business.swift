//
//  Business.swift
//  YelpReviewApp
//
//  Created by Fernando Torres on 12/6/22.
//

import Foundation
import SwiftUI

var savedBusiness: [Business] = []

struct Business: Identifiable, Codable, Hashable{
    let num : Int
    let id : String
    let name : String
    let rating : Double
    let distance : Double
    let imageURL : String
    
    init(num: Int, id: String, name: String, rating: Double, distance: Double, imageURL: String) {
        self.num = num
        self.id = id
        self.name = name
        self.rating = rating
        self.distance = distance
        self.imageURL = !imageURL.isEmpty ? imageURL : "https://1000logos.net/wp-content/uploads/2018/03/Yelp-Logo.jpg"
    }
}

enum BusinessKeys: CodingKey {
    case num
    case id
    case name
    case rating
    case distance
    case imageURL
}

