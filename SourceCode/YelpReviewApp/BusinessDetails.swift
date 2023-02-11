//
//  BusinessDetails.swift
//  YelpReviewApp
//
//  Created by Fernando Torres on 12/6/22.
//

import Foundation
import SwiftUI

var savedBusinessDetails:[String:BusinessDetails] = [:]

struct BusinessDetails: Identifiable, Codable, Hashable{
    let id: String
    let name: String
    let address: [String]
    let categories: [String]
    let phone: String
    let price: String
    let status: Bool?
    let url: String?
    let photos: [String]
    let coordinates: [Double?]
    
    init(id: String, name: String, address: [String], categories: [String], phone: String, price: String, status: Bool, url: String, photos: [String], coordinates: [Double]) {
        self.id = id
        self.name = name
        self.address = !address.isEmpty ? address : ["N/A"]
        self.categories = !categories.isEmpty ? categories : ["N/A"]
        self.phone = !phone.isEmpty ? phone : "N/A"
        self.price = !price.isEmpty ? price : "N/A"
        self.status = status
        self.url = url
        self.photos = photos
        self.coordinates = coordinates
    }
}

enum BusinessDetailsKeys: CodingKey{
    case id
    case name
    case address
    case categories
    case phone
    case price
    case status
    case url
    case photos
    case coordinates
}
