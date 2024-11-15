//
//  Product.swift
//  Swipe-iOS-Assignment
//
//  Created by Jayanth Ambaldhage on 15/11/24.
//
import Foundation

struct Product: Codable, Identifiable {
    var id: UUID
    var name: String
    var type: String
    var price: Double
    var tax: Double
    var imageUrl: String
    var isFavorite: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case imageUrl
        case price
        case name = "product_name"
        case type = "product_type"
        case tax
        case isFavorite
    }
    
    init(id: UUID = UUID(), name: String, type: String, price: Double, tax: Double, imageUrl: String, isFavorite: Bool = false) {
        self.id = id
        self.name = name
        self.type = type
        self.price = price
        self.tax = tax
        self.imageUrl = imageUrl
        self.isFavorite = isFavorite
    }
    
}





