//
//  Reviews.swift
//  YelpReviewApp
//
//  Created by Fernando Torres on 12/8/22.
//

import Foundation
import SwiftUI

var savedReviews : [String : [Reviews]] = [:]

struct Reviews: Identifiable, Codable, Hashable{
    let id : String
    let name: String
    let rate : Double
    let date : String
    let reviewText : String
    
    init(id: String, name: String, rate: Double, date: String, reviewText: String) {
        self.id = id
        self.name = name
        self.rate = rate
        self.date = date
        self.reviewText = reviewText
    }
}

enum ReviewsKeys: CodingKey{
    case id
    case name
    case rating
    case date
    case reviewText
}
